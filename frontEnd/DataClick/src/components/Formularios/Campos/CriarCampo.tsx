import { useState } from "react";
import { CampoService } from "../../../api/CampoService";
import {
  Box,
  TextField,
  MenuItem,
  Select,
  InputLabel,
  FormControl,
  Button,
  Typography,
  Paper,
  Container
} from "@mui/material";
import { useNavigate, useParams } from "react-router-dom";
import { CampoCreateDTO } from "../../../types/entityes/DTO/CampoCreateDTO";

const tipos = ["TEXTO", "NUMERO", "DATA", "CHECKBOX", "RADIO", "EMAIL"];

const CriarCampo = () => {
  const { formId } = useParams<{ formId: string }>();
  const navigate = useNavigate();
  const [formData, setFormData] = useState<CampoCreateDTO>({
    campoTituloDto: "",
    campoTipoDto: "",
    resposta: { tipo: "" },
  });

  const handleTipoChange = (e: { target: { value: any } }) => {
    const tipoSelecionado = e.target.value;
    setFormData({
      ...formData,
      campoTipoDto: tipoSelecionado,
      resposta: {
        tipo: "",
      },
    });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!formData.campoTituloDto || !formData.campoTipoDto) {
      alert("Por favor, preencha todos os campos.");
      return;
    }
    try {
      const campoService = CampoService();
      await campoService.adicionarCampo(formId || '', formData);
      alert("Campo adicionado com sucesso!");
      navigate("/eventos");
    } catch (error) {
      console.error("Erro ao adicionar campo:", error);
      alert("Erro ao adicionar campo: " + error);
    }
  };

  return (
    <Box
      minHeight="100vh"
      sx={{
        background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)",
        py: 5,
      }}
    >
      <Container maxWidth="sm">
        <Paper elevation={4} sx={{ p: 4, borderRadius: 4 }}>
          <Typography variant="h5" gutterBottom textAlign="center">
            Adicionar Novo Campo
          </Typography>

          <Box component="form" onSubmit={handleSubmit} mt={3}>
            <TextField
              label="Título do Campo"
              value={formData.campoTituloDto}
              onChange={(e) =>
                setFormData({ ...formData, campoTituloDto: e.target.value })
              }
              fullWidth
              variant="outlined"
              margin="normal"
            />

            <FormControl fullWidth margin="normal">
              <InputLabel>Tipo</InputLabel>
              <Select
                value={formData.campoTipoDto}
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

            <Button
              type="submit"
              variant="contained"
              fullWidth
              sx={{
                mt: 3,
                py: 1.5,
                fontWeight: "bold",
                backgroundColor: "#1976d2",
                ":hover": { backgroundColor: "#1565c0" },
              }}
            >
              Adicionar Campo
            </Button>
          </Box>
        </Paper>
      </Container>
    </Box>
  );
};

export default CriarCampo;
