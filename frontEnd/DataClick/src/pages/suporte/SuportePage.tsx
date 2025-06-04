import Footer from "../../components/footer/Footer";
import Sidebar from "../../components/sideBar/Sidebar";
import Suporte from "../../components/suporte/Suporte";
import { Box, Typography } from "@mui/material";

const SuportePage = () => {
  return (
    <div style={{ display: "flex", minHeight: "100vh" }}>
      <Sidebar />

      <Box
        sx={{
          flexGrow: 1,
          display: "flex",
          flexDirection: "column",
          background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)",
        }}
      >
        <Box
          sx={{
            flexGrow: 1,
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
            padding: 4,
            textAlign: "center",
          }}
        >
          <Typography
            variant="h4"
            fontWeight="bold"
            sx={{ color: "#000" }}
          >
            canal principal de suporte
          </Typography>
        </Box>
        <Footer />
        <Suporte />
      </Box>
    </div>
  );
};

export default SuportePage;
