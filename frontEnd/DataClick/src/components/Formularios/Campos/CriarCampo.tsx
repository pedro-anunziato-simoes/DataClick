import { useState } from "react";
import { CampoService } from "../../../api/CampoService";
import { EntityCampo } from "../../../types/entityes/EntityCampo"; // Importe a interface EntityCampo
import {
  Box,
  TextField,
  MenuItem,
  Select,
  InputLabel,
  FormControl,
  Button,
  FormControlLabel,
  Checkbox,
  RadioGroup,
  Radio,
  FormLabel
} from "@mui/material";

const tipos = [
  "TEXTO",
  "NUMERO",
  "DATA",
  "CHECKBOX",
  "RADIO",
  "EMAIL",
];

const CriarCampo = ({ formId }: { formId: string }) => { // Adicionando formId como prop
  const [formData, setFormData] = useState<EntityCampo>({
    titulo: "",
    tipo: "",
    resposta: { tipo: "" },
    // Removendo o campoId que será gerado pelo banco de dados
  });

  const handleTipoChange = (e: { target: { value: any } }) => {
    const tipoSelecionado = e.target.value;
    setFormData({
      ...formData,
      tipo: tipoSelecionado,
      resposta: {
        tipo: "",
      },
    });
  };

  const handleRespostaChange = (e: { target: { checked: any; value: any } }) => {
    const value =
      formData.tipo === "CHECKBOX" ? e.target.checked : e.target.value;

    setFormData({
      ...formData,
      resposta: {
        tipo: value,
      },
    });
  };

  const renderCampoResposta = () => {
    const tipo = formData.tipo;

    switch (tipo) {
      case "TEXTO":
        return (
          <TextField
            label="Resposta"
            value={formData.resposta.tipo}
            onChange={handleRespostaChange}
            fullWidth
            variant="outlined"
          />
        );
      case "NUMERO":
        return (
          <TextField
            type="number"
            label="Resposta"
            value={formData.resposta.tipo}
            onChange={handleRespostaChange}
            fullWidth
            variant="outlined"
          />
        );
      case "DATA":
        return (
          <TextField
            type="date"
            label="Resposta"
            value={formData.resposta.tipo}
            onChange={handleRespostaChange}
            fullWidth
            variant="outlined"
            InputLabelProps={{ shrink: true }}
          />
        );
      case "CHECKBOX":
        return (
          <FormControlLabel
            control={
              <Checkbox
                checked={formData.resposta.tipo === true}
                onChange={handleRespostaChange}
              />
            }
            label="Marcar"
          />
        );
      case "RADIO":
        return (
          <FormControl component="fieldset">
            <FormLabel component="legend">Resposta</FormLabel>
            <RadioGroup
              value={formData.resposta.tipo}
              onChange={handleRespostaChange}
              row
            >
              <FormControlLabel value="sim" control={<Radio />} label="Sim" />
              <FormControlLabel value="nao" control={<Radio />} label="Não" />
            </RadioGroup>
          </FormControl>
        );
      case "EMAIL":
        return (
          <TextField
            type="email"
            label="Resposta"
            value={formData.resposta.tipo}
            onChange={handleRespostaChange}
            fullWidth
            variant="outlined"
          />
        );
      default:
        return null;
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    // Validar se o formulário está preenchido corretamente
    if (!formData.titulo || !formData.tipo || !formData.resposta.tipo) {
      alert("Por favor, preencha todos os campos.");
      return;
    }

    try {
      const campoService = CampoService();
      // Não enviamos campoId, pois ele será gerado automaticamente pelo banco de dados
      await campoService.adicionarCampo('67f451a58df2d24afb2e45d4', formData); // Passando formId e formData (sem campoId)
      alert("Campo adicionado com sucesso!");
    } catch (error) {
      console.error("Erro ao adicionar campo:", error);
      alert("Erro ao adicionar campo.");
    }
  };

  return (
    <Box component="form" onSubmit={handleSubmit} p={3}>
      <TextField
        label="Título"
        value={formData.titulo}
        onChange={(e) =>
          setFormData({ ...formData, titulo: e.target.value })
        }
        fullWidth
        variant="outlined"
        margin="normal"
      />

      <FormControl fullWidth margin="normal">
        <InputLabel>Tipo</InputLabel>
        <Select
          value={formData.tipo}
          onChange={handleTipoChange}
          label="Tipo"
        >
          <MenuItem value="">Selecione o tipo</MenuItem>
          {tipos.map((tipo) => (
            <MenuItem key={tipo} value={tipo}>
              {tipo}
            </MenuItem>
          ))}
        </Select>
      </FormControl>

      <FormControl fullWidth margin="normal">
        <InputLabel>Resposta</InputLabel>
        {renderCampoResposta()}
      </FormControl>

      <Button type="submit" variant="contained" color="primary" fullWidth>
        Adicionar Campo
      </Button>
    </Box>
  );
};

export default CriarCampo;
