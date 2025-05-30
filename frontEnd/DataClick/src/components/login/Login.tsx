import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box,
  Button,
  Container,
  TextField,
  Alert,
} from "@mui/material";
import { AuthService } from "../../api/AuthService";

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
    <Container maxWidth="xs" sx={{ textAlign: "center" }}>
      <img
        src="/logo.png"
        alt="Logo"
        style={{ width: 180, marginBottom: 16 }}
      />

      {erro && (
        <Alert severity="error" sx={{ width: "100%", mb: 2 }}>
          {erro}
        </Alert>
      )}

      <Box sx={{ width: "90%", mx: "auto" }}>
        <TextField
          placeholder="Insira Usuário/CNPJ"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          fullWidth
          variant="standard"
          InputProps={{
            disableUnderline: true,
            sx: {
              backgroundColor: "#ffffff",
              fontSize: "1rem",
              height: 44,
              borderRadius: "8px",
              px: 2,
            },
          }}
          sx={{ mb: 2 }}
        />
        <TextField
          placeholder="Insira sua senha"
          type="password"
          value={senha}
          onChange={(e) => setSenha(e.target.value)}
          fullWidth
          variant="standard"
          InputProps={{
            disableUnderline: true,
            sx: {
              backgroundColor: "#ffffff",
              fontSize: "1rem",
              height: 44,
              borderRadius: "8px",
              px: 2,
            },
          }}
          sx={{ mb: 2 }}
        />

        <Button
          fullWidth
          onClick={handleLogin}
          sx={{
            mt: 1,
            background: "linear-gradient(to right, #e0f7fa, #80cbc4)",
            borderRadius: "999px",
            color: "black",
            fontWeight: 600,
            textTransform: "none",
            fontSize: "1rem",
            minHeight: "48px",
            "&:hover": {
              background: "linear-gradient(to right, #b2dfdb, #4db6ac)",
            },
          }}
        >
          Entrar
        </Button>

        <Button
          fullWidth
          onClick={() => navigate("/register")}
          sx={{
            mt: 2,
            background: "linear-gradient(to right, #e0f7fa, #80cbc4)",
            borderRadius: "999px",
            color: "black",
            fontWeight: 600,
            textTransform: "none",
            fontSize: "1rem",
            minHeight: "48px",
            "&:hover": {
              background: "linear-gradient(to right, #b2dfdb, #4db6ac)",
            },
          }}
        >
          Registrar
        </Button>
      </Box>
    </Container>
  );
};

export default Login;
