import { useEffect, useState } from "react";
import { getDashboard, runJob } from "../api/api";

import StatsCard from "../components/StatsCard";
import CreativeTable from "../components/CreativeTable";
import WinnerCard from "../components/WinnerCard";

export default function Dashboard() {
  const [data, setData] = useState([]);

  const load = async () => {
    const res = await getDashboard();
    setData(res);
  };

  useEffect(() => {
    load();
    const interval = setInterval(load, 5000);
    return () => clearInterval(interval);
  }, []);

  if (!data.length) return <div>Loading...</div>;

  // ✅ CALCULATE PERFORMANCE FROM REAL METRICS
  const total_creatives = data.length;

  const avg_ctr =
    data.reduce((sum, c) => sum + c.ctr, 0) / total_creatives;

  const avg_roas =
    data.reduce((sum, c) => sum + c.roas, 0) / total_creatives;

  const avg_cpa =
    data.reduce((sum, c) => sum + c.cpa, 0) / total_creatives;

  // ✅ SORT BY ROAS (REAL WINNER)
  const sorted = [...data].sort((a, b) => b.roas - a.roas);
  const winner = sorted[0];

  return (
    <div style={{ padding: 20 }}>
      <h2>AI Creative Intelligence OS</h2>

      {/* ACTION */}
      <button onClick={runJob}>Run AI Job</button>

      {/* STATS */}
      <div style={{ display: "flex", gap: 20, marginTop: 20 }}>
        <StatsCard title="Creatives" value={total_creatives} />
        <StatsCard title="CTR" value={avg_ctr.toFixed(3)} />
        <StatsCard title="ROAS" value={avg_roas.toFixed(2)} />
        <StatsCard title="CPA" value={avg_cpa.toFixed(2)} />
      </div>

      {/* WINNER */}
      <WinnerCard winner={winner} />

      {/* TABLE */}
      <CreativeTable creatives={sorted} />
    </div>
  );
}
