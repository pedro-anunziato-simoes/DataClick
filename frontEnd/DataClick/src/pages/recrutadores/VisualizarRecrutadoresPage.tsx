import Footer from "../../components/footer/Footer";
import Recrutadores from "../../components/Recrutadores/Recrutador";
import Sidebar from "../../components/sideBar/Sidebar";
import { Box } from "@mui/material";

const VisualizarRecrutadoresPage = () => {
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
        <h1>Recrutadores</h1>
        <Recrutadores />
      </Box>
       <Footer />
    </>
  );
};

export default VisualizarRecrutadoresPage;
