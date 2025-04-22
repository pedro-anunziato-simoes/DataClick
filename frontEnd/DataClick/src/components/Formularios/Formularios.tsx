import { useEffect, useState } from "react";
import { FormularioService } from "../../api/FormularioService";
import { useNavigate } from "react-router-dom";
import CamposViewForm from "./Campos/CamposViewForm";
import { IconButton } from "@mui/material";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";

const Formularios = () => {
    const [formularios, setFormularios] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const navigate = useNavigate();
    useEffect(() => {
        const formularioService = FormularioService();
        const fetchFormularios = async () => {
            try {
                const data = await formularioService.getFormulariosByAdminId();
                setFormularios(data);
            } catch (error) {
                console.error("Erro ao buscar formulários:", error);
            } finally {
                setLoading(false);
            }
        };

        fetchFormularios();
    }, []);

    const handleEditarForms = (formId: string) => {
        navigate(`/campos/${formId}`);
    };

    if (loading) return <p>Carregando formulários...</p>;

    return (
        <div className="formularios-container">
                <IconButton onClick={() => navigate(-1)} sx={{ alignSelf: "flex-start", mb: 2 }}>
          <ArrowBackIcon />
        </IconButton>
            {formularios.map((formulario) => (
                <form key={formulario.id} className="formulario-item">
                    <h2>{formulario.titulo}</h2>
                    <CamposViewForm formId={formulario.id} />
                    <button
                        type="button"
                        onClick={() => handleEditarForms(formulario.id)}
                    >
                        Editar Formulário
                    </button>
                    <hr />
                </form>
            ))}
        </div>
    );
};

export default Formularios;