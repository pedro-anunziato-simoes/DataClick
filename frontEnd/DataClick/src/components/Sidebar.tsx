import { Link, useNavigate } from "react-router-dom";
import "./Sidebar.css";
import { Button } from "@mui/material";

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
            <Link to="/recrutadores">Recrutadores</Link>
          </li>
          <li>
            <Link to="/formularios">Formulários</Link>
          </li>
          <li>
            <Link to="/support">Suporte</Link>
          </li>
          <li>
            <Button onClick={handleLogout}>
              Logout
            </Button>
          </li>
        </ul>
      </nav>
    </div>
  );
};

export default Sidebar;
