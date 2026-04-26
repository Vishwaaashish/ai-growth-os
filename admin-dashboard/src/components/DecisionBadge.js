export default function DecisionBadge({ usage }) {
  let decision = "KILL";

  if (usage > 25) decision = "SCALE";
  else if (usage > 10) decision = "TEST";

  const color =
    decision === "SCALE"
      ? "green"
      : decision === "TEST"
      ? "orange"
      : "red";

  return (
    <span style={{
      color: "white",
      background: color,
      padding: "4px 8px",
      borderRadius: "6px"
    }}>
      {decision}
    </span>
  );
}
