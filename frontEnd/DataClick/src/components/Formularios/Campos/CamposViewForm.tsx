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

// ✅ Adicione a tipagem de props
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
  }, [formId]); // Reexecuta caso o formId mude

  const handleRespostaChange = (
    index: number,
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const { value, type } = e.target;
    const resposta =
      type === "checkbox" && e.target instanceof HTMLInputElement
        ? e.target.checked
        : value;

    const novosCampos = [...campos];
    novosCampos[index] = {
      ...novosCampos[index],
      resposta: {
        tipo: resposta,
      },
    };
    setCampos(novosCampos);
  };

  const handleTipoChange = (
    index: number,
    e: React.ChangeEvent<{ value: unknown }>
  ) => {
    let novoTipo = e.target.value as string;
    novoTipo = novoTipo.replace(/=$/, "").trim();
    const novosCampos = [...campos];
    novosCampos[index] = {
      ...novosCampos[index],
      tipo: novoTipo,
    };
    setCampos(novosCampos);
  };

  const renderCampoResposta = (campo: EntityCampo, index: number) => {
    const tipo = campo.tipo;

    switch (tipo) {
      case "TEXTO":
      case "NUMERO":
      case "EMAIL":
      case "DATA":
        return (
          <TextField
          disabled
            fullWidth
            type={
              tipo === "NUMERO"
                ? "number"
                : tipo === "DATA"
                ? "date"
                : tipo.toLowerCase()
            }
            label={campo.titulo}
            variant="outlined"
            value={campo.resposta?.tipo || ""}
            onChange={(e) => handleRespostaChange(index, e)}
            InputLabelProps={tipo === "DATA" ? { shrink: true } : undefined}
          />
        );

      case "CHECKBOX":
        return (
          <FormControlLabel
            control={
              <Checkbox
              disabled
                checked={campo.resposta?.tipo === true}
                onChange={(e) => handleRespostaChange(index, e)}
              />
            }
            label="Marcar"
          />
        );

      default:
        return <Typography color="error">Tipo de campo não suportado</Typography>;
    }
  };

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
      <Grid container spacing={3}>
        {campos.map((campo, index) => (
          <Grid item xs={12} key={campo.campoId || index}>
            <Paper elevation={2} sx={{ p: 2 }}>
              <Typography variant="h6" gutterBottom>
                {campo.titulo}
              </Typography>
              <Box mb={2}>
                <FormControl fullWidth>
                  <InputLabel>Tipo</InputLabel>
                  <Select
                    disabled
                    value={campo.tipo}
                    label="Tipo"
                  >
                    {tiposPermitidos.map((tipo) => (
                      <MenuItem key={tipo} value={tipo}>
                        {tipo}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Box>
              {renderCampoResposta(campo, index)}
            </Paper>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
};

export default CamposViewForm;
