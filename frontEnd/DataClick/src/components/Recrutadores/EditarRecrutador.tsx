import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import {
  TextField,
  Box,
  Typography,
  Paper,
  Button,
  CircularProgress
} from "@mui/material";
import { EntityRecrutador } from "../../types/entityes/EntityRecrutador";
import { RecrutadorService } from "../../api/RecrutadorService";
import { RecrutadorUpdateDTO } from "../../types/entityes/DTO/RecrutadorUpdateDTO";

const EditarRecrutador = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [recrutador, setRecrutador] = useState<RecrutadorUpdateDTO | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    const fetchRecrutador = async () => {
      try {
        const service = RecrutadorService();
        const result = await service.getRecrutadorById(id || "");
        setRecrutador(result);
      } catch (error) {
        console.error("Erro ao buscar recrutador:", error);
      } finally {
        setLoading(false);
      }
    };

    if (id) fetchRecrutador();
  }, [id]);

  const handleChange = (field: keyof EntityRecrutador, value: string) => {
    if (!recrutador) return;
    setRecrutador({ ...recrutador, [field]: value });
  };

  const handleSave = async () => {
    if (!recrutador) return;
    try {
      setSaving(true);
      const service = RecrutadorService();
      await service.alterarRecrutador(id || '', recrutador);
      navigate("/recrutadores");
    } catch (error) {
      console.error("Erro ao atualizar recrutador:", error);
    } finally {
      setSaving(false);
    }
  };

  if (loading || !recrutador) {
    return (
      <Box display="flex" justifyContent="center" mt={4}>
        <CircularProgress />
      </Box>
    );
  }

  return (
    <Box p={4} sx={{ fontFamily: "Roboto, Arial, sans-serif" }}>
      <Paper elevation={3} sx={{ p: 3 }}>
        <Typography variant="h5" gutterBottom>
          Editar Recrutador
        </Typography>

        <Box display="flex" flexDirection="column" gap={2}>
          <TextField
            label="Nome"
            value={recrutador.nome}
            onChange={(e) => handleChange("nome", e.target.value)}
            fullWidth
          />
          <TextField
            label="Telefone"
            value={recrutador.telefone}
            onChange={(e) => handleChange("telefone", e.target.value)}
            fullWidth
          />
          <TextField
            label="E-mail"
            value={recrutador.email}
            onChange={(e) => handleChange("email", e.target.value)}
            fullWidth
          />
          <Button
            variant="contained"
            color="primary"
            onClick={handleSave}
            disabled={saving}
          >
            {saving ? "Salvando..." : "Salvar"}
          </Button>
        </Box>
      </Paper>
    </Box>
  );
};

export default EditarRecrutador;
