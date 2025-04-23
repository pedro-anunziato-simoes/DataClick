import axios from "axios";
const API_URL = import.meta.env.VITE_API_URL;

export interface RegisterRequest {
    nome: string;
    email: string;
    telefone: string;
    cnpj: string;
    senha: string;
}

export interface LoginRequest {
    email: string;
    senha: string;
}

export interface LoginResponse {
    token: string;
}

export const AuthService = {
    login: async (data: LoginRequest): Promise<void> => {
        const response = await axios.post<LoginResponse>(`${API_URL}/auth/login`, data);
        const token = response.data.token;
        localStorage.setItem("token", token);
    },

    register: async (data: RegisterRequest): Promise<void> => {
        await axios.post(`${API_URL}/auth/register`, data);
      },


    getToken: (): string | null => {
        return localStorage.getItem("token");
    },
    isAuthenticated: () => !!localStorage.getItem("token"),

    logout: () => {
        localStorage.removeItem("token");
    },


};