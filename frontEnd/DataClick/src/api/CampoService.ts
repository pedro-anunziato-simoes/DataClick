import axios from "axios";
import { EntityCampo } from "../types/entityes/EntityCampo";
import { CampoCreateDTO } from "../types/entityes/DTO/CampoCreateDTO";
const API_URL = import.meta.env.VITE_API_URL;

export const CampoService = () => {
    const token = localStorage.getItem("token");
    
    async function getCamposByFormId(formid: string): Promise<EntityCampo[]> {
        const response = await axios.get(`${API_URL}/campos/findByFormId/${formid}`,{
            headers: {
                Authorization: `Bearer ${token}`
            },
        });
        return response.data;
    }
    async function getCampoById(campoId: string): Promise<EntityCampo> {
        const response = await axios.get(`${API_URL}/campos/${campoId}`,{
            headers: {
                Authorization: `Bearer ${token}`
            },
        });
        return response.data;
    }

    async function alterarCampo(campoId: string, tipo: string, titulo: string): Promise<void> {
        const response = await axios.post(`${API_URL}/campos/alterar/${campoId}`, { tipo, titulo },{
            headers: {
                Authorization: `Bearer ${token}`
            },
        });
        return response.data;
    }

    async function deletarCampo(campoId: string): Promise<EntityCampo> {
        const response = await axios.delete(`${API_URL}/campos/remover/${campoId}`,{
            headers: {
                Authorization: `Bearer ${token}`
            },
        });
        return response.data;
    }

    async function adicionarCampo(formId: string, campo: CampoCreateDTO): Promise<EntityCampo> {
        const response = await axios.post(`${API_URL}/campos/add/${formId}`, campo,{
            headers: {
                Authorization: `Bearer ${token}`
            },
            
        });
        return response.data;
    }


    return {
        getCamposByFormId,
        getCampoById,
        alterarCampo,
        deletarCampo,
        adicionarCampo
    }
}