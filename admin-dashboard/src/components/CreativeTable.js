import DecisionBadge from "./DecisionBadge";

export default function CreativeTable({ creatives }) {
  return (
    <table border="1" cellPadding="10" style={{ width: "100%" }}>
      <thead>
        <tr>
          <th>Creative ID</th>
          <th>Usage</th>
          <th>Decision</th>
        </tr>
      </thead>

      <tbody>
        {creatives.map((c, i) => (
          <tr key={i}>
            <td>{c.creative_id}</td>
            <td>{c.usage}</td>
            <td><DecisionBadge usage={c.usage} /></td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}
