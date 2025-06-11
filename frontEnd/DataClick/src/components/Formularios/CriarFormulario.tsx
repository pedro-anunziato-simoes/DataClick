import { useState } from "react";
import {
  Box,
  Typography,
  TextField,
  Button,
  Paper,
  Stack,
  Container,
} from "@mui/material";
import { useNavigate, useParams } from "react-router-dom";
import { FormularioService } from "../../api/FormularioService";
import { FormularioCreateDTO } from "../../types/entityes/DTO/FormualrioCreateDTO";
import Footer from "../footer/Footer";

const CriarFormulario = () => {
  const { idEvento } = useParams<{ idEvento: string }>();
  const [formularioTituloDto, setTitulo] = useState("");
  const [salvando, setSalvando] = useState(false);
  const navigate = useNavigate();
  const formularioService = FormularioService();

  const handleCriarFormulario = async () => {
    const novoFormulario: FormularioCreateDTO = {
      formularioTituloDto,
    };
    try {
      setSalvando(true);
      await formularioService.criarForms(novoFormulario, idEvento || "");
      navigate("/eventos");
    } catch (error) {
      console.error("Erro ao criar formulário:", error);
    } finally {
      setSalvando(false);
    }
  };

  return (
    <Box
      sx={{
        minHeight: "100vh",
        background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)",
        display: "flex",
        flexDirection: "column",
      }}
    >
      <Box
        sx={{
          flexGrow: 1,
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          px: 2,
        }}
      >
        <Container maxWidth="sm">
          <Paper
            elevation={4}
            sx={{
              p: 4,
              borderRadius: 4,
              boxShadow: "0 4px 12px rgba(0,0,0,0.1)",
              backgroundColor: "#ffffffee",
            }}
          >
            <Typography variant="h5" gutterBottom align="center">
              Criar Novo Formulário
            </Typography>

            <Stack spacing={3}>
              <TextField
                label="Título do Formulário"
                value={formularioTituloDto}
                onChange={(e) => setTitulo(e.target.value)}
                fullWidth
              />

              <Box display="flex" justifyContent="flex-end" gap={2}>
                <Button onClick={() => navigate("/eventos")} color="inherit">
                  Cancelar
                </Button>
                <Button
                  variant="contained"
                  color="primary"
                  onClick={handleCriarFormulario}
                  disabled={salvando || formularioTituloDto.trim() === ""}
                >
                  {salvando ? "Salvando..." : "Criar"}
                </Button>
              </Box>
            </Stack>
          </Paper>
        </Container>
      </Box>

      <Footer />
    </Box>
  );
};

export default CriarFormulario;
