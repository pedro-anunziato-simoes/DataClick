import { Link, useNavigate } from "react-router-dom";
import "./Sidebar.css";

const Sidebar = () => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem("token");
    navigate("/");
  };

  return (
    <div className="sidebar">
      <img src="/logo.png" alt="Logo" className="logo" />

      <nav>
        <ul>
          <li>
            <Link to="/home">Home</Link>
          </li>
          <li>
            <Link to="/cadastrarRecrutadores">Cadastrar Recrutador</Link>
          </li>
          <li>
            <Link to="/formularios">Formulários</Link>
          </li>
          <li>
            <Link to="/support">Suporte</Link>
          </li>
          <li>
            <button onClick={handleLogout}>
              Logout
            </button>
          </li>
        </ul>
      </nav>
    </div>
  );
};

export default Sidebar;
