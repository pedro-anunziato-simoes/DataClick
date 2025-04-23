import axios from "axios";
import { EntityFormulario } from "../types/entityes/EntityFormulario";


const API_URL = ""

export const FormularioService = () => {

    async function getFormulariosByAdminId(): Promise<EntityFormulario[]> {
        const token = localStorage.getItem("token")
        const response = await axios.get(`${API_URL}/formularios/findByAdmin`, {
            headers: {
                Authorization: `Bearer ${token}`
            },
            
        });
        return response.data;
    }

    return { getFormulariosByAdminId }
}