import EditarRecrutador from "../../components/Recrutadores/EditarRecrutador";
import Sidebar from "../../components/sideBar/Sidebar";
import { Box } from "@mui/material";

const EditarRecrutadorPage = () => {
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
        <h1>Editar Recrutador</h1>
        <EditarRecrutador />
      </Box>
    </>
  );
};

export default EditarRecrutadorPage;
