import EventosList from "../../components/eventos/EventoList";
import Footer from "../../components/footer/Footer";
import Sidebar from "../../components/sideBar/Sidebar";
import { Box, Typography } from "@mui/material";

const ListaEventosPage = () => {
  return (
    <>
      <Sidebar />
      <Box
        sx={{
          minHeight: "100vh",
          background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)",
          display: "flex",
          flexDirection: "column",
        }}
      >
        <Box
          sx={{
            flex: 1,
            display: "flex",
            flexDirection: "column",
            justifyContent: "center",
            alignItems: "center",
            padding: 4,
          }}
        >
          <EventosList />
        </Box>

        <Footer />
      </Box>
    </>
  );
};

export default ListaEventosPage;
