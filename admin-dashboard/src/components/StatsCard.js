export default function StatsCard({ title, value }) {
  return (
    <div style={{
      border: "1px solid #ddd",
      padding: "15px",
      borderRadius: "8px",
      width: "200px"
    }}>
      <h4>{title}</h4>
      <b>{value}</b>
    </div>
  );
}
