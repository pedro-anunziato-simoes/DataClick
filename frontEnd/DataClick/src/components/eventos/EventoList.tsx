import React, { useEffect, useState } from 'react';
import { EntityEvento } from '../../types/entityes/EntityEvento';
import { EventoService } from '../../api/EventoServise';
import {
  Card,
  CardContent,
  Typography,
  CircularProgress,
  Alert,
  Stack,
  Box,
  Button,
} from '@mui/material';
import { useNavigate } from 'react-router-dom';

const EventosList: React.FC = () => {
  const [eventos, setEventos] = useState<EntityEvento[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const eventoService = EventoService();
  const navigate = useNavigate();

  useEffect(() => {
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
      <Typography variant="h5" gutterBottom>
        Lista de Eventos
      </Typography>

      {eventos.length === 0 ? (
        <Alert severity="info">Nenhum evento encontrado.</Alert>
      ) : (
        <Stack spacing={2}>
          {eventos.map((evento) => (
            <Card key={evento.eventoId} variant="outlined">
              <CardContent>
                <Typography variant="h6">{evento.eventoTitulo}</Typography>
                <Typography color="text.secondary" gutterBottom>
                  {new Date(evento.eventoData).toLocaleString()}
                </Typography>
                <Typography variant="body2" paragraph>
                  {evento.eventoDescricao}
                </Typography>
                <Button
                  variant="contained"
                  color="primary"
                  onClick={() => navigate(`/formularios/${evento.eventoId}`)}
                >
                  Ver Formulários
                </Button>
              </CardContent>
            </Card>
          ))}
        </Stack>
      )}
    </Box>
  );
};

export default EventosList;
