import Footer from "../../components/footer/Footer";
import CriarRecrutador from "../../components/Recrutadores/CriarRecrutador";
import Sidebar from "../../components/sideBar/Sidebar";
import { Box } from "@mui/material";

const CadastrarRecrutadorPage = () => {
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
        <h1>Cadastrar Recrutador</h1>
        <CriarRecrutador />
      </Box>
      <Footer />
    </>
  );
};

export default CadastrarRecrutadorPage;
