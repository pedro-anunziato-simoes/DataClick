// src/components/Sidebar.tsx
import { Link } from "react-router-dom";
import "./Sidebar.css";

const Sidebar = () => {
  return (
    <div className="sidebar">
      {/* Logo no topo */}
      <img src="/logo.jpeg" alt="Logo" className="logo" />

      <nav>
        <ul>
          <li>
            <Link to="/home">Home</Link>
          </li>
          <li>
            <Link to="/register">Cadastro</Link>
          </li>
          <li>
            <Link to="/forms">Formulários</Link>
          </li>
          <li>
            <Link to="/support">Suporte</Link>
          </li>
        </ul>
      </nav>
    </div>
  );
};

export default Sidebar;
