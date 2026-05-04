export default function DecisionBadge({ roas, cpa }) {
  let decision = "KILL";

  if (roas >= 3 && cpa <= 100) {
    decision = "SCALE";
  } else if (roas >= 2) {
    decision = "TEST";
  }

  const color =
    decision === "SCALE" ? "green" : decision === "TEST" ? "orange" : "red";

  return <span style={{ color, fontWeight: "bold" }}>{decision}</span>;
}
