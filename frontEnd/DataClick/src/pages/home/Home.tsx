import { Box, Typography, useMediaQuery, Paper, Stack } from "@mui/material";
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
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            textAlign: "center",
            p: 3,
          }}
        >
          <Paper elevation={4} sx={{ p: 5, borderRadius: 4, maxWidth: 700, backgroundColor: "#ffffffdd" }}>
            <Stack spacing={2}>
              <Typography variant="h4" fontWeight="bold">
                Bem vindo ao DataClick!
              </Typography>

              <Typography variant="body1">
                <strong>DataClick</strong> é uma plataforma desenvolvida para facilitar a coleta de informações em campo, mesmo sem conexão com a internet.
              </Typography>

              <Typography variant="body1">
                Com ela, recrutadores podem baixar formulários personalizados antes dos eventos, preenchê-los offline e sincronizar os dados automaticamente assim que houver acesso à internet.
              </Typography>

              <Typography variant="body1">
                Administradores têm acesso a uma visão completa dos dados coletados, podendo acompanhar a performance por evento, gerenciar recrutadores e criar formulários com total flexibilidade.
              </Typography>

              <Typography variant="body1">
                Tudo isso de forma simples, segura e eficiente.
              </Typography>
            </Stack>
          </Paper>
        </Box>
      </Box>

      <Footer />
    </Box>
  );
};

export default Home;
