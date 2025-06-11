import React from "react";
import { Box, Container, Typography } from "@mui/material";

const Footer: React.FC = () => {
  return (
    <Box
      component="footer"
      sx={{
        py: 1.5,
        px: 2,
        mt: "auto",
        backgroundColor: (theme) =>
          theme.palette.mode === "light" ? theme.palette.grey[200] : theme.palette.grey[800],
        borderTop: "1px solid",
        borderColor: (theme) =>
          theme.palette.mode === "light" ? theme.palette.grey[300] : theme.palette.grey[700],
      }}
    >
      <Container maxWidth="lg" sx={{ display: "flex", justifyContent: "center", alignItems: "center" }}>
        <Typography variant="body2" color="text.secondary" align="center">
          © {new Date().getFullYear()} 4Click. Todos os direitos reservados.
        </Typography>
      </Container>
    </Box>
  );
};

export default Footer;
