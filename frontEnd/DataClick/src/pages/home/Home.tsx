import { Box, Typography, useMediaQuery } from "@mui/material";
import Sidebar from "../../components/sideBar/Sidebar";
import Footer from "../../components/footer/Footer";

const Home = () => {
  const isMobile = useMediaQuery("(max-width:600px)");

  return (
    <div>
      <Box
        sx={{
          display: "flex",
          flexDirection: isMobile ? "column" : "row",
          height: "100vh",
          width: "100vw",
          overflow: "hidden",
          background: "linear-gradient(to bottom, #a8e6e6, #6bc3c3)",
        }}
      >
        <Box
          sx={{
            width: isMobile ? "100%" : "250px",
            height: isMobile ? "auto" : "100%",
            background: "inherit",
          }}
        >
          <Sidebar />
        </Box>

        <Box
          sx={{
            flex: 1,
            display: "flex",
            flexDirection: "column",
            justifyContent: "center",
            alignItems: "center",
            p: 3,
            textAlign: "center",
          }}
        >
          <Typography variant="h4" fontWeight="bold" mb={2}>
            Bem vindo!
          </Typography>
        </Box>

      </Box>
      <Footer />
    </div>
  );
};

export default Home;

