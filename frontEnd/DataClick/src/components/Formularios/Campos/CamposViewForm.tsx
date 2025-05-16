import React, { useEffect, useState } from "react";
import { CampoService } from "../../../api/CampoService";
import { EntityCampo } from "../../../types/entityes/EntityCampo";

import {
  Box,
  Typography,
  Paper,
  TextField,
  Checkbox,
  FormControl,
  FormControlLabel,
  CircularProgress,
  Grid,
  Select,
  MenuItem,
  InputLabel
} from "@mui/material";

const tiposPermitidos = ["TEXTO", "NUMERO", "DATA", "CHECKBOX", "EMAIL"];

interface CamposViewFormProps {
  formId: string;
}

const CamposViewForm: React.FC<CamposViewFormProps> = ({ formId }) => {
  const [campos, setCampos] = useState<EntityCampo[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const campoService = CampoService();
    const fetchCampo = async () => {
      try {
        const campos: EntityCampo[] = await campoService.getCamposByFormId(formId);
        setCampos(campos);
      } catch (error) {
        console.error("Erro ao buscar campos:", error);
      } finally {
        setLoading(false);
      }
    };

    if (formId) {
      fetchCampo();
    }
  }, [formId]);

  if (loading)
    return (
      <Box display="flex" justifyContent="center" mt={4}>
        <CircularProgress />
      </Box>
    );

  if (!campos.length)
    return (
      <Typography variant="body1" align="center" mt={4}>
        Nenhum campo encontrado
      </Typography>
    );

  return (
    <Box p={3}>
      <Box display="flex" flexDirection="column" gap={3}>
        {campos.map((campo, index) => (
          <Box key={campo.campoId || index}>
            <Paper elevation={2} sx={{ p: 2 }}>
              <Typography variant="h6" gutterBottom>
                {campo.campoTitulo}
              </Typography>

              <Box mb={2}>
                <FormControl fullWidth>
                  <InputLabel>Tipo</InputLabel>
                  <Select disabled value={campo.campoTipo} label="Tipo">
                    {tiposPermitidos.map((tipo) => (
                      <MenuItem key={tipo} value={tipo}>
                        {tipo}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Box>
            </Paper>
          </Box>
        ))}
      </Box>
    </Box>

  );
};

export default CamposViewForm;
