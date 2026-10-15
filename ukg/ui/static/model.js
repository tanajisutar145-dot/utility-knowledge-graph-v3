// Model & CIM explorer: ontology classes, their IEC CIM alignment, column -> CIM attribute mappings, relationships.
(() => {
  "use strict";
  const { esc, api } = window.UKG;
  const $ = (id) => document.getElementById(id);
  let M = null, byLabel = {}, net = null, current = null;

  const colorOf = (schema) => (M.colors && M.colors[schema]) || "#888";
  const S = () => (M.standard && M.standard.short) || "CIM";

  function kpis() {
    const cols = M.tables.reduce((a, t) => a + t.columns.length, 0);
    const mapped = M.tables.reduce((a, t) => a + t.columns.filter((c) => c.standard_attribute).length, 0);
    const exact = M.tables.filter((t) => t.standard_match === "exact").length;
    $("m-kpis").innerHTML = [["Classes", M.tables.length], [`${S()} classes`, Object.keys(M.standard_classes).length],
      ["Exact matches", `${exact}/${M.tables.length}`], ["Columns", cols], [`Mapped to ${S()}`, `${mapped} (${Math.round(100 * mapped / cols)}%)`],
      ["Relationships", M.relationships.length]].map(([k, v]) => `<div><dt>${esc(k)}</dt><dd>${esc(v)}</dd></div>`).join("");
    $("m-sub").textContent = `How every in-scope table, column and relationship is aligned to ${M.standard.name} (${M.namespace})`;
  }

  function list(filter) {
    const f = (filter || "").toLowerCase();
    const html = M.domains.map((d) => {
      const items = M.tables.filter((t) => t.schema === d.domain && (!f || `${t.label} ${t.table} ${t.standard_class} ${t.standard_package}`.toLowerCase().includes(f)));
      if (!items.length) return "";
      return `<h3><i style="background:${esc(d.color)}"></i>${esc(d.domain)} <span class="meta">${items.length}</span></h3>` + items.map((t) =>
        `<button type="button" data-l="${esc(t.label)}" aria-current="${current === t.label}"><span>${esc(t.label)}</span>
         <span class="badge cim" title="${esc(t.standard_package || "")}">${esc(t.standard_class || "-")}</span></button>`).join("");
    }).join("");
    $("m-list").innerHTML = html || "<p class='empty'>No match.</p>";
    $("m-list").querySelectorAll("button").forEach((b) => b.addEventListener("click", () => show(b.dataset.l)));
  }

  function node(id, label, group, color, title, shape = "dot") {
    return { id, label, group, color: { background: color, border: color }, title, shape, font: { size: 12, color: shape === "box" ? "#fff" : getComputedStyle(document.documentElement).getPropertyValue("--ink") } };
  }

  function drawNet(nodes, edges) {
    if (net) net.destroy();
    net = new vis.Network($("m-net"), { nodes: new vis.DataSet(nodes), edges: new vis.DataSet(edges) }, {
      physics: { solver: "forceAtlas2Based", forceAtlas2Based: { gravitationalConstant: -80, springLength: 110 }, stabilization: { iterations: 200 } },
      edges: { smooth: { type: "dynamic" }, font: { size: 9, strokeWidth: 0, align: "middle" }, arrows: "to", color: { color: "#9AA0A6" } },
      interaction: { hover: true },
    });
    net.on("doubleClick", (p) => { if (p.nodes.length && byLabel[p.nodes[0]]) show(p.nodes[0]); });
  }

  function cimChain(cls, nodes, edges, seen) {
    let c = cls;
    while (c && M.standard_classes[c] && !seen.has("cim:" + c)) {
      const info = M.standard_classes[c];
      seen.add("cim:" + c);
      nodes.push(node("cim:" + c, `${S()}:${c}`, "CimClass", window.UKGGraph.cimColor(), `${c}\n${info.package || ""} · ${info.standard || ""}\n${info.comment || ""}`, "box"));
      const parent = (info.parents || [])[0];
      if (parent && M.standard_classes[parent]) edges.push({ from: "cim:" + c, to: "cim:" + parent, label: "SUBCLASS_OF", dashes: true });
      c = parent;
    }
  }

  function overview() {
    current = null;
    list($("m-filter").value);
    const nodes = [], edges = [], seen = new Set();
    for (const t of M.tables) {
      nodes.push(node(t.label, t.label, t.schema, colorOf(t.schema), `${t.table}\n${S()} ${t.standard_class} (${t.standard_match})\n${t.standard_package || ""}`));
      if (t.standard_class) {
        cimChain(t.standard_class, nodes, edges, seen);
        edges.push({ from: t.label, to: "cim:" + t.standard_class, label: t.standard_match, color: { color: window.UKGGraph.cimColor() } });
      }
    }
    drawNet(nodes, edges);
    $("m-head").innerHTML = `<h2>${esc(M.project.name || "Knowledge graph")} - semantic model</h2>
      <p>${M.tables.length} ontology classes in ${M.domains.length} subject areas, each specialising an ${esc(M.standard.name)} class. Coloured dots are ontology
      classes (by subject area); brown boxes are ${esc(S())} classes with their superclass chain. Double-click a class for its columns and relationships.</p>`;
    $("m-legend").innerHTML = M.domains.map((d) => `<span><i style="background:${esc(d.color)}"></i>${esc(d.domain)}</span>`).join("")
      + `<span><i style="background:${window.UKGGraph.cimColor()}"></i>${esc(S())} class</span>`;
    const rows = M.tables.map((t) => `<tr><td><span class="badge" style="border-color:${colorOf(t.schema)}">${esc(t.schema)}</span></td><td class="mono">${esc(t.label)}</td>
      <td class="mono">${esc(t.table)}</td><td><span class="badge cim">${esc(S())}:${esc(t.standard_class || "-")}</span></td><td>${esc(t.standard_match || "")}</td>
      <td>${esc(t.standard_package || "")}</td><td>${esc(t.standard_standard || "")}</td><td>${t.columns.filter((c) => c.standard_attribute).length}/${t.columns.length}</td></tr>`).join("");
    $("m-tables").innerHTML = `<table><thead><tr><th>Area</th><th>Class</th><th>Table</th><th>${esc(S())} class</th><th>Match</th><th>Package</th><th>Standard</th><th>Mapped columns</th></tr></thead><tbody>${rows}</tbody></table>`;
  }

  function show(label) {
    const t = byLabel[label];
    if (!t) return;
    current = label;
    list($("m-filter").value);
    const out = M.relationships.filter((r) => r.from === label);
    const inc = M.relationships.filter((r) => r.to === label && r.from !== label);
    const nodes = [node(label, label, t.schema, colorOf(t.schema), t.description)];
    const edges = [];
    const seen = new Set([label]);
    for (const r of out.concat(inc)) {
      const other = r.from === label ? r.to : r.from;
      if (!seen.has(other)) { seen.add(other); const o = byLabel[other]; nodes.push(node(other, other, o ? o.schema : "", colorOf(o ? o.schema : ""), o ? `${o.table}\n${S()} ${o.standard_class}` : other)); }
      edges.push({ from: r.from, to: r.to, label: r.type, title: `${r.fk}${r.standard_association ? `\n${S()} association ${r.standard_association}` : ""}` });
    }
    if (t.standard_class) {
      cimChain(t.standard_class, nodes, edges, new Set());
      edges.push({ from: label, to: "cim:" + t.standard_class, label: `specializes (${t.standard_match})`, color: { color: window.UKGGraph.cimColor() }, width: 2 });
    }
    drawNet(nodes, edges);
    $("m-legend").innerHTML = `<span><i style="background:${window.UKGGraph.cimColor()}"></i>${esc(S())} class chain</span><span>edges = FK object properties (hover: ${esc(S())} association)</span>`;
    const chain = [t.label, ...(t.standard_class ? [`${S()}:${t.standard_class}`] : []), ...t.standard_ancestors.map((a) => `${S()}:${a}`), ...(M.standard.root_class ? [`${S()}:${M.standard.root_class}`] : [])];
    const mapped = t.columns.filter((c) => c.standard_attribute).length;
    $("m-head").innerHTML = `<h2>${esc(t.label)} <span class="badge cim">${esc(S())}:${esc(t.standard_class || "-")} · ${esc(t.standard_match || "-")}</span></h2>
      <p>${esc(t.description)}</p>
      <div class="chain">${chain.map((c, i) => `${i ? '<span class="arrow">⊑</span>' : ""}<span class="badge ${i ? "cim" : ""}">${esc(c)}</span>`).join("")}</div>
      <dl class="kpis" style="margin-top:8px">${[["Table", t.table], ["Package", t.standard_package || "-"], ["Standard", t.standard_standard || "-"],
        ["Subject areas", t.subject_areas.join(", ") || "-"], ["Location role", t.location_role || "-"], ["Columns mapped", `${mapped}/${t.columns.length}`],
        ["Resolved by", t.resolution]].map(([k, v]) => `<div><dt>${esc(k)}</dt><dd>${esc(v)}</dd></div>`).join("")}</dl>
      <p style="margin-top:6px"><button type="button" class="ghost" id="m-sample">Show sample instances from the graph</button> <span class="meta" id="m-sample-st"></span></p>`;
    $("m-sample").addEventListener("click", () => sample(label));
    const colRows = t.columns.map((c) => `<tr><td class="mono">${esc(c.column)}${c.nullable ? "" : " *"}</td><td class="mono">${esc(c.sql_type)}</td>
      <td>${c.standard_attribute ? `<span class="badge cim">${esc(S())}:${esc(c.standard_attribute)}</span>` : '<span class="none">-</span>'}</td>
      <td>${esc(c.standard_match || "")}</td><td class="mono">${esc(c.unit || "")}</td><td>${esc(c.datatype || "")}</td><td>${esc(c.business_term || "")}</td>
      <td>${esc(c.description)}${c.enum_values.length ? `<div class="meta">${esc(c.enum_values.join(" | "))}</div>` : ""}</td></tr>`).join("");
    const relRows = out.map((r) => ["→", r]).concat(inc.map((r) => ["←", r])).map(([dir, r]) => `<tr><td>${dir}</td><td class="mono">${esc(r.type)}</td>
      <td class="mono">${esc(dir === "→" ? r.to : r.from)}</td><td>${r.standard_association ? `<span class="badge cim">${esc(r.standard_association)}</span>` : "-"}</td>
      <td class="mono">${esc(r.fk)}</td><td>${r.cross_domain ? "cross-domain" : ""}</td></tr>`).join("");
    $("m-tables").innerHTML = `<h3 class="q-h">Columns <span>${mapped} mapped to ${esc(S())} attributes · * = NOT NULL</span></h3>
      <table><thead><tr><th>Column</th><th>SQL type</th><th>${esc(S())} attribute</th><th>Match</th><th>Unit</th><th>${esc(S())} datatype</th><th>Business term</th><th>Description</th></tr></thead><tbody>${colRows}</tbody></table>
      <h3 class="q-h" style="margin-top:14px">Relationships <span>FK object properties with their ${esc(S())} association role</span></h3>
      <table><thead><tr><th></th><th>Type</th><th>Class</th><th>${esc(S())} association</th><th>FK column</th><th></th></tr></thead><tbody>${relRows || "<tr><td colspan=6>none</td></tr>"}</tbody></table>`;
  }

  async function sample(label) {
    $("m-sample-st").textContent = "loading…";
    try {
      const g = await api(`/api/class/${encodeURIComponent(label)}?limit=10`);
      if (net) net.destroy();
      net = window.UKGGraph.render($("m-net"), $("m-card"), g, { cim: true, edgeLabels: true });
      $("m-sample-st").textContent = `${g.nodes.length} nodes · ${g.edges.length} rels (instances with their ${S()} class)`;
    } catch (e) {
      $("m-sample-st").textContent = `knowledge graph not available: ${e.message}`;
    }
  }

  $("m-filter").addEventListener("input", (e) => list(e.target.value));
  $("overview").addEventListener("click", overview);
  window.UKGGraph.loadModel().then((m) => {
    M = m;
    byLabel = Object.fromEntries(M.tables.map((t) => [t.label, t]));
    kpis();
    const hash = decodeURIComponent(location.hash.slice(1));
    if (byLabel[hash]) show(hash); else overview();
  }).catch((e) => { $("m-head").innerHTML = `<p>Could not load the semantic model: ${esc(e.message)}. Run <code>python -m ukg run --step model</code>.</p>`; });
})();
