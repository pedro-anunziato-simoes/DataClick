import axios from "axios";
import { EntityFormulario } from "../types/entityes/EntityFormulario";
const API_URL = "https://dataclick-backend-api.onrender.com";

export const FormularioService = () => {

    async function getFormulariosByAdminId(id: string): Promise<EntityFormulario[]> {
        const token = localStorage.getItem("token")
        const response = await axios.get(`${API_URL}/formularios/findByAdmin/${id}`, {
            headers: {
                Authorization: `Bearer ${token}`
            },
            
        });
        return response.data;
    }

    return { getFormulariosByAdminId }
}