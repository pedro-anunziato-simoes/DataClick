import React, { useEffect, useState } from 'react';
import { FormulariosPreenchidosService } from '../../api/FormulariosPreenchidosService';
import { useParams } from 'react-router-dom';
import { EntityFormulario } from '../../types/entityes/EntityFormulario';

// MUI
import {
  Box,
  Card,
  CardContent,
  CircularProgress,
  Typography,
  List,
  ListItem,
  ListItemText,
  Alert,
  Container,
} from '@mui/material';

const FormulariosPreenchidos: React.FC = () => {
  const { eventoId } = useParams<{ eventoId: string }>();
  const [formularios, setFormularios] = useState<EntityFormulario[]>([]);
  const [loading, setLoading] = useState(true);
  const [erro, setErro] = useState<string | null>(null);

  useEffect(() => {
    const fetchFormularios = async () => {
      const formulariosPreenchidosService = FormulariosPreenchidosService();
      try {
        const response = await formulariosPreenchidosService.getFormulariosPreenchidos(eventoId || '');
        if (response) {
          const listaResponse = response.map((item) => item.formularioPreenchidoListaFormularios);
          setFormularios(listaResponse.flat());
        } else {
          console.error('formularioPreenchidoListaFormularios não encontrado.');
          setFormularios([]);
        }
      } catch (error: any) {
        if (error.response?.status === 404) {
          setErro('Nenhum formulário preenchido foi encontrado para este evento.');
          setFormularios([]);
        } else {
          setErro('Erro ao carregar os formulários.');
        }
      } finally {
        setLoading(false);
      }
    };

    fetchFormularios();
  }, []);

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" mt={4}>
        <CircularProgress />
      </Box>
    );
  }

  if (erro) {
    return (
      <Box mt={4}>
        <Alert severity="error">{erro}</Alert>
      </Box>
    );
  }

  return (
    <Container maxWidth="md" sx={{ mt: 4 }}>
      {formularios.map((formulario, index) => (
        <Card key={index} sx={{ mb: 3, boxShadow: 3 }}>
          <CardContent>
            <Typography variant="h6" gutterBottom>
              <h3>Titulo formulario:{formulario.formularioTitulo}</h3>
            </Typography>
            <List disablePadding>
              {formulario.campos?.filter(Boolean).map((campo, idx) => (
                <ListItem key={idx} disableGutters sx={{ py: 1, px: 0 }}>
                  <ListItemText
                    primary={
                      <span>
                        <strong>Titulo campo: {campo.campoTitulo}:</strong> <br />
                        <strong> Resposta: {String(campo.resposta ?? '')}</strong>
                      </span>
                    }
                  />
                </ListItem>
              ))}
            </List>
          </CardContent>
        </Card>
      ))}
    </Container>
  );
};

export default FormulariosPreenchidos;
