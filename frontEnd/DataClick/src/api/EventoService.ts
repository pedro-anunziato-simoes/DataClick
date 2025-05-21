import axios from "axios";
import { EntityEvento } from "../types/entityes/EntityEvento";
import { EventoCreateDTO } from "../types/entityes/DTO/EventoCreateDTO";

const API_URL = import.meta.env.VITE_API_URL;

export const EventoService = () => {
    const token = localStorage.getItem("token");

    async function getEventos(): Promise<EntityEvento[]> {
        const response = await axios.get(`${API_URL}/eventos`, {
            headers: {
                Authorization: `Bearer ${token}`
            },
        });
        return response.data;
    }

    async function criarEvento(data: EventoCreateDTO): Promise<EntityEvento> {
        const response = await axios.post(`${API_URL}/eventos/criar`, data, {
            headers: {
                Authorization: `Bearer ${token}`
            },
        });
        return response.data;
    }

    async function excluirEvento(eventoId: string): Promise<EntityEvento> {
        const response = await axios.delete(`${API_URL}/eventos/remove/${eventoId}`,  {
            headers: {
                Authorization: `Bearer ${token}`
            },
        });
        return response.data;
    }


    return {getEventos,criarEvento,excluirEvento,}
}