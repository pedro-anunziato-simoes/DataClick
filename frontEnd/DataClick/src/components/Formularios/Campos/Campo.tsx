import React, { useEffect, useState } from "react";
import { CampoService } from "../../../api/CampoService";
import { EntityCampo } from "../../../types/entityes/EntityCampo";

import {
  Box,
  Typography,
  Paper,
  TextField,
  Checkbox,
  Radio,
  RadioGroup,
  FormControl,
  FormControlLabel,
  FormLabel,
  CircularProgress,
  Grid
} from "@mui/material";
import { useParams } from "react-router-dom";

const Campo = () => {
  const { formId } = useParams<{ formId: string }>();
  const [campo, setCampo] = useState<EntityCampo | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const campoService = CampoService();
    const fetchCampo = async () => {
      try {
        const campoUnico: EntityCampo = await campoService.getCampoById(formId || '');
        setCampo(campoUnico);
      } catch (error) {
        console.error("Erro ao buscar campo:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchCampo();
  }, []);

  const handleRespostaChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    if (!campo) return;

    const { value, type } = e.target;
    const resposta =
      type === "checkbox" && e.target instanceof HTMLInputElement
        ? e.target.checked
        : value;

    setCampo({
      ...campo,
      resposta: {
        tipo: resposta,
      },
    });
  };

  if (loading)
    return (
      <Box display="flex" justifyContent="center" mt={4}>
        <CircularProgress />
      </Box>
    );

  if (!campo)
    return (
      <Typography variant="body1" align="center" mt={4}>
        Nenhum campo encontrado
      </Typography>
    );

  return (
    <Box p={3}>
      <form>
        <Box display="flex" flexDirection="column" gap={3}>
          <Paper elevation={2} sx={{ p: 2 }}>
            <Typography variant="h6" gutterBottom>
              {campo.campoTitulo}
            </Typography>
          </Paper>
        </Box>
      </form>
    </Box>

  );
};

export default Campo;
