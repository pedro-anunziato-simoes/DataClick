import CriarEvento from "../../components/eventos/CrirarEvento";
import Footer from "../../components/footer/Footer";
import Sidebar from "../../components/sideBar/Sidebar";
import { Box } from "@mui/material";

const CriarEventoPage = () => {
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
        <h1>Criar Evento</h1>
        <CriarEvento />
        <Footer />
      </Box>
    </>
  );
};

export default CriarEventoPage;
