import React from "react";
import { Box, Container, Typography, Link } from "@mui/material";

const Footer: React.FC = () => {
  return (
    <Box
      component="footer"
      sx={{
        py: 3,
        px: 2,
        mt: "auto",
        backgroundColor: (theme) =>
          theme.palette.mode === "light" ? theme.palette.grey[200] : theme.palette.grey[800],
        borderTop: "1px solid",
        borderColor: (theme) =>
          theme.palette.mode === "light" ? theme.palette.grey[300] : theme.palette.grey[700],
      }}
    >
      <Container maxWidth="lg" sx={{ display: "flex", justifyContent: "space-between", flexWrap: "wrap" }}>
        <Typography variant="body2" color="text.secondary">
          © {new Date().getFullYear()} 4Click. Todos os direitos reservados.
        </Typography>
        <Box sx={{ display: "flex", gap: 2, mt: { xs: 2, sm: 0 } }}>
          <Link href="https://api.whatsapp.com/send?phone=4444444444&text=Olá, preciso de ajuda com o dataClick." color="inherit" underline="hover" >
            Contato
          </Link>
        </Box>
      </Container>
    </Box>
  );
};

export default Footer;
