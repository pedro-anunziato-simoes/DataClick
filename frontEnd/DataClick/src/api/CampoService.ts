import axios from "axios";
import { EntityCampo } from "../types/entityes/EntityCampo";

export const CampoService = () => {

    async function getAllCampos(): Promise<EntityCampo[]> {
        const response = await axios.get("http://localhost:8080/campos");
        return response.data;
    }

    async function getCamposByFormId(formid:string): Promise<EntityCampo[]> {
        const response = await axios.get(`http://localhost:8080/campos/findByFormId/${formid}`);
        return response.data;
    }

    async function getCampoById(campoId:string): Promise<EntityCampo[]> {
        const response = await axios.get(`http://localhost:8080/campos/${campoId}`);
        return response.data;
    }
    

    return{getAllCampos,getCamposByFormId,getCampoById}
}