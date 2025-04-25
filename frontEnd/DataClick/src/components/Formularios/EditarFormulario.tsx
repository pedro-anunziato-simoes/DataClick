import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import {
    Box,
    Typography,
    TextField,
    Button,
    Paper,
    Stack,
    CircularProgress,
} from "@mui/material";
import { FormularioService } from "../../api/FormularioService";
import { EntityFormulario } from "../../types/entityes/EntityFormulario";

const EditarFormulario = () => {
    const { formId } = useParams<{ formId: string }>();
    const navigate = useNavigate();
    const [formulario, setFormulario] = useState<EntityFormulario | null>(null);
    const [titulo, setTitulo] = useState("");
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);

    useEffect(() => {
        const fetchFormulario = async () => {
            try {
                const formularioService = FormularioService();
                const result = await formularioService.getFormularioById(formId || '');
                setFormulario(result);
                setTitulo(result.titulo);
            } catch (error) {
                console.error("Erro ao buscar formulário:", error);
            } finally {
                setLoading(false);
            }
        };
        if (formId) fetchFormulario();
    }, [formId]);

    const handleSalvar = async () => {
        if (!formulario) return;
        try {
            const formularioService = FormularioService();
            setSaving(true);
            await formularioService.alterarForms(formId || '', {
                ...formulario,
                titulo,
            });
            navigate("/formularios");
        } catch (error) {
            console.error("Erro ao salvar alterações:", error);
        } finally {
            setSaving(false);
        }
    };

    if (loading) {
        return (
            <Box display="flex" justifyContent="center" mt={4}>
                <CircularProgress />
            </Box>
        );
    }

    return (
        <Box p={4}>
            <Paper elevation={3} sx={{ p: 4 }}>
                <Typography variant="h5" gutterBottom>
                    Editar Formulário
                </Typography>
                <Stack spacing={2}>
                    <TextField
                        label="Título do Formulário"
                        value={titulo}
                        onChange={(e) => setTitulo(e.target.value)}
                        fullWidth
                    />
                    <Box display="flex" justifyContent="flex-end" gap={2}>
                        <Button onClick={() => navigate("/formularios")} color="inherit">
                            Cancelar
                        </Button>
                        <Button
                            onClick={handleSalvar}
                            variant="contained"
                            color="primary"
                            disabled={saving}
                        >
                            {saving ? "Salvando..." : "Salvar"}
                        </Button>
                    </Box>
                </Stack>
            </Paper>
        </Box>
    );
};

export default EditarFormulario;
