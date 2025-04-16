import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { EntityRecrutador } from "../../types/entityes/EntityRecrutador";

import {
  Box,
  Typography,
  Paper,
  CircularProgress
} from "@mui/material";
import { RecrutadorService } from "../../api/RecrutadorService";


const Recrutador = () => {
  const { id } = useParams<{ id: string }>();
  const [recrutador, setRecrutador] = useState<EntityRecrutador | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const recrutadorService = RecrutadorService()
    const fetchRecrutador = async () => {
      try {
        if (!id) return;
        const data = await recrutadorService.getRecrutadorById(id);
        setRecrutador(data);
      } catch (error) {
        console.error("Erro ao buscar recrutador:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchRecrutador();
  }, [id]);

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" mt={4}>
        <CircularProgress />
      </Box>
    );
  }

  if (!recrutador) {
    return (
      <Typography variant="h6" align="center" mt={4}>
        Recrutador não encontrado.
      </Typography>
    );
  }

  return (
    <Box p={4}>
      <Paper elevation={3} sx={{ p: 3, mb: 3 }}>
        <Typography variant="h5" gutterBottom>
          Informações do Recrutador
        </Typography>
        <Typography><strong>Nome:</strong> {recrutador.nome}</Typography>
        <Typography><strong>Telefone:</strong> {recrutador.telefone}</Typography>
        <Typography><strong>E-mail:</strong> {recrutador.email}</Typography>
        <Typography><strong>Admin ID:</strong> {recrutador.adminId}</Typography>
      </Paper>
    </Box>
  );
};

export default Recrutador;
