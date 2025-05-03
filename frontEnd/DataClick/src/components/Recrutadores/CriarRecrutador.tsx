import { useState } from "react";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import {
    Box,
    Button,
    Container,
    TextField,
    Typography,
    Paper,
    Alert,
    IconButton
} from "@mui/material";
import { useNavigate } from "react-router-dom";
import { RecrutadorService } from "../../api/RecrutadorService";

const CriarRecrutador = () => {
    const [nome, setNome] = useState("");
    const [telefone, setTelefone] = useState("");
    const [email, setEmail] = useState("");
    const [senha, setSenha] = useState("");
    const [erro, setErro] = useState("");
    const [sucesso, setSucesso] = useState("");
    const [loading, setLoading] = useState(false);
    const navigate = useNavigate();

    const handleSalvar = async () => {
        const recrutadorService = RecrutadorService();
        setErro("");
        setSucesso("");
        setLoading(true);

        if (!nome || !telefone || !email || !senha) {
            setErro("Preencha todos os campos.");
            setLoading(false);
            return;
        }
        try {await recrutadorService.criarRecrutador({
            nome,
            telefone,
            email,
            formularios: [],
            senha
        });

            setSucesso("Recrutador criado com sucesso!");
            navigate("/recrutadores")
        } catch (error) {
            console.error(error);
            setErro("Erro ao criar recrutador.");
        } finally {
            setLoading(false);
        }
    };

    return (
        <Container maxWidth="sm">
            <IconButton onClick={() => navigate("/recrutadores")} sx={{ alignSelf: "flex-start", mb: 2 }}>
                <ArrowBackIcon />
            </IconButton>
            <Paper elevation={3} sx={{ p: 4, mt: 6 }}>
                <Typography variant="h5" gutterBottom>
                    Criar Recrutador
                </Typography>

                {erro && <Alert severity="error" sx={{ mb: 2 }}>{erro}</Alert>}
                {sucesso && <Alert severity="success" sx={{ mb: 2 }}>{sucesso}</Alert>}

                <TextField
                    label="Nome"
                    fullWidth
                    margin="normal"
                    value={nome}
                    onChange={(e) => setNome(e.target.value)}
                    disabled={loading}
                />

                <TextField
                    label="Telefone"
                    fullWidth
                    margin="normal"
                    value={telefone}
                    onChange={(e) => setTelefone(e.target.value)}
                    disabled={loading}
                />

                <TextField
                    label="Email"
                    type="email"
                    fullWidth
                    margin="normal"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    disabled={loading}
                />

                <TextField
                    label="Senha"
                    type="password"
                    fullWidth
                    margin="normal"
                    value={senha}
                    onChange={(e) => setSenha(e.target.value)}
                    disabled={loading}
                />


                <Box mt={3} display="flex" justifyContent="space-between">
                    <Button
                        variant="contained"
                        color="primary"
                        onClick={handleSalvar}
                        disabled={loading}
                    >
                        {loading ? "Salvando..." : "Salvar"}
                    </Button>

                    <Button
                        variant="outlined"
                        color="secondary"
                        onClick={() => navigate(-1)}
                        disabled={loading}
                    >
                        Voltar
                    </Button>
                </Box>
            </Paper>
        </Container>
    );
};

export default CriarRecrutador;
