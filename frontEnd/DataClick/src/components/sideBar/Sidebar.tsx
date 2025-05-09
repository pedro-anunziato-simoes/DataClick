import { Link, useNavigate } from "react-router-dom";
import {
  Box,
  Button,
  styled,
  List,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Divider,
} from "@mui/material";
import HomeIcon from "@mui/icons-material/Home";
import GroupIcon from "@mui/icons-material/Group";
import DescriptionIcon from "@mui/icons-material/Description";
import PersonIcon from "@mui/icons-material/Person";
import HelpOutlineIcon from "@mui/icons-material/HelpOutline";
import LogoutIcon from "@mui/icons-material/Logout";

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
  paddingTop: theme.spacing(4),
  zIndex: 1000,
}));

const Logo = styled('img')({
  width: '80%',
  margin: '0 auto 2rem auto',
  display: 'block',
});

const Sidebar = () => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem("token");
    navigate("/");
  };

  return (
    <SidebarContainer>
      <Logo src="/logo.png" alt="Logo" />

      <List>
        <ListItem disablePadding>
          <ListItemButton component={Link} to="/home">
            <ListItemIcon><HomeIcon /></ListItemIcon>
            <ListItemText primary="Home" />
          </ListItemButton>
        </ListItem>

        <ListItem disablePadding>
          <ListItemButton component={Link} to="/recrutadores">
            <ListItemIcon><GroupIcon /></ListItemIcon>
            <ListItemText primary="Recrutadores" />
          </ListItemButton>
        </ListItem>

        <ListItem disablePadding>
          <ListItemButton component={Link} to="/eventos">
            <ListItemIcon><DescriptionIcon /></ListItemIcon>
            <ListItemText primary="Eventos" />
          </ListItemButton>
        </ListItem>

        <ListItem disablePadding>
          <ListItemButton component={Link} to="/perfilAdministrador">
            <ListItemIcon><PersonIcon /></ListItemIcon>
            <ListItemText primary="Perfil" />
          </ListItemButton>
        </ListItem>

        <ListItem disablePadding>
          <ListItemButton component={Link} to="/suporte">
            <ListItemIcon><HelpOutlineIcon /></ListItemIcon>
            <ListItemText primary="Suporte" />
          </ListItemButton>
        </ListItem>

        <Divider sx={{ my: 2 }} />

        <ListItem disablePadding>
          <ListItemButton onClick={handleLogout}>
            <ListItemIcon><LogoutIcon /></ListItemIcon>
            <ListItemText primary="Logout" />
          </ListItemButton>
        </ListItem>
      </List>
    </SidebarContainer>
  );
};

export default Sidebar;
