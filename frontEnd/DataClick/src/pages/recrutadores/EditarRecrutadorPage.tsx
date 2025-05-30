import Footer from "../../components/footer/Footer";
import EditarRecrutador from "../../components/Recrutadores/EditarRecrutador";
import Sidebar from "../../components/sideBar/Sidebar";
import { Box, Typography, useMediaQuery } from "@mui/material";

const EditarRecrutadorPage = () => {
  const isMobile = useMediaQuery("(max-width:600px)");

  return (
    <Box
      sx={{
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)",
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
            justifyContent: "center",
            overflow: "hidden",
          }}
        >
          <Typography
            variant="h4"
            sx={{
              fontFamily: '"Poppins", sans-serif',
              fontWeight: "bold",
              marginBottom: 2,
            }}
          >
            Editar Recrutador
          </Typography>
          <EditarRecrutador />
        </Box>
      </Box>

      <Footer />
    </Box>
  );
};

export default EditarRecrutadorPage;
