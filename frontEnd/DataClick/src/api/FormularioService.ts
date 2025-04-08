import axios from "axios";
import { EntityFormulario } from "../types/entityes/EntityFormulario";

export const FormularioService = () => {

    async function getAllFormularios(): Promise<EntityFormulario[]> {
        const response = await axios.get("http://localhost:8080/formularios");
        return response.data;
    }
    
    async function getFormulariosByAdminId(id:string): Promise<EntityFormulario[]> {
        const response = await axios.get(`http://localhost:8080/formularios/findByAdmin/${id}`);
        return response.data;
    }

    return{getAllFormularios,getFormulariosByAdminId}
}