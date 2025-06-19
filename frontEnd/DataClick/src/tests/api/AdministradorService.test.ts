import { describe, it, expect, vi, beforeEach } from 'vitest'
import axios from 'axios'
import { AdministradorService } from '../../api/AdminitradorService'

vi.mock('axios')
const mockedAxios = axios as unknown as {
  get: ReturnType<typeof vi.fn>
}


beforeEach(() => {
  localStorage.clear()
})

describe('AdministradorService', () => {
  it('faz requisição para obter dados do administrador e armazena no localStorage', async () => {

    const fakeData = {
      usuarioId: '123',
      nome: 'Matheus',
      telefone: '11999999999',
      email: 'matheus@example.com',
      cnpj: '12345678900012',
      formularios: 'form1',
      recrtuadores: 'rec1'
    }
    mockedAxios.get.mockResolvedValueOnce({ data: fakeData })

    localStorage.setItem('token', 'fake-token')

    const service = AdministradorService()
    const result = await service.getInfosAdminitrador()


    expect(mockedAxios.get).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/administradores/info`,
      {
        headers: {
          Authorization: 'Bearer fake-token'
        }
      }
    )
    expect(localStorage.getItem('adminId')).toBe('123')
    expect(result.nome).toBe('Matheus')
  })
})
