import axios from "axios";
import { EntityCampo } from "../types/entityes/EntityCampo";


export const CampoService = () => {

    async function getAllCampos(): Promise<EntityCampo[]> {
        const response = await axios.get("http://localhost:8080/campos");
        return response.data;
    }

    async function getCamposByFormId(formid: string): Promise<EntityCampo[]> {
        const response = await axios.get(`http://localhost:8080/campos/findByFormId/${formid}`);
        return response.data;
    }

    async function getCampoById(campoId: string): Promise<EntityCampo> {
        const response = await axios.get(`http://localhost:8080/campos/${campoId}`);
        return response.data;
    }

    async function alterarCampo(campoId: string, tipo: string, titulo: string): Promise<void> {
        const response = await axios.post(`http://localhost:8080/campos/alterar/${campoId}`, {tipo,titulo});
        return response.data;
    }

    async function deletarCampo(campoId: string): Promise<EntityCampo> {
        const response = await axios.delete(`http://localhost:8080/campos/remover/${campoId}`);
        return response.data;
    }

    async function adicionarCampo(formId: string, campo: EntityCampo): Promise<EntityCampo> {
        const response = await axios.post(`http://localhost:8080/campos/add/${formId}`, campo);
        return response.data;
    }



    return {
        getAllCampos,
        getCamposByFormId,
        getCampoById,
        alterarCampo,
        deletarCampo,
        adicionarCampo
    }
}