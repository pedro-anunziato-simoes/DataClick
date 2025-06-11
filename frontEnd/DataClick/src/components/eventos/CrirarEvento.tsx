import React, { useState } from 'react';
import {
  Box,
  Button,
  TextField,
  Snackbar,
  Alert,
  Paper,
  Typography,
} from '@mui/material';
import { EventoService } from '../../api/EventoService';
import { useNavigate } from 'react-router-dom';
import Sidebar from '../sideBar/Sidebar'; // Sidebar incluída

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
      navigate("/eventos");
    } catch (error) {
      setMensagem('Erro ao criar evento.');
      setErro(true);
      console.error(error);
    } finally {
      setAberto(true);
    }
  };

  return (
    <Box display="flex" height="100vh" overflow="hidden">
      {/* Sidebar fixa à esquerda */}
      <Sidebar />

      {/* Conteúdo centralizado no restante da tela */}
      <Box
        flex="1"
        display="flex"
        alignItems="center"
        justifyContent="center"
        sx={{
          overflow: 'hidden',
          padding: 2,
        }}
      >
        <Paper
          elevation={4}
          sx={{
            p: 4,
            borderRadius: 2,
            width: '100%',
            maxWidth: 500,
            maxHeight: '90vh',
            overflowY: 'auto', // Se for absolutamente necessário, só o Paper rola
          }}
        >
          <Typography variant="h5" fontWeight="bold" mb={2} textAlign="center">
            Criar Evento
          </Typography>

          <Box component="form" onSubmit={handleSubmit}>
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
        </Paper>
      </Box>

      {/* Feedback visual (toast) */}
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
    </Box>
  );
};

export default CriarEvento;
