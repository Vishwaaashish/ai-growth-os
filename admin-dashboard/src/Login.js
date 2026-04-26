import React, { useState } from "react";
import axios from "axios";

const API = "http://127.0.0.1:8000";

function Login({ setToken }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const login = async () => {
    try {
      const res = await axios.post(`${API}/auth/login`, null, {
        params: { email, password },
      });

      const token = res.data.access_token;

      localStorage.setItem("token", token);
      setToken(token);
    } catch (err) {
      alert("Login failed");
      console.error(err);
    }
  };

  return (
    <div style={{ padding: "40px" }}>
      <h2>Login</h2>

      <input placeholder="Email" onChange={(e) => setEmail(e.target.value)} />
      <br />
      <br />

      <input
        placeholder="Password"
        type="password"
        onChange={(e) => setPassword(e.target.value)}
      />
      <br />
      <br />

      <button onClick={login}>Login</button>
    </div>
  );
}

export default Login;
