import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import {
  Box,
  IconButton,
  List,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Divider,
  Tooltip,
} from "@mui/material";
import HomeIcon from "@mui/icons-material/Home";
import GroupIcon from "@mui/icons-material/Group";
import DescriptionIcon from "@mui/icons-material/Description";
import PersonIcon from "@mui/icons-material/Person";
import HelpOutlineIcon from "@mui/icons-material/HelpOutline";
import LogoutIcon from "@mui/icons-material/Logout";
import MenuIcon from "@mui/icons-material/Menu";
import ChevronLeftIcon from "@mui/icons-material/ChevronLeft";

const Sidebar = () => {
  const navigate = useNavigate();
  const [collapsed, setCollapsed] = useState(false);

  const handleLogout = () => {
    localStorage.removeItem("token");
    navigate("/");
  };

  const toggleSidebar = () => {
    setCollapsed((prev) => !prev);
  };

  const navItems = [
    { icon: <HomeIcon />, text: "Home", path: "/home" },
    { icon: <GroupIcon />, text: "Recrutadores", path: "/recrutadores" },
    { icon: <DescriptionIcon />, text: "Eventos", path: "/eventos" },
    { icon: <PersonIcon />, text: "Perfil", path: "/perfilAdministrador" },
    { icon: <HelpOutlineIcon />, text: "Suporte", path: "/suporte" },
  ];

  return (
    <Box
      sx={{
        width: collapsed ? 70 : 250,
        transition: "width 0.3s",
        height: "100vh",
        position: "fixed",
        left: 0,
        top: 0,
        backgroundColor: "background.paper",
        boxShadow: 3,
        display: "flex",
        flexDirection: "column",
        paddingTop: 2,
        zIndex: 1000,
      }}
    >
      <Box sx={{ display: "flex", justifyContent: "center", mb: 1 }}>
        <IconButton onClick={toggleSidebar}>
          {collapsed ? <MenuIcon /> : <ChevronLeftIcon />}
        </IconButton>
      </Box>

      <Box
        component="img"
        src="/logo.png"
        alt="Logo"
        sx={{
          width: collapsed ? 40 : "80%",
          margin: "0 auto 1rem auto",
          display: "block",
          transition: "width 0.3s",
        }}
      />

      <List>
        {navItems.map(({ icon, text, path }) => (
          <ListItem key={text} disablePadding sx={{ justifyContent: "center" }}>
            <Tooltip title={collapsed ? text : ""} placement="right">
              <ListItemButton
                component={Link}
                to={path}
                sx={{
                  justifyContent: collapsed ? "center" : "flex-start",
                  px: collapsed ? 1 : 2,
                }}
              >
                <ListItemIcon
                  sx={{
                    minWidth: 0,
                    mr: collapsed ? 0 : 2,
                    justifyContent: "center",
                  }}
                >
                  {icon}
                </ListItemIcon>
                {!collapsed && <ListItemText primary={text} />}
              </ListItemButton>
            </Tooltip>
          </ListItem>
        ))}

        <Divider sx={{ my: 2 }} />

        <ListItem disablePadding sx={{ justifyContent: "center" }}>
          <Tooltip title={collapsed ? "Logout" : ""} placement="right">
            <ListItemButton
              onClick={handleLogout}
              sx={{
                justifyContent: collapsed ? "center" : "flex-start",
                px: collapsed ? 1 : 2,
              }}
            >
              <ListItemIcon
                sx={{
                  minWidth: 0,
                  mr: collapsed ? 0 : 2,
                  justifyContent: "center",
                }}
              >
                <LogoutIcon />
              </ListItemIcon>
              {!collapsed && <ListItemText primary="Logout" />}
            </ListItemButton>
          </Tooltip>
        </ListItem>
      </List>
    </Box>
  );
};

export default Sidebar;
