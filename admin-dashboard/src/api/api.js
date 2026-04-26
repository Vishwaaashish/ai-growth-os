const BASE = "http://localhost:8000";

export const getDashboard = async () => {
  try {
    const res = await fetch(`${BASE}/dashboard`);
    return await res.json();
  } catch (err) {
    console.error("API ERROR:", err);
    return null;
  }
};

export const runJob = async () => {
  return fetch(`${BASE}/job`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "x-api-key": "test_key_123"
    },
    body: JSON.stringify({
      type: "ai",
      payload: {
        product_id: "test_product"
      }
    })
  });
};
