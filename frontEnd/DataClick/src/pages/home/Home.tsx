import { Box, Typography, useMediaQuery } from "@mui/material";
import Sidebar from "../../components/sideBar/Sidebar";
import Footer from "../../components/footer/Footer";

const Home = () => {
  const isMobile = useMediaQuery("(max-width:600px)");

  return (
    <Box
      sx={{
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)", // background ajustado
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
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            textAlign: "center",
            p: 3,
          }}
        >
          <Typography variant="h4" fontWeight="bold">
            Bem vindo!
          </Typography>
        </Box>
      </Box>

      <Footer />
    </Box>
  );
};

export default Home;
