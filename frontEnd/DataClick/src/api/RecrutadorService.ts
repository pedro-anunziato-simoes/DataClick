import axios from "axios";
import { EntityRecrutador } from "../types/entityes/EntityRecrutador";

const API_URL_PROD = "https://dataclick-backend-api.onrender.com";
const API_URL_DEV = "https://dataclick-backend-api-dev.onrender.com"

export const RecrutadorService = () => {
  const token = localStorage.getItem("token")
  const getRecrutadorById = async (recrutadorId: string): Promise<EntityRecrutador> => {
      const response = await axios.get(`/${API_URL_DEV}/recrutadores/${recrutadorId}`, {
        headers: {
            Authorization: `Bearer ${token}`
        },
        
    });
      return await response.data;
    };

  const getRecrutadoresByAdmin = async (adminitradorId: string): Promise<EntityRecrutador[]> => {
    const response = await axios.get(`${API_URL_DEV}/recrutadores/${adminitradorId}/list`, {
      headers: {
          Authorization: `Bearer ${token}`
      },
      
  });
    return response.data;
  };

  const criarRecrutador = async (data:EntityRecrutador): Promise<EntityRecrutador> =>{ 
    const response = await axios.post(`${API_URL_DEV}/recrutadores`, data,{
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
