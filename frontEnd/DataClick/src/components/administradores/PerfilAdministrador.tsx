import React, { useEffect, useState } from "react";
import {
  Card,
  CardContent,
  Typography,
  Divider,
  List,
  ListItem,
  ListItemText,
  Container,
  CircularProgress,
  Alert,
  Box,
  Stack
} from "@mui/material";
import { AdministradorService } from "../../api/AdminitradorService";
import { EntityAdministrador } from "../../types/entityes/EntityAdministrador";
import { EventoService } from "../../api/EventoService";
import { EntityEvento } from "../../types/entityes/EntityEvento";

const AdministradorPerfil: React.FC = () => {
  const [administrador, setAdministrador] = useState<EntityAdministrador | null>(null);
  const [eventos, setEventos] = useState<EntityEvento[] | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const adminitradorService = AdministradorService();
  const eventosService = EventoService();

  useEffect(() => {
    const fetchData = async () => {
      try {
        const data = await adminitradorService.getInfosAdminitrador();
        const dataEventos = await eventosService.getEventos();
        setEventos(dataEventos);
        setAdministrador(data);
      } catch (err) {
        console.error(err);
        setError("Erro ao carregar perfil do administrador.");
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (loading) {
    return (
      <Container sx={{ mt: 4, textAlign: "center" }}>
        <CircularProgress />
      </Container>
    );
  }

  if (error) {
    return (
      <Container sx={{ mt: 4 }}>
        <Alert severity="error">{error}</Alert>
      </Container>
    );
  }

  if (!administrador) {
    return null;
  }

  return (
    <Container sx={{ mt: 4 }}>
      <Card
        sx={{
          maxWidth: 600,
          margin: "0 auto",
          boxShadow: 5,
          borderRadius: 3,
          backgroundColor: "#f9fafb",
        }}
      >
        <CardContent>
          <Typography variant="h5" gutterBottom sx={{ fontWeight: "bold", mb: 2 }}>
            Perfil do Administrador
          </Typography>

          <Stack spacing={1} sx={{ mb: 2 }}>
            <Typography><strong>Nome:</strong> {administrador.nome}</Typography>
            <Typography><strong>Email:</strong> {administrador.email}</Typography>
            <Typography><strong>Telefone:</strong> {administrador.telefone}</Typography>
            <Typography><strong>CNPJ:</strong> {administrador.cnpj}</Typography>
          </Stack>

          <Divider sx={{ my: 2 }} />

          <Typography variant="subtitle1" sx={{ fontWeight: "bold" }}>
            Recrutadores
          </Typography>
          <Box sx={{ mt: 1, mb: 2 }}>
            {administrador.adminRecrutadores.length > 0 ? (
              <List dense>
                {administrador.adminRecrutadores.map((r) => (
                  <ListItem key={r.usuarioId}>
                    <ListItemText primary={r.nome} />
                  </ListItem>
                ))}
              </List>
            ) : (
              <Typography variant="body2" color="text.secondary">
                Nenhum recrutador vinculado.
              </Typography>
            )}
          </Box>

          <Divider sx={{ my: 2 }} />

          <Typography variant="subtitle1" sx={{ fontWeight: "bold" }}>
            Eventos
          </Typography>
          <Box sx={{ mt: 1, mb: 2 }}>
            {eventos?.length ? (
              <List dense>
                {eventos.map((evento, index) => (
                  <ListItem key={index}>
                    <ListItemText
                      primary={evento.eventoTitulo}
                      secondary={
                        evento.eventoData
                          ? new Date(evento.eventoData).toLocaleString("pt-BR")
                          : "Data não disponível"
                      }
                    />
                  </ListItem>
                ))}
              </List>
            ) : (
              <Typography variant="body2" color="text.secondary">
                Nenhum evento disponível.
              </Typography>
            )}
          </Box>

          <Divider sx={{ my: 2 }} />

          <Typography variant="subtitle1" sx={{ fontWeight: "bold" }}>
            Licensa
          </Typography>
        </CardContent>
      </Card>
    </Container>
  );
};

export default AdministradorPerfil;
