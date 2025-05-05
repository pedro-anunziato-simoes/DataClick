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
  Alert
} from "@mui/material";
import { AdministradorService } from "../../api/AdminitradorService";
import { EntityAdministrador } from "../../types/entityes/EntityAdministrador";


const AdministradorPerfil: React.FC = () => {
  const [administrador, setAdministrador] = useState<EntityAdministrador | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const adminitradorService = AdministradorService();

  useEffect(() => {
    const fetchData = async () => {
      try {
        const data = await adminitradorService.getInfosAdminitrador();
        console.log(data);
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
      <Card sx={{ maxWidth: 600, margin: "0 auto" }}>
        <CardContent>
          <Typography variant="h5" gutterBottom>
            Perfil do Administrador
          </Typography>

          <Typography><strong>Nome:</strong> {administrador.nome}</Typography>
          <Typography><strong>Email:</strong> {administrador.email}</Typography>
          <Typography><strong>Telefone:</strong> {administrador.telefone}</Typography>
          <Typography><strong>CNPJ:</strong> {administrador.cnpj}</Typography>

          <Divider sx={{ my: 2 }} />

          <Typography variant="h6">Recrutadores</Typography>
          <List dense>
            {administrador.recrutadores.length > 0 ? (
              administrador.recrutadores.map((r) => (
                <ListItem key={r.usuarioId}>
                  <ListItemText primary={r.nome} />
                </ListItem>
              ))
            ) : (
              <Typography variant="body2">Nenhum recrutador vinculado.</Typography>
            )}
          </List>

          <Divider sx={{ my: 2 }} />

          <Typography variant="h6">Formulários</Typography>
          <List dense>
            {administrador.formularios.length > 0 ? (
              administrador.formularios.map((f) => (
                <ListItem key={f.adminId}>
                  <ListItemText primary={f.titulo} />
                </ListItem>
              ))
            ) : (
              <Typography variant="body2">Nenhum formulário vinculado.</Typography>
            )}
          </List>
          <Divider sx={{ my: 2 }} />
          <Typography variant="h6">Licensa</Typography>
        </CardContent>
      </Card>
    </Container>
  );
};

export default AdministradorPerfil;
