import EventosList from "../../components/eventos/EventoList";
import Footer from "../../components/footer/Footer";
import Sidebar from "../../components/sideBar/Sidebar";
import { Box } from "@mui/material";

const ListaEventosPage = () => {
  return (
    <>
      <Sidebar />
      <Box
        sx={{
          marginLeft: { xs: "70px", sm: "250px" },
          padding: 4,
          minHeight: "100vh",
          backgroundColor: "#c0e9e7",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
        }}
      >
        <h1>Eventos</h1>
        <EventosList />
      </Box>
      <Footer />
    </>
  );
};

export default ListaEventosPage;
