import { describe, it, expect, vi, beforeEach } from 'vitest'
import axios from 'axios'
import { EntityFormulariosPreenchidos } from '../../types/entityes/EntityFormulariosPreenchidos'
import { FormulariosPreenchidosService } from '../../api/FormulariosPreenchidosService'

vi.mock('axios')
const mockedAxios = axios as unknown as {
  get: ReturnType<typeof vi.fn>
}

beforeEach(() => {
  localStorage.clear()
  vi.clearAllMocks()
  localStorage.setItem('token', 'fake-token')
})

describe('FormulariosPreenchidosService', () => {
  const fakePreenchido: EntityFormulariosPreenchidos = {
      formularioPreenchidoEventoId: '',
      formularioPreenchidoListaFormularios: []
  }

  it('getFormulariosPreenchidos deve retornar os formulários preenchidos do evento', async () => {
    mockedAxios.get.mockResolvedValueOnce({ data: [fakePreenchido] })

    const service = FormulariosPreenchidosService()
    const result = await service.getFormulariosPreenchidos('e1')

    expect(mockedAxios.get).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/formualriosPreenchidos/e1`,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual([fakePreenchido])
  })
})
