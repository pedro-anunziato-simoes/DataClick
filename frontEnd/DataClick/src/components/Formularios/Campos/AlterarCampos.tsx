import React, { useEffect, useState } from "react";
import { CampoService } from "../../../api/CampoService";
import { EntityCampo } from "../../../types/entityes/EntityCampo";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import { useNavigate, useParams } from "react-router-dom";
import { SelectChangeEvent } from "@mui/material/Select";

import {
  Box,
  Typography,
  Paper,
  TextField,
  FormControl,
  Button,
  CircularProgress,
  Select,
  MenuItem,
  InputLabel,
  IconButton
} from "@mui/material";


const tiposPermitidos = ["TEXTO", "NUMERO", "DATA", "CHECKBOX", "EMAIL"];

const AlterarCamposForms = () => {
  const { formId } = useParams<{ formId: string }>();
  const [campos, setCampos] = useState<EntityCampo[]>([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const campoService = CampoService();
    const fetchCampo = async () => {
      try {
        if (!formId) {
          throw new Error("formId não encontrado na URL");
        }
        const campos: EntityCampo[] = await campoService.getCamposByFormId(formId);
        setCampos(campos);
      } catch (error) {
        console.error("Erro ao buscar campos:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchCampo();
  }, [formId]);

  const handleTipoChange = (
    index: number,
    e: SelectChangeEvent
  ) => {
    const novosCampos = [...campos];
    novosCampos[index] = {
      ...novosCampos[index],
      tipo: e.target.value,
    };
    setCampos(novosCampos);
  };

  const handleTituloChange = (
    index: number,
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const novosCampos = [...campos];
    novosCampos[index] = {
      ...novosCampos[index],
      titulo: e.target.value,
    };
    setCampos(novosCampos);
  };
  

  const handleSalvarCampo = async (campoId: string, tipo: string, titulo: string, index: number) => {
    const campoService = CampoService();
    navigate("/formularios")
    try {
      await campoService.alterarCampo(campoId, tipo, titulo);
      alert("Campo salvo com sucesso!");
    } catch (error) {
      console.error("Erro ao salvar campo:", error);
      alert("Erro ao salvar campo");
    }
  };

  const handleDeletarCampo = async (campoId: string, index: number) => {
    const confirmDelete = window.confirm("Tem certeza que deseja apagar este campo?");

    if (confirmDelete) {
      const campoService = CampoService();

      try {
        await campoService.deletarCampo(campoId);
        const novosCampos = [...campos];
        novosCampos.splice(index, 1);
        setCampos(novosCampos);

        alert("Campo deletado com sucesso!");
      } catch (error) {
        console.error("Erro ao deletar campo:", error);
        alert("Erro ao deletar campo");
      }
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
        Esse formulario não possui campos
      </Typography>
    );

  return (
    <Box p={3}>
  <IconButton onClick={() => navigate("/formularios")} sx={{ alignSelf: "flex-start", mb: 2 }}>
    <ArrowBackIcon />
  </IconButton>

  <Box display="flex" flexDirection="column" gap={3}>
    {campos.map((campo, index) => (
      <Box key={campo.campoId || index}>
        <Paper elevation={2} sx={{ p: 2 }}>
          <TextField
            fullWidth
            label="Título do Campo"
            value={campo.titulo}
            onChange={(e) => handleTituloChange(index, e)}
            variant="outlined"
            sx={{ mb: 2 }}
          />

          <FormControl fullWidth sx={{ mb: 2 }}>
            <InputLabel>Tipo</InputLabel>
            <Select
              value={campo.tipo}
              label="Tipo"
              onChange={(e) => handleTipoChange(index, e)}
            >
              {tiposPermitidos.map((tipo) => (
                <MenuItem key={tipo} value={tipo}>
                  {tipo}
                </MenuItem>
              ))}
            </Select>
          </FormControl>

          <Box mt={2} textAlign="center">
            <Button
              variant="contained"
              color="primary"
              onClick={() => handleSalvarCampo(campo.campoId, campo.tipo, campo.titulo, index)}
            >
              Salvar
            </Button>
          </Box>

          <Box mt={2} textAlign="center">
            <Button
              variant="outlined"
              color="secondary"
              onClick={() => handleDeletarCampo(campo.campoId, index)}
            >
              Deletar
            </Button>
          </Box>
        </Paper>
      </Box>
    ))}
  </Box>
</Box>

  );
};

export default AlterarCamposForms;
