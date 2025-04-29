import { useState } from "react";
import { CampoService } from "../../../api/CampoService";
import { EntityCampo } from "../../../types/entityes/EntityCampo";
import {
  Box,
  TextField,
  MenuItem,
  Select,
  InputLabel,
  FormControl,
  Button
} from "@mui/material";
import {useNavigate, useParams } from "react-router-dom";
import { CampoCreateDTO } from "../../../types/entityes/DTO/CampoCreateDTO";

const tipos = [
  "TEXTO",
  "NUMERO",
  "DATA",
  "CHECKBOX",
  "RADIO",
  "EMAIL",
];

const CriarCampo = () => {
  const { formId } = useParams<{ formId: string }>();
  const navigate = useNavigate();
  const [formData, setFormData] = useState<CampoCreateDTO>({
    titulo: "",
    tipo: "",
    resposta: { tipo: "" },
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

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!formData.titulo || !formData.tipo) {
      alert("Por favor, preencha todos os campos.");
      return;
    }
    try {
      const campoService = CampoService();
      await campoService.adicionarCampo(formId || '', formData);
      alert("Campo adicionado com sucesso!");
      navigate("/formularios")
    } catch (error) {
      console.error("Erro ao adicionar campo:", error);
      alert("Erro ao adicionar campo." + error);
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

      <Button type="submit" variant="contained" color="primary" fullWidth>
        Adicionar Campo
      </Button>
    </Box>
  );
};

export default CriarCampo;
