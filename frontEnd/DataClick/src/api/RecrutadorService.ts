import axios from "axios";
import { EntityRecrutador } from "../types/entityes/EntityRecrutador";

const API_URL = ""

export const RecrutadorService = () => {
  const token = localStorage.getItem("token")
  const getRecrutadorById = async (recrutadorId: string): Promise<EntityRecrutador> => {
      const response = await axios.get(`/${API_URL}/recrutadores/${recrutadorId}`, {
        headers: {
            Authorization: `Bearer ${token}`
        },
        
    });
      return await response.data;
    };

  const getRecrutadoresByAdmin = async (): Promise<EntityRecrutador[]> => {
    const response = await axios.get(`${API_URL}/recrutadores/list`, {
      headers: {
          Authorization: `Bearer ${token}`
      },
      
  });
    return response.data;
  };

  const criarRecrutador = async (data:EntityRecrutador): Promise<EntityRecrutador> =>{ 
    const response = await axios.post(`${API_URL}/recrutadores`, data,{
      headers: {
          Authorization: `Bearer ${token}`
      },
  });
    return response.data;
  }

  return {
    getRecrutadorById, getRecrutadoresByAdmin,criarRecrutador,
  };
};
