// Shared helpers for the chat page and the "How it was checked" window.
window.UKG = (() => {
  "use strict";

  const esc = (s) => String(s ?? "").replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
  const secs = (s) => (s == null ? "" : `${Number(s).toFixed(s < 10 ? 1 : 0)}s`);
  const labelOf = (id) => ({ text2cypher: "Text2Cypher", vector_cypher: "Vector + graph", hybrid_cypher: "Hybrid + graph" }[id] || id);

  async function api(path, opts) {
    const res = await fetch(path, opts);
    const body = await res.json().catch(() => ({}));
    if (!res.ok) throw new Error(body.detail || `${res.status} ${res.statusText}`);
    return body;
  }

  function table(rows) {
    if (!rows || !rows.length) return "<p>No rows.</p>";
    const keys = Object.keys(rows[0]);
    const cell = (v) => esc(typeof v === "object" && v !== null ? JSON.stringify(v) : v);
    return `<div class="tbl-wrap"><table><thead><tr>${keys.map((k) => `<th>${esc(k)}</th>`).join("")}</tr></thead>
      <tbody>${rows.map((r) => `<tr>${keys.map((k) => `<td>${cell(r[k])}</td>`).join("")}</tr>`).join("")}</tbody></table></div>`;
  }

  /** One-line progress: current step while running, outcome when finished. */
  function progress(job) {
    const idx = job.steps.findIndex((s) => s.status === "running");
    if (idx >= 0) {
      return { running: true, text: `step ${idx + 1} of ${job.steps.length}: ${job.steps[idx].title.replace(/^\d+\.\s*/, "")} · ${secs(job.elapsed)}` };
    }
    const fallback = job.steps[0]?.detail?.fallback ? " · fallback used" : "";
    return { running: job.status === "queued", text: `${job.status} · ${secs(job.elapsed)}${fallback}` };
  }

  function det(key, label, body, open) {
    return `<details data-k="${key}" ${open.has(key) ? "open" : ""}><summary>${esc(label)}</summary>${body}</details>`;
  }

  function stepDetail(s, open) {
    const d = s.detail || {};
    switch (s.key) {
      case "route":
        return `<p>${esc(d.reason || "")}</p>${d.fallback ? `<p class="note">${esc(d.fallback)}</p>` : ""}`;
      case "retrieve":
        return (d.runs || []).map((r, i) => {
          let body = "";
          if (r.error) body += `<p class="note">${esc(r.error)}</p>`;
          if (r.cypher) body += `<p>Cypher written by the LLM (validated read-only with EXPLAIN before running):</p><pre>${esc(r.cypher)}</pre>`;
          if (r.retrieval_query) body += `<p>Graph expansion run for each matched chunk:</p><pre>${esc(r.retrieval_query)}</pre>`;
          if (r.paths && r.paths.length) body += `<p>Graph paths returned:</p><pre>${esc(r.paths.join("\n"))}</pre>`;
          return det(`ret${i}`, `${r.label}: ${r.items} item(s) in ${secs(r.seconds)}${r.error ? " (failed)" : ""}`, body || "<p>No detail.</p>", open);
        }).join("");
      case "context":
        return (d.runs || []).map((r, i) => det(`ctx${i}`, `${labelOf(r.retriever)} context (${r.items.length} item(s))`,
          `<pre>${esc(r.items.join("\n---\n") || "(empty)")}</pre>`, open)).join("");
      case "generate":
        return d.model ? det("gen", "Prompt instructions", `<pre>${esc(d.system_prompt)}</pre><p>Previous chat turns included: ${d.history_turns}</p>`, open) : "";
      case "graph":
        return d.cypher ? det("gq", "Subgraph query", `<pre>${esc(d.cypher)}</pre>`, open) : (d.source ? `<p>From ${esc(d.source)}.</p>` : "");
      case "verify": {
        let body = (d.checks || []).map((c) => `<p>✓ ${esc(c)}</p>`).join("");
        if (d.ground_truth_cypher) {
          body += det("gt", `Ground truth: deterministic Cypher, ${d.ground_truth.length} row(s)`,
            `<pre>${esc(d.ground_truth_cypher)}</pre>${table(d.ground_truth)}`, open);
        }
        return body;
      }
      default:
        return "";
    }
  }

  /**
   * Render the step list into `el`. Re-renders only when something changed and
   * keeps open <details> open. `defaultOpen` lists detail keys to open the first time.
   */
  function renderSteps(el, job, memo, defaultOpen = []) {
    const sig = JSON.stringify([job.id, job.steps.map((s) => [s.status, s.summary, s.seconds])]);
    if (sig === memo.sig) return false;
    const sameJob = memo.jobId === job.id;
    memo.sig = sig;
    memo.jobId = job.id;
    const open = sameJob
      ? new Set([...el.querySelectorAll("details[open]")].map((d) => d.dataset.k))
      : new Set(defaultOpen);
    el.innerHTML = job.steps.map((s) => `
      <li class="step ${s.status}"><span class="dot" aria-hidden="true"></span><div>
        <b>${esc(s.title)}</b><span class="sum">${esc(s.summary)}${s.seconds != null && s.status !== "running" ? ` · ${secs(s.seconds)}` : ""}</span>
        ${stepDetail(s, open)}
      </div></li>`).join("");
    return true;
  }

  return { esc, secs, labelOf, api, table, progress, renderSteps };
})();
