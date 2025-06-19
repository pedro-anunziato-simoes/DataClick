import Footer from "../../components/footer/Footer";
import Sidebar from "../../components/sideBar/Sidebar";
import Suporte from "../../components/suporte/Suporte";
import { Box, Typography } from "@mui/material";

const SuportePage = () => {
  return (
    <>
      <Sidebar />
      <Box
        sx={{
          marginLeft: { xs: "70px", sm: "250px" },
          minHeight: "100vh",
          backgroundColor: "#c0e9e7",
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          textAlign: "center",
          padding: 4,
          position: "relative",
        }}
      >
        <Typography variant="h4" fontWeight="bold">
          canal principal de suporte
        </Typography>
        <Suporte />
        
      </Box>
      <Footer/>
    </>
  );
};

export default SuportePage;
