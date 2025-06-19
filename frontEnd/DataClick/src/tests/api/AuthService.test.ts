import { describe, it, expect, vi, beforeEach } from 'vitest';
import axios from 'axios';
import { AuthService, LoginRequest, RegisterRequest } from '../../api/AuthService';

// Mockando o axios
vi.mock('axios');
const mockedAxios = axios as unknown as { post: ReturnType<typeof vi.fn> };

beforeEach(() => {
  // Limpar localStorage antes de cada teste
  localStorage.clear();
  // Limpar mocks
  vi.clearAllMocks();
});

describe('AuthService', () => {
  it('faz login e armazena o token no localStorage', async () => {
    const mockToken = 'fake-token';
    mockedAxios.post.mockResolvedValueOnce({ data: { token: mockToken } });

    const loginData: LoginRequest = { email: 'teste@email.com', senha: '123' };
    await AuthService.login(loginData);

    expect(mockedAxios.post).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/auth/login`,
      loginData
    );
    expect(localStorage.getItem('token')).toBe(mockToken);
  });

  it('faz registro com os dados corretos', async () => {
    const registerData: RegisterRequest = {
      nome: 'Teste',
      email: 'teste@email.com',
      telefone: '11999999999',
      cnpj: '12345678000100',
      senha: 'senha123',
    };

    mockedAxios.post.mockResolvedValueOnce({}); // Supondo que o retorno seja vazio para o registro
    await AuthService.register(registerData);

    expect(mockedAxios.post).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/auth/register`,
      registerData
    );
  });

  it('getToken deve retornar o token correto', () => {
    localStorage.setItem('token', 'abc123');
    expect(AuthService.getToken()).toBe('abc123');
  });

  it('isAuthenticated deve retornar true se tiver token', () => {
    localStorage.setItem('token', 'xyz');
    expect(AuthService.isAuthenticated()).toBe(true);
  });

  it('isAuthenticated deve retornar false se não tiver token', () => {
    localStorage.removeItem('token');
    expect(AuthService.isAuthenticated()).toBe(false);
  });

  it('logout deve remover o token do localStorage', () => {
    localStorage.setItem('token', 'xyz');
    AuthService.logout();
    expect(localStorage.getItem('token')).toBeNull();
  });
});
