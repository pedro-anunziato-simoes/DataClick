import { Link, useNavigate } from "react-router-dom";
import { Box, Button, styled } from "@mui/material";

const SidebarContainer = styled(Box)(({ theme }) => ({
  width: 250,
  height: '100vh',
  position: 'fixed',
  left: 0,
  top: 0,
  backgroundColor: theme.palette.background.paper,
  boxShadow: theme.shadows[3],
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',
  paddingTop: theme.spacing(4),
  zIndex: 1000,
}));

const NavList = styled('ul')(({ theme }) => ({
  listStyle: 'none',
  padding: 0,
  marginTop: theme.spacing(4),
  width: '100%',
  '& li': {
    margin: theme.spacing(2, 0),
    textAlign: 'center',
  },
  '& a': {
    textDecoration: 'none',
    color: theme.palette.text.primary,
    fontWeight: 500,
    fontSize: '1rem',
    transition: 'color 0.2s',
    '&:hover': {
      color: theme.palette.primary.main,
    },
  },
}));

const Sidebar = () => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem("token");
    navigate("/");
  };

  const NavList = styled('ul')(({ theme }) => ({
    listStyle: 'none',
    padding: 0,
    margin: 0,
    width: '100%',
    '& li': {
      borderBottom: '1px solid #ddd',
      textAlign: 'center',
      padding: theme.spacing(2),
      width: '100%',
    },
    '& a': {
      display: 'block',
      width: '100%',
      textDecoration: 'none',
      color: theme.palette.text.primary,
      fontWeight: 500,
      fontSize: '1.1rem',
      transition: 'background-color 0.2s',
      '&:hover': {
        backgroundColor: '#f5f5f5',
      },
    },
  }));
  

  return (
    <SidebarContainer>
      <img src="/logo.png" alt="Logo" style={{ width: '80%', marginBottom: '2rem' }} />
      <nav>
        <NavList>
          <li><Link to="/home">Home</Link></li>
          <li><Link to="/recrutadores">Recrutadores</Link></li>
          <li><Link to="/formularios">Formulários</Link></li>
          <li><Link to="/support">Suporte</Link></li>
          <li><Button
            variant="contained"
            onClick={handleLogout}
            sx={{
              backgroundColor: '#7DE2D1',
              color: '#000',
              '&:hover': {
                backgroundColor: '#65cabc',
              },
            }}
          >
            Logout
          </Button></li>
        </NavList>
      </nav>
    </SidebarContainer>
  );
};

export default Sidebar;
