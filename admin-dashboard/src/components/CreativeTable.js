export default function CreativeTable({ creatives }) {
  return (
    <table border="1" cellPadding="10" style={{ width: "100%" }}>
      <thead>
        <tr>
          <th>Creative ID</th>
          <th>CTR</th>
          <th>CPA</th>
          <th>ROAS</th>
          <th>Decision</th>
          <th>Action</th>
        </tr>
      </thead>

      <tbody>
        {creatives.map((c, i) => (
          <tr key={i}>
            <td>{c.creative_id}</td>
            <td>{c.ctr}</td>
            <td>{c.cpa}</td>
            <td>{c.roas}</td>

            {/* ✅ DECISION WITH COLOR */}
            <td>
              <span
                style={{
                  fontWeight: "bold",
                  color:
                    c.decision === "scale"
                      ? "green"
                      : c.decision === "test"
                        ? "orange"
                        : c.decision === "kill"
                          ? "red"
                          : "gray",
                }}
              >
                {(c.decision || "-").toUpperCase()}
              </span>
            </td>

            {/* ✅ ACTION */}
            <td>{c.action || "-"}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}
