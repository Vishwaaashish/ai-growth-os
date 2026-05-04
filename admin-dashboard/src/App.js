import React, { useEffect, useState } from "react";
import axios from "axios";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

const API = "http://127.0.0.1:8000";

function App() {
  const [creatives, setCreatives] = useState([]);
  const [actions, setActions] = useState([]);
  const [policies, setPolicies] = useState([]);
  const [search, setSearch] = useState("");

  useEffect(() => {
    fetchAll();
    const interval = setInterval(fetchAll, 5000); // live refresh
    return () => clearInterval(interval);
  }, []);

  const fetchAll = async () => {
    const [c, a, p] = await Promise.all([
      axios.get(`${API}/dashboard/creatives`),
      axios.get(`${API}/dashboard/actions`),
      axios.get(`${API}/dashboard/policies`),
    ]);

    setCreatives(c.data || []);
    setActions(a.data || []);
    setPolicies(p.data || []);
  };

  if (!creatives.length) return <div style={center}>Loading...</div>;

  /* ========================= */
  /* METRICS */
  /* ========================= */

  const total = creatives.length;
  const avg_ctr = avg(creatives, "ctr");
  const avg_roas = avg(creatives, "roas");
  const avg_cpa = avg(creatives, "cpa");

  const winner = [...creatives].sort((a, b) => b.roas - a.roas)[0];

  const filtered = creatives.filter((c) =>
    c.creative_id.toLowerCase().includes(search.toLowerCase()),
  );

  /* ========================= */
  /* CHART DATA */
  /* ========================= */

  const chartData = creatives.slice(0, 20).map((c) => ({
    name: c.creative_id.slice(0, 5),
    roas: c.roas,
  }));

  return (
    <div style={container}>
      {/* HEADER */}
      <div style={header}>
        <h1>AI Growth OS</h1>
        <input
          placeholder="Search creative..."
          style={input}
          onChange={(e) => setSearch(e.target.value)}
        />
      </div>

      {/* KPI CARDS */}
      <div style={grid}>
        <Card label="Total" value={total} />
        <Card label="CTR" value={avg_ctr} />
        <Card label="ROAS" value={avg_roas} />
        <Card label="CPA" value={avg_cpa} />
      </div>

      {/* CHART */}
      <div style={card}>
        <h3>ROAS Trend</h3>
        <ResponsiveContainer width="100%" height={250}>
          <LineChart data={chartData}>
            <XAxis dataKey="name" />
            <YAxis />
            <Tooltip />
            <Line type="monotone" dataKey="roas" />
          </LineChart>
        </ResponsiveContainer>
      </div>

      {/* WINNER */}
      <div style={{ ...card, background: "#ecfdf5" }}>
        🏆 Top Performer: {winner?.creative_id}
      </div>

      {/* CREATIVE TABLE */}
      <div style={card}>
        <h3>Creative Intelligence</h3>

        <h3>Top Policies</h3>
        {policies.slice(0, 5).map((p) => (
          <div key={p.policy_id}>
            {p.policy_id.slice(0, 8)} → {p.confidence.toFixed(2)}
          </div>
        ))}

        <table style={table}>
          <thead>
            <tr>
              <th>ID</th>
              <th>CTR</th>
              <th>ROAS</th>
              <th>CPA</th>
              <th>Decision</th>
            </tr>
          </thead>

          <tbody>
            {filtered.slice(0, 50).map((c) => (
              <tr key={c.creative_id}>
                <td>{c.creative_id.slice(0, 8)}</td>
                <td>{c.ctr}</td>
                <td>{c.roas}</td>
                <td>{c.cpa}</td>
                <td>
                  <span style={badge(c.decision)}>{c.decision}</span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* ACTION STREAM */}
      <div style={card}>
        <h3>Live Decisions</h3>

        {actions.slice(0, 10).map((a) => (
          <div key={a.timestamp} style={log}>
            <b>{a.action}</b> → {a.decision}
          </div>
        ))}
      </div>
    </div>
  );
}

/* ========================= */
/* HELPERS */
/* ========================= */

const avg = (arr, key) =>
  (arr.reduce((s, a) => s + a[key], 0) / arr.length).toFixed(2);

/* ========================= */
/* UI COMPONENTS */
/* ========================= */

const Card = ({ label, value }) => (
  <div style={card}>
    <div style={labelStyle}>{label}</div>
    <div style={valueStyle}>{value}</div>
  </div>
);

/* ========================= */
/* STYLES */
/* ========================= */

const container = {
  padding: "30px",
  fontFamily: "Inter",
  background: "#0f172a",
  color: "white",
};

const header = {
  display: "flex",
  justifyContent: "space-between",
  marginBottom: "20px",
};

const input = {
  padding: "8px",
  borderRadius: "6px",
  border: "none",
};

const grid = {
  display: "grid",
  gridTemplateColumns: "repeat(4,1fr)",
  gap: "20px",
  marginBottom: "20px",
};

const card = {
  background: "#1e293b",
  padding: "20px",
  borderRadius: "12px",
  marginBottom: "20px",
};

const labelStyle = { color: "#94a3b8" };
const valueStyle = { fontSize: "24px", fontWeight: "bold" };

const table = {
  width: "100%",
  borderCollapse: "collapse",
};

const badge = (d) => ({
  padding: "4px 8px",
  borderRadius: "6px",
  background:
    d === "high_performance"
      ? "#16a34a"
      : d === "low_performance"
        ? "#dc2626"
        : "#facc15",
  color: "black",
});

const log = {
  padding: "8px",
  borderBottom: "1px solid #334155",
};

const center = {
  display: "flex",
  justifyContent: "center",
  alignItems: "center",
  height: "100vh",
};

export default App;
