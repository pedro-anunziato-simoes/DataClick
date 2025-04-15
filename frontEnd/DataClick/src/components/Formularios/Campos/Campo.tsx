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

const Campo = () => {
  const [campo, setCampo] = useState<EntityCampo | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const campoService = CampoService();
    const fetchCampo = async () => {
      try {
        const campoUnico: EntityCampo = await campoService.getCampoById("67f451cb8df2d24afb2e45d5");
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

  const renderCampoResposta = (campo: EntityCampo) => {
    const tipo = campo.tipo;

    switch (tipo) {
      case "TEXTO":
      case "NUMERO":
      case "DATA":
      case "EMAIL":
        return (
          <TextField
            fullWidth
            type={tipo === "NUMERO" ? "number" : tipo.toLowerCase()}
            label={campo.titulo}
            variant="outlined"
            value={
              typeof campo.resposta?.tipo === "boolean"
                ? campo.resposta.tipo
                  ? "true"
                  : "false"
                : campo.resposta?.tipo || ""
            }
            onChange={handleRespostaChange}
          />
        );

      case "CHECKBOX":
        return (
          <FormControlLabel
            control={
              <Checkbox
                checked={campo.resposta?.tipo === true}
                onChange={handleRespostaChange}
              />
            }
            label="Marcar"
          />
        );

      case "RADIO":
        return (
          <FormControl component="fieldset">
            <FormLabel component="legend">{campo.titulo}</FormLabel>
            <RadioGroup
              row
              value={campo.resposta?.tipo || ""}
              onChange={handleRespostaChange}
            >
              <FormControlLabel value="sim" control={<Radio />} label="Sim" />
              <FormControlLabel value="nao" control={<Radio />} label="Não" />
            </RadioGroup>
          </FormControl>
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

  if (!campo)
    return (
      <Typography variant="body1" align="center" mt={4}>
        Nenhum campo encontrado
      </Typography>
    );

  return (
    <Box p={3}>
      <form>
        <Grid container spacing={3}>
          <Grid item xs={12}>
            <Paper elevation={2} style={{ padding: 16 }}>
              <Typography variant="h6" gutterBottom>
                {campo.titulo}
              </Typography>
              {renderCampoResposta(campo)}
            </Paper>
          </Grid>
        </Grid>
      </form>
    </Box>
  );
};

export default Campo;
