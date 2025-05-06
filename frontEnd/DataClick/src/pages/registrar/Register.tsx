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

  return (
    <>
      <Box
        sx={{
          position: "fixed",
          top: 0,
          left: 0,
          right: 0,
          height: "40px",
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
          height: "40px",
          backgroundColor: "#222",
          zIndex: 10,
        }}
      />

      {/* Logo fixa no topo */}
      <Box
        sx={{
          position: "absolute",
          top: 60,
          left: 0,
          right: 0,
          display: "flex",
          justifyContent: "center",
          zIndex: 5,
        }}
      >
        <img
          src="/logo.png"
          alt="Logo"
          style={{
            width: 240,
            objectFit: "contain",
          }}
        />
      </Box>

      {/* Botão de voltar abaixo da barra superior */}
      <Box sx={{ position: "absolute", top: 56, left: 16, zIndex: 15 }}>
        <IconButton onClick={() => navigate("/")} sx={{ color: "black" }}>
          <ArrowBackIcon />
        </IconButton>
      </Box>

      <Box
        sx={{
          position: "fixed",
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)",
          overflow: "hidden",
          paddingTop: "200px", // espaço para a logo
          paddingBottom: "60px",
          paddingX: 2,
        }}
      >
        <Box
          sx={{
            width: "100%",
            maxWidth: 380,
            padding: 2,
            backgroundColor: "transparent",
          }}
        >
          <Stack spacing={4}>
            {erro && <Alert severity="error">{erro}</Alert>}

            <TextField
              label="Nome completo"
              fullWidth
              value={nome}
              onChange={(e) => setNome(e.target.value)}
              InputProps={{
                sx: { backgroundColor: "#fff", fontSize: "1rem", height: 44 },
              }}
            />
            <TextField
              label="E-mail"
              type="email"
              fullWidth
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              InputProps={{
                sx: { backgroundColor: "#fff", fontSize: "1rem", height: 44 },
              }}
            />
            <TextField
              label="Telefone"
              fullWidth
              value={telefone}
              onChange={(e) => setTelefone(e.target.value)}
              InputProps={{
                sx: { backgroundColor: "#fff", fontSize: "1rem", height: 44 },
              }}
            />
            <TextField
              label="CNPJ"
              fullWidth
              value={cnpj}
              onChange={(e) => setCnpj(e.target.value)}
              InputProps={{
                sx: { backgroundColor: "#fff", fontSize: "1rem", height: 44 },
              }}
            />
            <TextField
              label="Senha"
              type="password"
              fullWidth
              value={senha}
              onChange={(e) => setSenha(e.target.value)}
              InputProps={{
                sx: { backgroundColor: "#fff", fontSize: "1rem", height: 44 },
              }}
            />
            <TextField
              label="Confirme a senha"
              type="password"
              fullWidth
              value={confirmarSenha}
              onChange={(e) => setConfirmarSenha(e.target.value)}
              InputProps={{
                sx: { backgroundColor: "#fff", fontSize: "1rem", height: 44 },
              }}
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
        </Box>
      </Box>
    </>
  );
};

export default Register;
