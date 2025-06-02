import Footer from "../../components/footer/Footer";
import Recrutadores from "../../components/Recrutadores/Recrutador";
import Sidebar from "../../components/sideBar/Sidebar";
import { Box, useMediaQuery } from "@mui/material";

const VisualizarRecrutadoresPage = () => {
  const isMobile = useMediaQuery("(max-width:600px)");

  return (
    <Box
      sx={{
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)", // igual ao Home
        overflow: "hidden",
      }}
    >
      <Box
        sx={{
          display: "flex",
          flex: 1,
          flexDirection: isMobile ? "column" : "row",
        }}
      >
        <Box
          sx={{
            width: isMobile ? "100%" : "250px",
            background: "inherit",
          }}
        >
          <Sidebar />
        </Box>

        <Box
          sx={{
            flex: 1,
            padding: 4,
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            overflow: "hidden",
          }}
        >
          <Recrutadores />
        </Box>
      </Box>

      <Footer />
    </Box>
  );
};

export default VisualizarRecrutadoresPage;
