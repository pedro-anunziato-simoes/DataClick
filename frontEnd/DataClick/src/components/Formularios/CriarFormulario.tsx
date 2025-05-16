import { useState } from "react";
import {
  Box,
  Typography,
  TextField,
  Button,
  Paper,
  Stack,
} from "@mui/material";
import { useNavigate, useParams } from "react-router-dom";
import { EntityFormulario } from "../../types/entityes/EntityFormulario";
import { FormularioService } from "../../api/FormularioService";
import { FormularioCreateDTO } from "../../types/entityes/DTO/FormualrioCreateDTO";

const CriarFormulario = () => {
  const { idEvento } = useParams<{ idEvento: string }>();
  const [titulo, setTitulo] = useState("");
  const [salvando, setSalvando] = useState(false);
  const navigate = useNavigate();
  const formularioService = FormularioService();
  const handleCriarFormulario = async () => {
    const novoFormulario: FormularioCreateDTO = {
      titulo,
    };
    try {
      setSalvando(true);
      await formularioService.criarForms(novoFormulario,idEvento||'');
      navigate("/eventos"); 
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
            <Button onClick={() => navigate("/eventos")} color="inherit">
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
