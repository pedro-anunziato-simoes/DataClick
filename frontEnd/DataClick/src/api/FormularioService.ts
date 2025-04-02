import axios from "axios";

export const FormularioService = () => {

    async function getFormularios() {
        const response = await axios.get("http://localhost:8080/formularios");
        return response.data;
    }

    

    return{getFormularios}
}