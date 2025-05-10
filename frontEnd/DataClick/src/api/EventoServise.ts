import axios from "axios";
import { EntityEvento } from "../types/entityes/EntityEvento";

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
    return {getEventos,}
}