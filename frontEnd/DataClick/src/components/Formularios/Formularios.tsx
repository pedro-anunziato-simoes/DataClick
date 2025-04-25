import { useEffect, useState } from "react";
import { FormularioService } from "../../api/FormularioService";
import { useNavigate } from "react-router-dom";
import CamposViewForm from "./Campos/CamposViewForm";
import {
  Box,
  Typography,
  Paper,
  Button,
  CircularProgress,
  Stack,
  IconButton,
  Dialog,
  DialogTitle,
  DialogActions,
} from "@mui/material";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import DeleteIcon from "@mui/icons-material/Delete";

const Formularios = () => {
  const [formularios, setFormularios] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [confirmDeleteId, setConfirmDeleteId] = useState<string | null>(null);
  const navigate = useNavigate();
  const formularioService = FormularioService();
  useEffect(() => {
    buscarFormularios();
  }, []);

  const buscarFormularios = async () => {
    try {
      setLoading(true);
      const data = await formularioService.getFormularios();
      setFormularios(data);
    } catch (error) {
      console.error("Erro ao buscar formulários:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleEditarCampos = (formId: string) => {
    navigate(`/campos/${formId}`);
  };

  const handleEditarFormulario = (formId: string) => {
    navigate(`/editarFormulario/${formId}`);
  };


  const handleDelete = async () => {
    if (!confirmDeleteId) return;
    try {
      await formularioService.removerForms(confirmDeleteId);
      await buscarFormularios();
    } catch (error) {
      console.error("Erro ao excluir formulário:", error);
    } finally {
      setConfirmDeleteId(null);
    }
  };

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" mt={4}>
        <CircularProgress />
      </Box>
    );
  }

  return (
    <Box p={4}>
      <Box display="flex" alignItems="center" mb={3}>
        <IconButton onClick={() => navigate("/home")} sx={{ mr: 1 }}>
          <ArrowBackIcon />
        </IconButton>
        <Typography variant="h5">Formulários Cadastrados</Typography>
      </Box>

      <Stack spacing={3}>
        {formularios.map((formulario) => (
          <Paper key={formulario.id} elevation={3} sx={{ p: 3 }}>
            <Box display="flex" justifyContent="space-between" alignItems="center">
              <Typography variant="h6">{formulario.titulo}</Typography>
              <IconButton
                onClick={() => setConfirmDeleteId(formulario.id)}
                color="error"
              >
                <DeleteIcon />
              </IconButton>
            </Box>

            <CamposViewForm formId={formulario.id} />

            <Box mt={2}>
              <Stack direction="row" spacing={2}>
                <Button
                  variant="outlined"
                  color="primary"
                  onClick={() => handleEditarCampos(formulario.id)}
                >
                  Editar Campos
                </Button>

                <Button
                  variant="outlined"
                  color="secondary"
                  onClick={() => handleEditarFormulario(formulario.id)}
                >
                  Editar Formulário
                </Button>
              </Stack>
            </Box>

          </Paper>
        ))}
      </Stack>

      <Box mt={4} textAlign="center">
        <Button
          variant="contained"
          color="primary"
          onClick={() => navigate("/criarFormularios")}
        >
          Criar novo formulário
        </Button>
      </Box>
      <Dialog open={!!confirmDeleteId} onClose={() => setConfirmDeleteId(null)}>
        <DialogTitle>Deseja realmente excluir este formulário?</DialogTitle>
        <DialogActions>
          <Button onClick={() => setConfirmDeleteId(null)} color="inherit">
            Cancelar
          </Button>
          <Button onClick={handleDelete} color="error">
            Excluir
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default Formularios;
