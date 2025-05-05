import axios from "axios";
import { EntityAdministrador } from "../types/entityes/EntityAdministrador";

const API_URL = import.meta.env.VITE_API_URL;

export const AdministradorService = () => {
    const token = localStorage.getItem('token')
   async function getInfosAdminitrador(): Promise<EntityAdministrador> {
           const response = await axios.get(`${API_URL}/administradores/info`,{
               headers: {
                   Authorization: `Bearer ${token}`
               },
           });
           localStorage.setItem('adminId',response.data.usuarioId)
           localStorage.setItem('nomeAdmin',response.data.nome)
           localStorage.setItem('telefoneAdmin',response.data.telefone)
           localStorage.setItem('emailAdmin',response.data.email)
           localStorage.setItem('cnpj',response.data.cnpj)
           localStorage.setItem('formularios',response.data.formularios)
           localStorage.setItem('recrutadores',response.data.recrtuadores)
           return response.data;
       }
       return{getInfosAdminitrador}
}