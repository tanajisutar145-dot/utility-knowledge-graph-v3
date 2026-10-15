// Shared evidence-graph renderer: network or geo layout, optional IEC CIM class overlay, CIM-aware node card.
window.UKGGraph = (() => {
  "use strict";
  const { esc, api } = window.UKG;
  let model = null;
  let columns = {};

  async function loadModel() {
    if (model) return model;
    model = await api("/api/model");
    for (const t of model.tables) columns[t.label] = Object.fromEntries(t.columns.map((c) => [c.column, c]));
    return model;
  }

  const cssVar = (name) => getComputedStyle(document.documentElement).getPropertyValue(name).trim();
  const cimColor = () => (model && model.colors && model.colors.semantic) || "#9D755D";
  const std = () => (model && model.standard && model.standard.short) || "CIM";

  function geoPositions(nodes) {
    const located = nodes.filter((n) => n.lat != null && n.lon != null);
    if (!located.length) return {};
    const lat0 = located.reduce((a, n) => a + n.lat, 0) / located.length;
    const lon0 = located.reduce((a, n) => a + n.lon, 0) / located.length;
    const k = 18000;  // pixels per degree latitude (zoom adjusts)
    const c = Math.cos((lat0 * Math.PI) / 180);
    return Object.fromEntries(located.map((n) => [n.id, { x: (n.lon - lon0) * k * c, y: -(n.lat - lat0) * k }]));
  }

  function card(cardEl, n) {
    const s = n.std || {};
    const cols = columns[n.group] || {};
    const rows = Object.entries(n.props || {}).filter(([k, v]) => v !== null && v !== "" && !["cim_class", "cim_match",
      "cim_package", "cim_standard", "mrid"].includes(k)).map(([k, v]) => {
      const c = cols[k];
      const map = c && (c.standard_attribute || c.unit)
        ? `${c.standard_attribute ? esc(std() + ":" + c.standard_attribute) + (c.standard_match ? ` (${esc(c.standard_match)})` : "") : ""}${c.unit ? " · " + esc(c.unit) : ""}`
        : "";
      return `<tr class="${map ? "mapped" : ""}" title="${esc(c ? c.description : "")}"><td>${esc(k)}</td><td>${esc(v)}${map ? `<div class="map">${map}</div>` : ""}</td></tr>`;
    }).join("");
    const stdBlock = s.cim_class || n.group === "CimClass" ? `<div class="std">
        <div><span>${esc(std())} class</span><b>${esc(s.cim_class || n.label)}</b> ${s.cim_match ? `<span class="badge cim">${esc(s.cim_match)}</span>` : ""}</div>
        ${s.cim_package ? `<div><span>package</span>${esc(s.cim_package)}</div>` : ""}
        ${s.cim_standard ? `<div><span>standard</span>${esc(s.cim_standard)}</div>` : ""}
        ${s.mrid ? `<div><span>mRID</span><code>${esc(s.mrid)}</code></div>` : ""}
        ${(n.std_labels || []).length ? `<div><span>labels</span>${n.std_labels.map((l) => `<span class="badge cim">${esc(l)}</span>`).join(" ")}</div>` : ""}
      </div>` : "";
    cardEl.innerHTML = `<button type="button" aria-label="Close" class="nc-close">✕</button>
      <h4>${esc(n.group)} · ${esc(n.label)}</h4>${stdBlock}
      <table>${rows}</table>
      <p class="meta" style="margin-top:6px">Highlighted rows map to an ${esc(std())} attribute; hover a row for its ontology description.</p>`;
    cardEl.hidden = false;
    cardEl.querySelector(".nc-close").addEventListener("click", () => { cardEl.hidden = true; });
  }

  /**
   * Render `g` ({nodes, edges}) into `el`. opts: {geo, cim, edgeLabels, onEmpty}.
   * Returns the vis.Network instance.
   */
  function render(el, cardEl, g, opts = {}) {
    const ink = cssVar("--ink"), line = cssVar("--muted"), evidence = cssVar("--evidence");
    const pos = opts.geo ? geoPositions(g.nodes) : {};
    const visNodes = g.nodes.map((n) => {
      const p = pos[n.id];
      return {
        id: n.id, label: n.label, title: n.title, group: n.group,
        color: { background: n.color, border: n.evidence ? evidence : n.color, highlight: { background: n.color, border: ink } },
        borderWidth: n.evidence ? 4 : 1, font: { color: ink, size: 12 }, shape: n.group === "CimClass" ? "box" : "dot",
        size: n.evidence ? 15 : 11, ...(p ? { x: p.x, y: p.y, fixed: { x: true, y: true }, physics: false } : {}),
      };
    });
    const visEdges = g.edges.map((e) => ({
      id: e.id, from: e.from, to: e.to, label: opts.edgeLabels ? e.label : undefined, title: e.label + (e.cim ? `\n${std()} association: ${e.cim}` : ""),
      arrows: "to", font: { size: 9, color: line, strokeWidth: 0, align: "middle" }, color: { color: line, opacity: 0.6 },
    }));
    if (opts.cim) {
      const seen = new Set();
      for (const n of g.nodes) {
        const cls = n.std && n.std.cim_class;
        if (!cls || n.group === "CimClass") continue;
        const id = "cim:" + cls;
        if (!seen.has(id)) {
          seen.add(id);
          const info = (model && model.standard_classes[cls]) || {};
          visNodes.push({ id, label: `${std()}:${cls}`, shape: "box", group: "CimClass", font: { color: "#fff", size: 11 },
            color: { background: cimColor(), border: cimColor() },
            title: `${std()} class ${cls}\n${info.package || ""} · ${info.standard || ""}\n${info.comment || ""}` });
        }
        visEdges.push({ id: `cimrel:${n.id}`, from: n.id, to: id, dashes: true, arrows: "to", label: opts.edgeLabels ? (n.std.cim_match || "") : undefined,
          font: { size: 8, color: line, strokeWidth: 0 }, color: { color: cimColor(), opacity: 0.5 }, title: `specializes (${n.std.cim_match || ""})` });
      }
    }
    const options = {
      physics: opts.geo ? { solver: "barnesHut", barnesHut: { springLength: 60, gravitationalConstant: -1500 }, stabilization: { iterations: 150 } }
        : { solver: "forceAtlas2Based", forceAtlas2Based: { gravitationalConstant: -70, springLength: 120 }, stabilization: { iterations: 200 } },
      interaction: { hover: true, tooltipDelay: 150 },
      edges: { smooth: opts.geo ? false : { type: "dynamic" } },
    };
    const net = new vis.Network(el, { nodes: new vis.DataSet(visNodes), edges: new vis.DataSet(visEdges) }, options);
    net.on("click", (p) => {
      if (!p.nodes.length) { cardEl.hidden = true; return; }
      const n = g.nodes.find((x) => x.id === p.nodes[0]);
      if (n) card(cardEl, n);
      else {
        const v = visNodes.find((x) => x.id === p.nodes[0]);
        if (v) card(cardEl, { group: "CimClass", label: v.label, props: { description: v.title }, std: {} });
      }
    });
    return net;
  }

  function legend(el, domains, extra = "") {
    el.innerHTML = domains.map((d) => `<span><i style="background:${esc(d.color)}"></i>${esc(d.domain)}</span>`).join("")
      + `<span><i class="ev"></i>in retrieved context</span>` + extra;
  }

  return { loadModel, render, legend, cimColor, std };
})();
