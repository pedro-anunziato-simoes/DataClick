import { useEffect, useState } from "react";
import { FormularioService } from "../../api/FormularioService";
import { useNavigate, useParams } from "react-router-dom";
import {
  Box,
  Typography,
  Paper,
  Button,
  CircularProgress,
  Stack,
  IconButton,
  Dialog,
  DialogTitle,
  DialogActions,
  Alert,
  Container,
} from "@mui/material";
import DeleteIcon from "@mui/icons-material/Delete";
import Footer from "../footer/Footer";
import Sidebar from "../sideBar/Sidebar";
import CamposViewForm from "./Campos/CamposViewForm";

const Formularios = () => {
  const { idEvento } = useParams<{ idEvento: string }>();
  const [formularios, setFormularios] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [confirmDeleteId, setConfirmDeleteId] = useState<string | null>(null);
  const navigate = useNavigate();
  const formularioService = FormularioService();

  useEffect(() => {
    buscarFormularios();
  }, []);

  const buscarFormularios = async () => {
    try {
      setLoading(true);
      const data = await formularioService.getFormulariosEvento(idEvento || "");
      setFormularios(data ?? []);
    } catch (error) {
      console.error("Erro ao buscar formulários:", error);
      setFormularios([]);
    } finally {
      setLoading(false);
    }
  };

  const handleEditarCampos = (formId: string) => {
    navigate(`/campos/${formId}`);
  };

  const handleEditarFormulario = (formId: string) => {
    navigate(`/editarFormulario/${formId}`);
  };

  const handleDelete = async () => {
    if (!confirmDeleteId) return;
    try {
      await formularioService.removerForms(confirmDeleteId);
      await buscarFormularios();
    } catch (error) {
      console.error("Erro ao excluir formulário:", error);
    } finally {
      setConfirmDeleteId(null);
    }
  };

  return (
    <Box
      sx={{
        minHeight: "100vh",
        background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)",
        display: "flex",
        flexDirection: "column",
      }}
    >
      <Sidebar />

      <Box
        sx={{
          flexGrow: 1,
          display: "flex",
          justifyContent: "center",
          alignItems: "flex-start",
          px: 2,
          pt: 3,
        }}
      >
        <Container maxWidth="md">
          <Typography
            variant="h5"
            align="center"
            gutterBottom
            sx={{ mb: 4 }}
          >
            Formulários Cadastrados
          </Typography>

          {loading ? (
            <Box display="flex" justifyContent="center" mt={4}>
              <CircularProgress />
            </Box>
          ) : formularios.length === 0 ? (
            <>
              <Alert severity="info" sx={{ mb: 3 }}>
                Nenhum formulário cadastrado para este evento.
              </Alert>
              <Box textAlign="center">
                <Button
                  variant="contained"
                  color="primary"
                  onClick={() => navigate(`/criarFormularios/${idEvento}`)}
                  sx={{ px: 4, py: 1.2 }}
                >
                  Criar novo formulário
                </Button>
              </Box>
            </>
          ) : (
            <Stack spacing={3}>
              {formularios
                .filter((formulario) => formulario !== null)
                .map((formulario) => (
                  <Paper
                    key={formulario.formId}
                    elevation={2}
                    sx={{
                      p: 2,
                      borderRadius: 2,
                      backgroundColor: "#fff",
                    }}
                  >
                    <Box
                      display="flex"
                      justifyContent="space-between"
                      alignItems="center"
                    >
                      <Typography variant="subtitle1">
                        Título formulário: {formulario.formularioTitulo}
                      </Typography>
                      <IconButton
                        onClick={() => setConfirmDeleteId(formulario.formId)}
                        color="error"
                      >
                        <DeleteIcon />
                      </IconButton>
                    </Box>

                    <CamposViewForm formId={formulario.formId} />

                    <Box mt={2}>
                      <Stack direction="row" spacing={2}>
                        <Button
                          variant="contained"
                          color="primary"
                          onClick={() => handleEditarCampos(formulario.formId)}
                          sx={{ textTransform: "none", px: 3 }}
                        >
                          Editar Campos
                        </Button>
                        <Button
                          variant="contained"
                          color="secondary"
                          onClick={() => handleEditarFormulario(formulario.formId)}
                          sx={{ textTransform: "none", px: 3 }}
                        >
                          Editar Formulário
                        </Button>
                      </Stack>
                    </Box>
                  </Paper>
                ))}
              <Box textAlign="center" mt={3}>
                <Button
                  variant="contained"
                  color="primary"
                  onClick={() => navigate(`/criarFormularios/${idEvento}`)}
                  sx={{ px: 4, py: 1.2 }}
                >
                  Criar novo formulário
                </Button>
              </Box>
            </Stack>
          )}

          <Dialog open={!!confirmDeleteId} onClose={() => setConfirmDeleteId(null)}>
            <DialogTitle>Deseja realmente excluir este formulário?</DialogTitle>
            <DialogActions>
              <Button onClick={() => setConfirmDeleteId(null)} color="inherit">
                Cancelar
              </Button>
              <Button onClick={handleDelete} color="error">
                Excluir
              </Button>
            </DialogActions>
          </Dialog>
        </Container>
      </Box>

      <Footer />
    </Box>
  );
};

export default Formularios;
