import { Box } from "@mui/material";
import Footer from "../../components/footer/Footer";
import Login from "../../components/login/Login";

const SuportePage = () => {
  return (
    <Box
      sx={{
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)",
      }}
    >
      <Box
        sx={{
          flexGrow: 1,
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        <Login />
      </Box>
      <Footer />
    </Box>
  );
};

export default SuportePage;
