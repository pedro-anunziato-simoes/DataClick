import { useState } from "react";
import {
  Box,
  Typography,
  TextField,
  Button,
  Paper,
  Stack,
} from "@mui/material";
import { useNavigate } from "react-router-dom";
import { EntityFormulario } from "../../types/entityes/EntityFormulario";
import { FormularioService } from "../../api/FormularioService";

const CriarFormulario = () => {
  const [titulo, setTitulo] = useState("");
  const [salvando, setSalvando] = useState(false);
  const navigate = useNavigate();
  const formularioService = FormularioService();

  const handleCriarFormulario = async () => {
    const novoFormulario: EntityFormulario = {
      titulo,
      adminId: "",
      campos: [],
    };

    try {
      setSalvando(true);
      await formularioService.criarForms(novoFormulario);
      navigate("/formularios"); 
    } catch (error) {
      console.error("Erro ao criar formulário:", error);
    } finally {
      setSalvando(false);
    }
  };

  return (
    <Box p={4}>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h5" gutterBottom>
          Criar Novo Formulário
        </Typography>
        <Stack spacing={2}>
          <TextField
            label="Título do Formulário"
            value={titulo}
            onChange={(e) => setTitulo(e.target.value)}
            fullWidth
          />
          <Box display="flex" justifyContent="flex-end" gap={2}>
            <Button onClick={() => navigate(-1)} color="inherit">
              Cancelar
            </Button>
            <Button
              variant="contained"
              color="primary"
              onClick={handleCriarFormulario}
              disabled={salvando || titulo.trim() === ""}
            >
              {salvando ? "Salvando..." : "Criar"}
            </Button>
          </Box>
        </Stack>
      </Paper>
    </Box>
  );
};

export default CriarFormulario;
