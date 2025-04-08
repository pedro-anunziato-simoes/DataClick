import { useEffect, useState } from "react";
import { FormularioService } from "../../api/FormularioService";
import Campo from "./Campos/Campo";


const Formularios = () => {
    const [formularios, setFormularios] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

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

    const handleCampoChange = (formIndex: number, campoIndex: number, valor: any) => {
        const novosFormularios = [...formularios];
        novosFormularios[formIndex].campos[campoIndex].resposta.tipo = valor;
        setFormularios(novosFormularios);
    };

    if (loading) return <p>Carregando formulários...</p>;

    return (
        <div>
            {formularios.map((formulario, formIndex) => (
                <form key={formulario.id}>
                    <h2>{formulario.titulo}</h2>
                    {formulario.campos.map((campo: any, campoIndex: number) => (
                        <div key={campo.campoId}>
                            {campo.tipo !== "CHECKBOX" && <p>{campo.titulo}</p>}
                            <Campo
                            />
                        </div>
                    ))}
                    <br />
                    <button type="submit">Enviar</button>
                    <hr />
                </form>
            ))}
        </div>
    );
};

export default Formularios;