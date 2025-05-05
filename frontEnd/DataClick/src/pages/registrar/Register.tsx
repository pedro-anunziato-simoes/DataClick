import { useState } from "react";
import { useNavigate } from "react-router-dom";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import {
  Container,
  Box,
  TextField,
  Typography,
  Button,
  Alert,
  IconButton
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
      setErro("Senha fraca. Use pelo menos 8 caracteres, uma letra maiúscula, uma minúscula, um número e um símbolo.");
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
          gap: 2,
        }}
      >
        <IconButton onClick={() => navigate(-1)} sx={{ alignSelf: "flex-start", mb: 2 }}>
          <ArrowBackIcon />
        </IconButton>
        <Typography variant="h5" component="h1" textAlign="center">
          Crie sua conta
        </Typography>

        {erro && <Alert severity="error">{erro}</Alert>}

        <TextField label="Nome completo" fullWidth value={nome} onChange={(e) => setNome(e.target.value)} />
        <TextField label="E-mail" fullWidth type="email" value={email} onChange={(e) => setEmail(e.target.value)} />
        <TextField label="Telefone" fullWidth value={telefone} onChange={(e) => setTelefone(e.target.value)} />
        <TextField label="CNPJ" fullWidth value={cnpj} onChange={(e) => setCnpj(e.target.value)} />
        <TextField label="Senha" type="password" fullWidth value={senha} onChange={(e) => setSenha(e.target.value)} />
        <TextField label="Confirme a senha" type="password" fullWidth value={confirmarSenha} onChange={(e) => setConfirmarSenha(e.target.value)} />
        <Button variant="contained" color="primary" onClick={handleRegister}>
          Registrar
        </Button>
      </Box>
    </Container>
  );
};

export default Register;
