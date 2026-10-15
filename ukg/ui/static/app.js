// Utility Knowledge Graph Explorer - chat front end.
(() => {
  "use strict";

  const $ = (id) => document.getElementById(id);
  const { esc, secs, labelOf, api, progress } = window.UKG;
  const state = { info: null, history: [], busy: false, network: null, job: null, runIndex: 0, graph: null };

  // Minimal Markdown: headings, bold/italic, inline code, bullet + numbered lists, paragraphs.
  function md(text) {
    const lines = esc(text).split(/\r?\n/);
    let html = "", list = null;
    const inline = (t) => t.replace(/`([^`]+)`/g, "<code>$1</code>").replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>")
      .replace(/(^|[^*])\*([^*]+)\*/g, "$1<em>$2</em>");
    const close = () => { if (list) { html += `</${list}>`; list = null; } };
    for (const raw of lines) {
      const line = raw.trimEnd();
      let m;
      if ((m = line.match(/^\s*[-*]\s+(.*)/))) { if (list !== "ul") { close(); html += "<ul>"; list = "ul"; } html += `<li>${inline(m[1])}</li>`; }
      else if ((m = line.match(/^\s*\d+[.)]\s+(.*)/))) { if (list !== "ol") { close(); html += "<ol>"; list = "ol"; } html += `<li>${inline(m[1])}</li>`; }
      else if ((m = line.match(/^#{1,6}\s+(.*)/))) { close(); html += `<h4>${inline(m[1])}</h4>`; }
      else if (!line.trim()) { close(); }
      else { close(); html += `<p>${inline(line)}</p>`; }
    }
    close();
    return html;
  }

  async function boot() {
    try { await window.UKGGraph.loadModel(); } catch (_) { /* model page data optional for the chat */ }
    try {
      state.info = await api("/api/info");
    } catch (e) {
      $("st-llm").textContent = "unavailable";
      addMsg("bot", `The server could not reach the knowledge graph: ${e.message}\nThe Model & CIM page still works.`);
      return;
    }
    const i = state.info;
    if (i.project && i.project.name) { $("title").textContent = i.project.name; document.title = i.project.name; }
    if (i.project && i.project.subtitle) $("subtitle").textContent = i.project.subtitle;
    $("st-llm").textContent = i.llm;
    $("st-emb").textContent = i.embedder;
    $("st-std").textContent = i.standard ? i.standard.name : "-";
    const nodes = i.labels.reduce((a, l) => a + l.count, 0);
    $("st-graph").textContent = `${i.database} · ${nodes} nodes · ${i.relationships} rels`;
    $("mode").innerHTML = i.retrievers.map((r) => `<option value="${r.id}">${esc(r.label)}</option>`).join("");
    window.UKGGraph.legend($("legend"), i.domains);
    if (!i.has_chunks) addMsg("bot", "Note: no embedded narrative chunks are loaded, so only Text2Cypher is available.");
  }

  function addMsg(role, text, tag) {
    const div = document.createElement("div");
    div.className = `msg ${role === "user" ? "user" : "bot"}`;
    div.textContent = text;
    if (tag) { const t = document.createElement("span"); t.className = "tag"; t.textContent = tag; div.appendChild(t); }
    $("thread").appendChild(div);
    $("thread").scrollTop = $("thread").scrollHeight;
    return div;
  }

  function brief(text) {
    const plain = String(text || "").replace(/[*#`>]/g, "").replace(/\s+/g, " ").trim();
    const sentences = plain.match(/[^.!?]+[.!?]+(\s|$)/g) || [plain];
    let out = "";
    for (const s of sentences) {
      if ((out + s).length > 260 && out) break;
      out += s;
      if (out.length > 140) break;
    }
    out = out.trim() || plain;
    return out.length > 300 ? out.slice(0, 297).trimEnd() + "…" : out;
  }

  async function ask() {
    const question = $("q").value.trim();
    if (!question || state.busy) return;
    state.busy = true;
    $("send").disabled = true;
    addMsg("user", question);
    $("q").value = "";
    let pending = null;
    try {
      const res = await api("/api/ask", { method: "POST", headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ question, mode: $("mode").value, history: state.history }) });
      if (res.reply) { addMsg("bot", res.reply); return; }
      pending = addMsg("bot", "Looking this up in the knowledge graph… the Detailed answer and Evidence graph panels fill in when it's ready.");
      pending.classList.add("pending");
      resetPanes();
      const job = await poll(res.job_id);
      pending.remove();
      if (job.status === "error") {
        addMsg("bot", `I couldn't answer that: ${job.error}\nOpen “How it was checked” for the step that failed.`);
      } else {
        const v = job.verification;
        const facts = v && (v.matched.length + v.missing.length) ? ` · ${v.matched.length}/${v.matched.length + v.missing.length} facts` : "";
        addMsg("bot", `${brief(job.answer)}\n\nSee the Detailed answer panel for the full answer, and the Evidence graph for the records it used.`,
          `${labelOf(job.retriever)} · ${secs(job.elapsed)}${facts}`);
        state.history.push({ role: "user", content: question }, { role: "assistant", content: job.answer });
      }
    } catch (e) {
      if (pending) pending.remove();
      addMsg("bot", `Request failed: ${e.message}`);
    } finally {
      state.busy = false;
      $("send").disabled = false;
    }
  }

  async function poll(id) {
    for (;;) {
      const job = await api(`/api/jobs/${id}`);
      state.job = job;
      renderTraceStatus(job);
      if (job.status === "done" || job.status === "error") {
        state.runIndex = 0;
        renderAnswer(job);
        state.graph = job.graph;
        renderGraph();
        return job;
      }
      await new Promise((r) => setTimeout(r, 1000));
    }
  }

  function resetPanes() {
    $("answer").innerHTML = `<p class="empty">Generating… local models can take a few minutes. Open “How it was checked” to follow each step live.</p>`;
    $("run-tabs").innerHTML = "";
    $("graph-meta").textContent = "";
    $("trace-status").textContent = "";
    $("node-card").hidden = true;
  }

  function renderAnswer(job) {
    if (job.status === "error") { $("answer").innerHTML = `<p class="pill bad">Error</p><p>${esc(job.error)}</p>`; return; }
    const runs = job.runs || [];
    $("run-tabs").innerHTML = runs.length > 1 ? runs.map((r, i) =>
      `<button type="button" class="tab" role="tab" aria-selected="${i === state.runIndex}" data-i="${i}">${esc(r.label)}${
        r.score != null ? ` · ${Math.round(r.score * 100)}%` : ""}</button>`).join("") : "";
    $("run-tabs").querySelectorAll(".tab").forEach((t) => t.addEventListener("click", () => { state.runIndex = Number(t.dataset.i); renderAnswer(job); }));
    const r = runs[state.runIndex] || {};
    const v = job.verification;
    const pills = [`<span class="pill">${esc(r.label || labelOf(job.retriever))}</span>`,
      `<span class="pill mono">retrieval ${secs(r.retrieval_s)} · generation ${secs(r.generation_s)}</span>`];
    if (r.error) pills.push(`<span class="pill bad">retriever error</span>`);
    if (r.score != null && v) {
      const cls = r.score >= 0.99 ? "ok" : r.score >= 0.5 ? "warn" : "bad";
      pills.push(`<span class="pill ${cls}">${r.matched.length}/${r.matched.length + r.missing.length} expected facts</span>`);
    }
    let html = `<div class="answer-meta">${pills.join("")}</div><div class="md">${md(r.answer || r.error || "")}</div>`;
    if (v && r.score != null) {
      html += `<div class="check"><h4>Fact check against the input data</h4><div class="facts">${
        r.matched.map((f) => `<span class="pill ok">✓ ${esc(f)}</span>`).join("")}${
        r.missing.map((f) => `<span class="pill bad">✗ ${esc(f)}</span>`).join("")}</div>
        <p class="expected"><b>Expected:</b> ${esc(v.expected_answer)}</p></div>`;
    }
    $("answer").innerHTML = html;
  }

  // ---------- graph ----------
  const opts = { geo: false };
  function renderGraph() {
    const g = state.graph || { nodes: [], edges: [] };
    const located = g.nodes.filter((n) => n.lat != null).length;
    const cims = new Set(g.nodes.map((n) => n.std && n.std.cim_class).filter(Boolean));
    $("graph-meta").textContent = g.nodes.length ? `${g.nodes.length} nodes · ${g.edges.length} rels · ${cims.size} CIM classes · ${located} located`
      : "no graph records matched this answer";
    if (state.network) state.network.destroy();
    state.network = window.UKGGraph.render($("network"), $("node-card"), g,
      { geo: opts.geo, cim: $("cim-layer").checked, edgeLabels: $("edge-labels").checked });
  }
  function setLayout(geo) {
    opts.geo = geo;
    $("lay-net").setAttribute("aria-pressed", String(!geo));
    $("lay-geo").setAttribute("aria-pressed", String(geo));
    renderGraph();
  }
  $("lay-net").addEventListener("click", () => setLayout(false));
  $("lay-geo").addEventListener("click", () => setLayout(true));
  $("cim-layer").addEventListener("change", renderGraph);
  $("edge-labels").addEventListener("change", renderGraph);

  // ---------- trace + question windows ----------
  function renderTraceStatus(job) {
    const p = progress(job);
    $("trace-status").innerHTML = p.running ? `<span class="live">${esc(p.text)}</span>` : esc(p.text);
  }
  $("open-trace").addEventListener("click", () => {
    const w = window.open("/trace", "ukg-trace", "width=1100,height=900,resizable=yes,scrollbars=yes");
    if (w) w.focus(); else addMsg("bot", "The browser blocked the pop-up window. Allow pop-ups for this page, or open /trace in a new window.");
  });
  window.ukgAsk = (question) => {
    if (state.busy) return { ok: false, reason: "busy" };
    $("q").value = question;
    ask();
    return { ok: true };
  };
  if ("BroadcastChannel" in window) {
    new BroadcastChannel("ukg-chat").onmessage = (e) => { if (e.data?.type === "ask") window.ukgAsk(e.data.question); };
  }
  $("open-questions").addEventListener("click", () => {
    const w = window.open("/questions", "ukg-questions", "width=1000,height=860,resizable=yes,scrollbars=yes");
    if (w) w.focus(); else addMsg("bot", "The browser blocked the pop-up window. Allow pop-ups for this page, or open /questions.");
  });
  new ResizeObserver(() => { if (state.network) { state.network.setSize("100%", "100%"); state.network.redraw(); } }).observe($("network"));

  $("composer").addEventListener("submit", (e) => { e.preventDefault(); ask(); });
  $("q").addEventListener("keydown", (e) => { if (e.key === "Enter" && !e.shiftKey) { e.preventDefault(); ask(); } });
  boot();
})();
