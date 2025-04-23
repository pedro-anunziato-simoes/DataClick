import axios from "axios";
import { EntityRecrutador } from "../types/entityes/EntityRecrutador";
import { RecrutadorCreateDTO } from "../types/entityes/DTO/RecrutadorCreateDTO";
import { RecrutadorUpdateDTO } from "../types/entityes/DTO/RecrutadorUpdateDTO";

const API_URL = import.meta.env.VITE_API_URL;

export const RecrutadorService = () => {

  const token = localStorage.getItem("token")
  const getRecrutadores = async (): Promise<EntityRecrutador[]> => {
    const response = await axios.get(`${API_URL}/recrutadores/list`, {
      headers: {
        Authorization: `Bearer ${token}`
      },

    });
    return await response.data;
  };

  const getRecrutadorById = async (recrutadorId: string): Promise<EntityRecrutador> => {
    const response = await axios.get(`${API_URL}/recrutadores/${recrutadorId}`, {
      headers: {
        Authorization: `Bearer ${token}`
      },
    });
    console.log(response.data)
    return response.data;
  }

  const alterarRecrutador = async (recrutadorId: string, recrutador: RecrutadorUpdateDTO): Promise<EntityRecrutador> => {
    const response = await axios.post(`${API_URL}/recrutadores/alterar/${recrutadorId}`, recrutador, {
      headers: {
        Authorization: `Bearer ${token}`
      },
    });

    return response.data;
  }

  const criarRecrutador = async (data: RecrutadorCreateDTO): Promise<EntityRecrutador> => {
    const response = await axios.post(`${API_URL}/recrutadores`, data, {
      headers: {
        Authorization: `Bearer ${token}`
      },
    });
    return response.data;
  }

  const excluirRecrutador = async (recrutadorId: string) => {
    const response = await axios.delete(`${API_URL}/recrutadores/remover/${recrutadorId}`, {
      headers: {
        Authorization: `Bearer ${token}`
      },
    });
    return response.data;
  }

  return {
    getRecrutadores, criarRecrutador, getRecrutadorById, alterarRecrutador, excluirRecrutador
  };
};
