import Footer from "../../components/footer/Footer";
import Register from "../../components/registrar/Register";
import { Box } from "@mui/material";

const RegistrarPage = () => {
  return (
    <Box
      sx={{
        display: "flex",
        flexDirection: "column",
        minHeight: "100vh",
        overflowX: "hidden",
      }}
    >
      <Box sx={{ flex: 1, display: "flex", flexDirection: "column" }}>
        <Register />
      </Box>
      <Footer />
    </Box>
  );
};

export default RegistrarPage;
