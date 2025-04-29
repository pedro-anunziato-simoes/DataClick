import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { EntityRecrutador } from "../../types/entityes/EntityRecrutador";

import {
  Box,
  Typography,
  Paper,
  CircularProgress,
  Button,
  Stack,
  Dialog,
  DialogTitle,
  DialogActions
} from "@mui/material";
import { RecrutadorService } from "../../api/RecrutadorService";

const Recrutadores = () => {
  const navigate = useNavigate();
  const [recrutadores, setRecrutadores] = useState<EntityRecrutador[]>([]);
  const [loading, setLoading] = useState(true);
  const [confirmDeleteId, setConfirmDeleteId] = useState<string | null>(null);

  useEffect(() => {
    buscarRecrutadores();
  }, []);

  const buscarRecrutadores = async () => {
    setLoading(true);
    try {
      const lista: EntityRecrutador[] = await RecrutadorService().getRecrutadores();
      setRecrutadores(lista);
    } catch (error) {
      console.error("Erro ao buscar recrutadores:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleCriarRecrutador = () => {
    navigate("/cadastrarRecrutadores");
  };

  const handleEditarRecrutador = (id: string) => {
    navigate(`/editarRecrutador/${id}`);
  };

  const handleConfirmDelete = (id: string) => {
    setConfirmDeleteId(id);
  };

  const handleDeleteRecrutador = async () => {
    if (!confirmDeleteId) return;
    try {
      await RecrutadorService().excluirRecrutador(confirmDeleteId);
      await buscarRecrutadores();
    } catch (error) {
      console.error("Erro ao excluir recrutador:", error);
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
      <Typography variant="h4" gutterBottom>
        Lista de Recrutadores
      </Typography>

      <Button variant="contained" color="primary" onClick={handleCriarRecrutador} sx={{ mb: 2 }}>
        Adicionar Recrutador
      </Button>

      <Stack spacing={2}>
        {recrutadores.length === 0 ? (
          <Typography variant="body1">Nenhum recrutador encontrado.</Typography>
        ) : (
          recrutadores.map((recrutador) => (
            <Paper key={recrutador.usuarioId} elevation={3} sx={{ p: 3 }}>
              <Typography><strong>Nome:</strong> {recrutador.nome}</Typography>
              <Typography><strong>Telefone:</strong> {recrutador.telefone}</Typography>
              <Typography><strong>E-mail:</strong> {recrutador.email}</Typography>
              <Box mt={2} display="flex" gap={2}>
                <Button
                  variant="outlined"
                  color="primary"
                  onClick={() => handleEditarRecrutador(recrutador.usuarioId)}
                >
                  Editar
                </Button>
                <Button
                  variant="outlined"
                  color="error"
                  onClick={() => handleConfirmDelete(recrutador.usuarioId)}
                >
                  Excluir
                </Button>
              </Box>
            </Paper>
          ))
        )}
      </Stack>

      {/* Diálogo de confirmação de exclusão */}
      <Dialog open={!!confirmDeleteId} onClose={() => setConfirmDeleteId(null)}>
        <DialogTitle>Deseja realmente excluir este recrutador?</DialogTitle>
        <DialogActions>
          <Button onClick={() => setConfirmDeleteId(null)} color="inherit">
            Cancelar
          </Button>
          <Button onClick={handleDeleteRecrutador} color="error">
            Excluir
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default Recrutadores;
