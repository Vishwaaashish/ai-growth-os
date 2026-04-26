import { useEffect, useState } from "react";
import { getDashboard, runJob } from "../api/api";

import StatsCard from "../components/StatsCard";
import CreativeTable from "../components/CreativeTable";
import WinnerCard from "../components/WinnerCard";

export default function Dashboard() {
  const [data, setData] = useState(null);

  const load = async () => {
    const res = await getDashboard();
    setData(res);
  };

  useEffect(() => {
    load();
    const interval = setInterval(load, 5000);
    return () => clearInterval(interval);
  }, []);

  if (!data) return <div>Loading...</div>;

  const { total_creatives, top_creatives, performance } = data;
  const winner = top_creatives?.[0];

  return (
    <div style={{ padding: 20 }}>
      <h2>AI Creative Intelligence OS</h2>

      {/* ACTION */}
      <button onClick={runJob}>Run AI Job</button>

      {/* STATS */}
      <div style={{ display: "flex", gap: 20, marginTop: 20 }}>
        <StatsCard title="Creatives" value={total_creatives} />
        <StatsCard title="CTR" value={performance.avg_ctr.toFixed(2)} />
        <StatsCard title="ROAS" value={performance.avg_roas.toFixed(2)} />
        <StatsCard title="CPA" value={performance.avg_cpa.toFixed(2)} />
      </div>

      {/* WINNER */}
      <WinnerCard winner={winner} />

      {/* TABLE */}
      <CreativeTable creatives={top_creatives} />
    </div>
  );
}
