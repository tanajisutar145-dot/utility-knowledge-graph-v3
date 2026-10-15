// "How it was checked" window: follows the latest question and renders its full backend trace.
(() => {
  "use strict";
  const { esc, labelOf, api, progress, renderSteps } = window.UKG;
  const $ = (id) => document.getElementById(id);
  const memo = { sig: "", jobId: null };

  async function tick() {
    let job = null;
    try {
      job = await api("/api/jobs/latest");
    } catch (_) { /* no job yet, or server restarting */ }
    if (job && job.id) {
      $("tq").textContent = job.question;
      const p = progress(job);
      const pills = [`<span class="pill ${job.status === "error" ? "bad" : job.status === "done" ? "ok" : ""}">${esc(p.running ? "running · " + p.text : p.text)}</span>`];
      if (job.retriever) pills.push(`<span class="pill">answered with ${esc(labelOf(job.retriever))}</span>`);
      pills.push(`<span class="pill mono">mode ${esc(job.mode)}</span>`);
      $("tmeta").innerHTML = pills.join("");
      document.title = `${p.running ? "● " : ""}How It Was Checked`;
      // First render of a job opens the parts people usually want to read.
      renderSteps($("steps"), job, memo, ["ret0", "ret1", "gt"]);
    }
    setTimeout(tick, job && job.status !== "done" && job.status !== "error" ? 1000 : 2500);
  }

  const setAll = (open) => document.querySelectorAll("#steps details").forEach((d) => { d.open = open; });
  $("expand-all").addEventListener("click", () => setAll(true));
  $("collapse-all").addEventListener("click", () => setAll(false));
  tick();
})();
