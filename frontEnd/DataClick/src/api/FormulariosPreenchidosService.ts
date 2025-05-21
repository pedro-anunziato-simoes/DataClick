import axios from "axios";
import { EntityFormulariosPreenchidos } from "../types/entityes/EntityFormulariosPreenchidos";

const API_URL = import.meta.env.VITE_API_URL;

export const FormulariosPreenchidosService = () => {
    const token = localStorage.getItem("token");

    async function getFormulariosPreenchidos(eventoId:string): Promise<EntityFormulariosPreenchidos[]> {
        const response = await axios.get(`${API_URL}/formualriosPreenchidos/${eventoId}`, {
            headers: {
                Authorization: `Bearer ${token}`
            },
        });
        return response.data;
    }

    return {getFormulariosPreenchidos,}
}