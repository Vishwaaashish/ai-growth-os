export default function WinnerCard({ winner }) {
  if (!winner) return null;

  return (
    <div style={{
      background: "#e6ffe6",
      padding: "10px",
      marginBottom: "20px"
    }}>
      🏆 Winner: {winner.creative_id} (Usage: {winner.usage})
    </div>
  );
}
