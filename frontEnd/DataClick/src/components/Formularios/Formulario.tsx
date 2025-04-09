import { useEffect, useState } from "react";
import { FormularioService } from "../../api/FormularioService";
import { useNavigate } from "react-router-dom";
import CamposViewForm from "./Campos/CamposViewForm";

const Formularios = () => {
    const [formularios, setFormularios] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const navigate = useNavigate();
    useEffect(() => {
        const formularioService = FormularioService();
        const fetchFormularios = async () => {
            try {
                const data = await formularioService.getFormulariosByAdminId('67f451338df2d24afb2e45d2');
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