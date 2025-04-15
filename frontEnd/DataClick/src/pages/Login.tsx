import { useState } from "react";
import { useNavigate } from "react-router-dom";

import {
  Box,
  Button,
  Container,
  TextField,
  Typography,
  Alert
} from "@mui/material";
import { AuthService } from "../api/AuthService";

const Login = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [senha, setSenha] = useState("");
  const [erro, setErro] = useState("");

  const handleLogin = async () => {
    try {
      await AuthService.login({ email, senha });
      navigate("/home");
    } catch (error: any) {
      setErro("Usuário ou senha inválidos");
    }
  };

  return (
    <Container maxWidth="sm">
      <Box
        sx={{
          mt: 8,
          p: 4,
          boxShadow: 3,
          borderRadius: 2,
          backgroundColor: "#fff",
          display: "flex",
          flexDirection: "column",
          alignItems: "center"
        }}
      >
        <img src="/logo.jpeg" alt="Logo" style={{ width: 120, marginBottom: 24 }} />

        <Typography variant="h5" component="h1" gutterBottom>
          Login
        </Typography>

        {erro && (
          <Alert severity="error" sx={{ width: "100%", mb: 2 }}>
            {erro}
          </Alert>
        )}

        <TextField
          label="Usuário"
          variant="outlined"
          fullWidth
          margin="normal"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />

        <TextField
          label="Senha"
          type="password"
          variant="outlined"
          fullWidth
          margin="normal"
          value={senha}
          onChange={(e) => setSenha(e.target.value)}
        />

        <Box sx={{ display: "flex", justifyContent: "space-between", width: "100%", mt: 3 }}>
          <Button
            variant="contained"
            color="primary"
            onClick={handleLogin}
          >
            Entrar
          </Button>

          <Button
            variant="outlined"
            color="secondary"
            onClick={() => navigate("/register")}
          >
            Registrar
          </Button>
        </Box>
      </Box>
    </Container>
  );
};

export default Login;
