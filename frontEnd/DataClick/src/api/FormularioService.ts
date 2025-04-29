import axios from "axios";
import { EntityFormulario } from "../types/entityes/EntityFormulario";
import { FormularioUpdateDTO } from "../types/entityes/DTO/FormularioUpdateDTO";
const API_URL = import.meta.env.VITE_API_URL;

export const FormularioService = () => {
    const token = localStorage.getItem("token")

    async function getFormularios(): Promise<EntityFormulario[]> {
        const response = await axios.get(`${API_URL}/formularios/todos-formularios`, {
            headers: {
                Authorization: `Bearer ${token}`
            },

        });
        return response.data;
    }

    async function getFormularioById(id: string): Promise<EntityFormulario> {
        const response = await axios.get(`${API_URL}/formularios/${id}`, {
            headers: {
                Authorization: `Bearer ${token}`
            },
        });
        return response.data;
    }

    async function criarForms(data: EntityFormulario): Promise<EntityFormulario[]> {
        const response = await axios.post(`${API_URL}/formularios/add`, data, {
            headers: {
                Authorization: `Bearer ${token}`
            },

        });
        return response.data;
    }

    async function alterarForms(formId: string, data: FormularioUpdateDTO): Promise<EntityFormulario[]> {
        const response = await axios.post(`${API_URL}/formularios/alterar/${formId}`, data, {
            headers: {
                Authorization: `Bearer ${token}`
            },

        });
        return response.data;
    }

    async function removerForms(id: string): Promise<EntityFormulario[]> {
        const response = await axios.delete(`${API_URL}/formularios/remove/${id}`, {
            headers: {
                Authorization: `Bearer ${token}`
            },

        });
        return response.data;
    }

    return { getFormularios, criarForms, removerForms, getFormularioById, alterarForms, }
}