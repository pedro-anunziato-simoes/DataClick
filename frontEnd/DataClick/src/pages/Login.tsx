// src/pages/Login.tsx
import { useNavigate } from "react-router-dom";
import "./Login.css";

const Login = () => {
  const navigate = useNavigate();

  return (
    <>
      <img src="/logo.jpeg" alt="Logo" className="login-logo" />
      
      <div className="login-container">
        <h2>Login</h2>
        <input type="text" placeholder="Usuário" />
        <input type="password" placeholder="Senha" />

        <div className="button-group">
          <button onClick={() => navigate("/home")} className="btn-login">
            Entrar
          </button>
          <button onClick={() => navigate("/register")} className="btn-register">
            Registrar
          </button>
        </div>
      </div>
    </>
  );
};

export default Login;
