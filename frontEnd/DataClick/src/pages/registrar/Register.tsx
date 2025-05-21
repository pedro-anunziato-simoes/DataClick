import { useState } from "react";
import { useNavigate } from "react-router-dom";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import {
  Box,
  TextField,
  Button,
  Alert,
  IconButton,
  Stack,
  Container,
} from "@mui/material";
import { AuthService } from "../../api/AuthService";

const senhaForteRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.#^])[A-Za-z\d@$!%*?&.#^]{8,}$/;
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const cnpjRegex = /^\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}$/;

const Register = () => {
  const navigate = useNavigate();
  const [, setLoading] = useState(false);
  const [nome, setNome] = useState("");
  const [email, setEmail] = useState("");
  const [telefone, setTelefone] = useState("");
  const [cnpj, setCnpj] = useState("");
  const [senha, setSenha] = useState("");
  const [confirmarSenha, setConfirmarSenha] = useState("");
  const [erro, setErro] = useState("");

  const handleRegister = async () => {
    setErro("");
    setLoading(true);

    if (!emailRegex.test(email)) {
      setErro("E-mail inválido.");
      setLoading(false);
      return;
    }

    if (!cnpjRegex.test(cnpj)) {
      setErro("CNPJ inválido. Use o formato 00.000.000/0000-00.");
      setLoading(false);
      return;
    }

    if (!senhaForteRegex.test(senha)) {
      setErro(
        "Senha fraca. Use pelo menos 8 caracteres, uma letra maiúscula, uma minúscula, um número e um símbolo."
      );
      setLoading(false);
      return;
    }

    if (senha !== confirmarSenha) {
      setErro("As senhas não coincidem.");
      setLoading(false);
      return;
    }

    try {
      await AuthService.register({ nome, email, telefone, cnpj, senha });
      alert("Usuário registrado com sucesso!");
      navigate("/");
    } catch (error) {
      setErro("Erro ao registrar. Tente novamente.");
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  const inputStyle = {
    backgroundColor: "#fff",
    fontSize: "1rem",
    height: 44,
    borderRadius: 2,
    "& fieldset": { border: "none" },
    "&:focus-within": {
      outline: "none",
      boxShadow: "none",
    },
  };

  return (
    <Box
      sx={{
        height: "100vh",
        overflow: "hidden",
        background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)",
        position: "relative",
      }}
    >
      <Box
        sx={{
          position: "fixed",
          top: 0,
          left: 0,
          right: 0,
          height: 40,
          backgroundColor: "#222",
          zIndex: 10,
        }}
      />
      <Box
        sx={{
          position: "fixed",
          bottom: 0,
          left: 0,
          right: 0,
          height: 40,
          backgroundColor: "#222",
          zIndex: 10,
        }}
      />

      <Box
        sx={{
          position: "absolute",
          top: 40,
          bottom: 40,
          left: 0,
          right: 0,
          overflowY: "auto",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          paddingX: 2,
        }}
      >
        <Box sx={{ position: "absolute", top: 16, left: 16 }}>
          <IconButton onClick={() => navigate("/")} sx={{ color: "black" }}>
            <ArrowBackIcon />
          </IconButton>
        </Box>

        <Box sx={{ textAlign: "center", mt: 4, mb: 2 }}>
          <img
            src="/logo.png"
            alt="Logo"
            style={{
              width: "200px",
              maxWidth: "80%",
              objectFit: "contain",
            }}
          />
        </Box>

        <Container maxWidth="xs" sx={{ pb: 4 }}>
          <Stack spacing={3}>
            {erro && <Alert severity="error">{erro}</Alert>}

            <TextField
              placeholder="Nome completo"
              fullWidth
              value={nome}
              onChange={(e) => setNome(e.target.value)}
              InputProps={{ sx: inputStyle }}
            />
            <TextField
              placeholder="E-mail"
              type="email"
              fullWidth
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              InputProps={{ sx: inputStyle }}
            />
            <TextField
              placeholder="Telefone"
              fullWidth
              value={telefone}
              onChange={(e) => setTelefone(e.target.value)}
              InputProps={{ sx: inputStyle }}
            />
            <TextField
              placeholder="CNPJ"
              fullWidth
              value={cnpj}
              onChange={(e) => setCnpj(e.target.value)}
              InputProps={{ sx: inputStyle }}
            />
            <TextField
              placeholder="Senha"
              type="password"
              fullWidth
              value={senha}
              onChange={(e) => setSenha(e.target.value)}
              InputProps={{ sx: inputStyle }}
            />
            <TextField
              placeholder="Confirme a senha"
              type="password"
              fullWidth
              value={confirmarSenha}
              onChange={(e) => setConfirmarSenha(e.target.value)}
              InputProps={{ sx: inputStyle }}
            />

            <Button
              fullWidth
              variant="contained"
              onClick={handleRegister}
              sx={{
                background: "linear-gradient(to right, #e0f7fa, #80cbc4)",
                borderRadius: "50px",
                color: "black",
                fontWeight: 600,
                fontSize: "0.9rem",
                paddingY: "8px",
                textTransform: "none",
                minHeight: "36px",
                "&:hover": {
                  background: "linear-gradient(to right, #b2dfdb, #4db6ac)",
                },
              }}
            >
              Registrar
            </Button>
          </Stack>
        </Container>
      </Box>
    </Box>
  );
};

export default Register;
