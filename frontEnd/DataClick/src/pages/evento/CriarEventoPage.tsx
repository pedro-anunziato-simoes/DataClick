import CriarEvento from "../../components/eventos/CrirarEvento";
import Footer from "../../components/footer/Footer";
import { Box } from "@mui/material";

const CriarEventoPage = () => {
  return (
    <Box
      sx={{
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        justifyContent: "space-between",
        background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)",
      }}
    >
      {/* Conteúdo principal */}
      <Box
        sx={{
          padding: 4,
          flexGrow: 1,
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
        }}
      >
        <h1>Criar Evento</h1>
        <CriarEvento />
      </Box>

      {/* Footer fixo ao final */}
      <Footer />
    </Box>
  );
};

export default CriarEventoPage;
