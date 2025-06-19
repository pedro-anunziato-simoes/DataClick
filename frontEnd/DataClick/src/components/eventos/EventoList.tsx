import React, { useEffect, useState } from 'react';
import { EntityEvento } from '../../types/entityes/EntityEvento';
import { EventoService } from '../../api/EventoService';
import {
  Card,
  CardContent,
  Typography,
  CircularProgress,
  Alert,
  Stack,
  Box,
  Button,
  Snackbar,
  AlertColor,
  Divider,
} from '@mui/material';
import { useNavigate } from 'react-router-dom';

const EventosList: React.FC = () => {
  const [eventos, setEventos] = useState<EntityEvento[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [snackbar, setSnackbar] = useState<{ open: boolean; message: string; severity: AlertColor }>({
    open: false,
    message: '',
    severity: 'success',
  });

  const eventoService = EventoService();
  const navigate = useNavigate();

  const fetchEventos = async () => {
    try {
      const lista: EntityEvento[] = await eventoService.getEventos();
      setEventos(lista);
    } catch (err) {
      setError('Erro ao carregar eventos');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id: string) => {
    try {
      await eventoService.excluirEvento(id);
      setEventos((prev) => prev.filter((e) => e.eventoId !== id));
      setSnackbar({ open: true, message: 'Evento excluído com sucesso.', severity: 'success' });
    } catch (error) {
      console.error(error);
      setSnackbar({ open: true, message: 'Erro ao excluir evento.', severity: 'error' });
    }
  };

  useEffect(() => {
    fetchEventos();
  }, []);

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" mt={4}>
        <CircularProgress />
      </Box>
    );
  }

  if (error) {
    return (
      <Box mt={2}>
        <Alert severity="error">{error}</Alert>
      </Box>
    );
  }

  return (
    <Box mt={4}>
      <Typography variant="h4" align="center" gutterBottom>
        Eventos
      </Typography>

      <Typography variant="h5" gutterBottom>
        Lista de Eventos
      </Typography>

      {eventos.length === 0 ? (
        <Alert severity="info">Nenhum evento encontrado.</Alert>
      ) : (
        <Stack spacing={3}>
          {eventos.map((evento) => (
            <Card key={evento.eventoId} variant="outlined" sx={{ borderRadius: 3, boxShadow: 3 }}>
              <CardContent>
                <Typography variant="h6">{evento.eventoTitulo}</Typography>
                <Typography color="text.secondary" gutterBottom>
                  {new Date(evento.eventoData).toLocaleString()}
                </Typography>
                <Typography variant="body2" paragraph>
                  {evento.eventoDescricao}
                </Typography>
                <Divider sx={{ my: 2 }} />
                <Box display="flex" gap={2} flexWrap="wrap">
                  <Button
                    variant="contained"
                    color="primary"
                    size="small"
                    sx={{ minWidth: 120 }}
                    onClick={() => navigate(`/formularios/${evento.eventoId}`)}
                  >
                    Formulários
                  </Button>
                  <Button
                    variant="outlined"
                    color="secondary"
                    size="small"
                    sx={{ minWidth: 120, color: 'purple', borderColor: 'purple' }}
                    onClick={() => navigate(`/visualizarLeads/${evento.eventoId}`)}
                  >
                    Visualizar Leads
                  </Button>
                  <Button
                    variant="outlined"
                    color="error"
                    size="small"
                    sx={{ minWidth: 120 }}
                    onClick={() => handleDelete(evento.eventoId)}
                  >
                    Excluir
                  </Button>
                </Box>
              </CardContent>
            </Card>
          ))}
        </Stack>
      )}

      <Box mt={4} display="flex" justifyContent="center">
        <Button
          variant="contained"
          color="secondary"
          size="medium"
          sx={{
            backgroundColor: '#9c27b0',
            color: 'white',
            px: 4,
            py: 1.5,
            borderRadius: 2,
            boxShadow: 3,
            '&:hover': {
              backgroundColor: '#7b1fa2',
            },
          }}
          onClick={() => navigate('/criarEventos')}
        >
          Criar Novo Evento
        </Button>
      </Box>

      <Snackbar
        open={snackbar.open}
        autoHideDuration={3000}
        onClose={() => setSnackbar({ ...snackbar, open: false })}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
      >
        <Alert onClose={() => setSnackbar({ ...snackbar, open: false })} severity={snackbar.severity}>
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Box>
  );
};

export default EventosList;
