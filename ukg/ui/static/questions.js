// Question library window: lists demo + recommended questions and sends the chosen one to the chat window.
(() => {
  "use strict";
  const { esc, labelOf, api } = window.UKG;
  const $ = (id) => document.getElementById(id);
  const channel = "BroadcastChannel" in window ? new BroadcastChannel("ukg-chat") : null;
  let all = [];

  function card(q) {
    return `<article class="q-card" data-id="${esc(q.id)}">
      <div class="q-top"><span class="id">${esc(q.id)}</span><h3>${esc(q.title)}</h3></div>
      ${q.use_case ? `<p class="q-pattern" style="color:var(--accent)">${esc(q.use_case)}</p>` : ""}
      <p class="q-text">${esc(q.question)}</p>
      <p class="q-pattern">${esc(q.pattern)}</p>
      <div class="q-foot">
        <span class="pill">${esc(labelOf(q.retriever))}</span>
        <button type="button" class="ask-btn" data-id="${esc(q.id)}">Ask this question</button>
      </div>
    </article>`;
  }

  function render(filter) {
    const f = (filter || "").toLowerCase();
    const match = (q) => !f || `${q.id} ${q.title} ${q.question} ${q.pattern} ${q.use_case || ''}`.toLowerCase().includes(f);
    $("demo").innerHTML = all.filter((q) => q.kind === "demo" && match(q)).map(card).join("") || "<p class='empty'>No match.</p>";
    $("sample").innerHTML = all.filter((q) => q.kind === "sample" && match(q)).map(card).join("") || "<p class='empty'>No match.</p>";
  }

  function send(q) {
    let result = null;
    try {
      if (window.opener && !window.opener.closed && window.opener.ukgAsk) {
        result = window.opener.ukgAsk(q.question);
        if (result.ok) window.opener.focus();
      }
    } catch (_) { /* chat window gone or not reachable */ }
    if (!result && channel) {  // opened directly (no opener): hand over via the shared channel
      channel.postMessage({ type: "ask", question: q.question });
      result = { ok: true };
    }
    if (result && result.ok) {
      $("q-status").textContent = `Sent ${q.id} to the chat.`;
      setTimeout(() => window.close(), 600);
    } else if (result && result.reason === "busy") {
      $("q-status").textContent = "The chat is still answering the previous question. Pick again when it has finished.";
    } else {
      $("q-status").textContent = "The chat window is not open. Open Utility Knowledge Graph Explorer first, then pick the question again.";
    }
  }

  document.addEventListener("click", (e) => {
    const b = e.target.closest(".ask-btn");
    if (!b) return;
    const q = all.find((x) => x.id === b.dataset.id);
    if (q) send(q);
  });
  $("filter").addEventListener("input", (e) => render(e.target.value));

  api("/api/info").then((info) => {
    all = [...info.demo_questions, ...info.sample_questions];
    render("");
  }).catch((e) => { $("q-status").textContent = `Could not load the questions: ${e.message}`; });
})();
