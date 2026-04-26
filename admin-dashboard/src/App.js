import React, { useEffect, useState } from "react";
import axios from "axios";
import Login from "./Login";

const API = "http://127.0.0.1:8000";

function App() {
  const [health, setHealth] = useState({});
  const [invoices, setInvoices] = useState([]);
  const [invoiceId, setInvoiceId] = useState("");
  const [loading, setLoading] = useState(false);
  const [token, setToken] = useState(localStorage.getItem("token"));

  const [usageLogs, setUsageLogs] = useState([]);
  const [auditLogs, setAuditLogs] = useState([]);

  const [dashboard, setDashboard] = useState(null); // 🔥 AI SYSTEM

  const [loadingUsage, setLoadingUsage] = useState(false);
  const [loadingAudit, setLoadingAudit] = useState(false);

  const getTenantId = () => {
    try {
      return JSON.parse(atob(token.split(".")[1])).tenant_id;
    } catch {
      return null;
    }
  };

  const getRole = () => {
    try {
      return JSON.parse(atob(token.split(".")[1])).role;
    } catch {
      return null;
    }
  };

  const [activeTenant, setActiveTenant] = useState(getTenantId());

  const authHeader = {
    headers: { Authorization: `Bearer ${token}` },
  };

  // =========================
  // 🔹 AI DASHBOARD FETCH
  // =========================
  const fetchDashboard = async () => {
    try {
      const res = await axios.get(`${API}/dashboard`);
      setDashboard(res.data);
    } catch (err) {
      console.error("Dashboard Error:", err);
    }
  };

  const runAIJob = async () => {
    try {
      await axios.post(
        `${API}/job`,
        {
          type: "ai",
          payload: { product_id: "test_product" },
        },
        {
          headers: {
            "x-api-key": "test_key_123",
          },
        }
      );
      fetchDashboard();
    } catch (err) {
      console.error("AI Job Error:", err);
    }
  };

  const decisionLogic = (usage) => {
    if (usage > 25) return "SCALE";
    if (usage > 10) return "TEST";
    return "KILL";
  };

  // =========================
  // 🔹 EXISTING FUNCTIONS
  // =========================
  const fetchInvoices = async () => {
    try {
      const res = await axios.get(`${API}/billing/invoices`, authHeader);
      setInvoices(res.data);
    } catch (err) {
      console.error("Invoice Error:", err);
    }
  };

  const fetchUsageLogs = async () => {
    setLoadingUsage(true);
    try {
      const res = await axios.get(`${API}/admin/usage`, authHeader);
      setUsageLogs(res.data);
    } catch (err) {
      console.error(err);
    }
    setLoadingUsage(false);
  };

  const fetchAuditLogs = async () => {
    setLoadingAudit(true);
    try {
      const res = await axios.get(`${API}/admin/audit`, authHeader);
      setAuditLogs(res.data);
    } catch (err) {
      console.error(err);
    }
    setLoadingAudit(false);
  };

  useEffect(() => {
    if (!token) return;

    axios.get(`${API}/health`).then((res) => setHealth(res.data));
    fetchInvoices();
    fetchUsageLogs();
    fetchAuditLogs();
    fetchDashboard();

    const interval = setInterval(fetchDashboard, 5000);
    return () => clearInterval(interval);
  }, [token]);

  if (!token) return <Login setToken={setToken} />;

  const createInvoice = async () => {
    setLoading(true);
    try {
      const res = await axios.post(
        `${API}/billing/invoice`,
        null,
        {
          params: {
            tenant_id: activeTenant,
            plan_id: "pro",
            amount: 499,
          },
          ...authHeader,
        }
      );

      setInvoiceId(res.data.invoice_id);
      fetchInvoices();
    } catch (err) {
      console.error(err);
    }
    setLoading(false);
  };

  const logout = () => {
    localStorage.removeItem("token");
    setToken(null);
  };

  const winner = dashboard?.top_creatives?.[0];

  return (
    <div style={{ maxWidth: "1100px", margin: "auto", padding: "20px" }}>
      <h1>AI Growth OS Dashboard</h1>

      <button onClick={logout}>Logout</button>

      {/* =========================
          🔥 AI SYSTEM PANEL
      ========================= */}
      <h2>AI Intelligence</h2>

      <button onClick={runAIJob}>Run AI Job</button>

      {dashboard && (
        <>
          <div style={{ display: "flex", gap: "20px", marginTop: "10px" }}>
            <div>Total Creatives: {dashboard.total_creatives}</div>
            <div>CTR: {dashboard.performance.avg_ctr.toFixed(2)}</div>
            <div>ROAS: {dashboard.performance.avg_roas.toFixed(2)}</div>
            <div>CPA: {dashboard.performance.avg_cpa.toFixed(2)}</div>
          </div>

          {winner && (
            <div style={{ background: "#e6ffe6", marginTop: "10px" }}>
              🏆 Winner: {winner.creative_id}
            </div>
          )}

          <table style={tableStyle}>
            <thead>
              <tr>
                <th style={thStyle}>Creative</th>
                <th style={thStyle}>Usage</th>
                <th style={thStyle}>Decision</th>
              </tr>
            </thead>
            <tbody>
              {dashboard.top_creatives.map((c) => (
                <tr key={c.creative_id}>
                  <td style={tdStyle}>{c.creative_id}</td>
                  <td style={tdStyle}>{c.usage}</td>
                  <td style={tdStyle}>{decisionLogic(c.usage)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}

      {/* =========================
          EXISTING SYSTEM (UNCHANGED)
      ========================= */}

      <h2>System Health</h2>
      <pre>{JSON.stringify(health, null, 2)}</pre>

      <h2>Billing</h2>

      <select
        value={activeTenant}
        onChange={(e) => setActiveTenant(e.target.value)}
      >
        <option value={getTenantId()}>{getTenantId()}</option>
      </select>

      <button onClick={createInvoice} disabled={loading}>
        {loading ? "Creating..." : "Create Invoice"}
      </button>

      {invoiceId && <p>Created: {invoiceId}</p>}

      <h3>Invoices</h3>
      <table style={tableStyle}>
        <thead>
          <tr>
            <th style={thStyle}>ID</th>
            <th style={thStyle}>Tenant</th>
            <th style={thStyle}>Amount</th>
            <th style={thStyle}>Status</th>
          </tr>
        </thead>
        <tbody>
          {invoices.map((inv) => (
            <tr key={inv.id}>
              <td style={tdStyle}>{inv.id}</td>
              <td style={tdStyle}>{inv.tenant_id}</td>
              <td style={tdStyle}>₹{inv.amount}</td>
              <td style={tdStyle}>{inv.status}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

const tableStyle = {
  width: "100%",
  borderCollapse: "collapse",
  marginTop: "20px",
};

const thStyle = {
  border: "1px solid #ddd",
  padding: "8px",
  backgroundColor: "#f2f2f2",
};

const tdStyle = {
  border: "1px solid #ddd",
  padding: "8px",
};

export default App;
