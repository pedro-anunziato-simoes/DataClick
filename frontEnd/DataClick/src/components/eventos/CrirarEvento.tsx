import React, { useState } from 'react';
import {
  Box,
  Button,
  Container,
  TextField,
  Typography,
  Snackbar,
  Alert,
} from '@mui/material';
import { EventoService } from '../../api/EventoService';
import { useNavigate } from 'react-router-dom';


const CriarEvento: React.FC = () => {
    const navigate = useNavigate();
  const [titulo, setTitulo] = useState('');
  const [descricao, setDescricao] = useState('');
  const [data, setData] = useState('');
  const [mensagem, setMensagem] = useState('');
  const [erro, setErro] = useState(false);
  const [aberto, setAberto] = useState(false);

  const { criarEvento } = EventoService();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    try {
      await criarEvento({
        eventoTituloDto: titulo,
        eventoDescricaoDto: descricao,
        eventoDataDto: new Date(data),
      });

      setMensagem('Evento criado com sucesso!');
      setErro(false);
      setTitulo('');
      setDescricao('');
      setData('');
      navigate("/eventos")
    } catch (error) {
      setMensagem('Erro ao criar evento.');
      setErro(true);
      console.error(error);
    } finally {
      setAberto(true);
    }
  };

  return (
    <Container maxWidth="sm">
      <Box component="form" onSubmit={handleSubmit} mt={4}>
        <Typography variant="h4" gutterBottom>
          Criar Evento
        </Typography>

        <TextField
          label="Título"
          value={titulo}
          onChange={(e) => setTitulo(e.target.value)}
          fullWidth
          required
          margin="normal"
        />

        <TextField
          label="Descrição"
          value={descricao}
          onChange={(e) => setDescricao(e.target.value)}
          fullWidth
          required
          margin="normal"
          multiline
          rows={4}
        />

        <TextField
          label="Data"
          type="date"
          value={data}
          onChange={(e) => setData(e.target.value)}
          fullWidth
          required
          margin="normal"
          InputLabelProps={{
            shrink: true,
          }}
        />

        <Box mt={2}>
          <Button type="submit" variant="contained" color="primary" fullWidth>
            Criar Evento
          </Button>
        </Box>
      </Box>

      <Snackbar
        open={aberto}
        autoHideDuration={4000}
        onClose={() => setAberto(false)}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
      >
        <Alert
          severity={erro ? 'error' : 'success'}
          onClose={() => setAberto(false)}
          sx={{ width: '100%' }}
        >
          {mensagem}
        </Alert>
      </Snackbar>
    </Container>
  );
};

export default CriarEvento;
