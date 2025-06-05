import { describe, it, expect, vi, beforeEach } from 'vitest'
import axios from 'axios'
import { EntityCampo } from '../../types/entityes/EntityCampo'
import { CampoCreateDTO } from '../../types/entityes/DTO/CampoCreateDTO'
import { CampoService } from '../../api/CampoService'

vi.mock('axios')
const mockedAxios = axios as unknown as {
  get: ReturnType<typeof vi.fn>
  post: ReturnType<typeof vi.fn>
  delete: ReturnType<typeof vi.fn>
}

beforeEach(() => {
  localStorage.clear()
  vi.clearAllMocks()
  localStorage.setItem('token', 'fake-token')
})

describe('CampoService', () => {
  const fakeCampo: EntityCampo = {
    campoId: '1',
    campoTitulo: 'Nome',
    campoTipo: 'texto',
    resposta: {
    tipo: 'string'
  }
  }

  it('getCamposByFormId deve retornar uma lista de campos', async () => {
    mockedAxios.get.mockResolvedValueOnce({ data: [fakeCampo] })

    const service = CampoService()
    const result = await service.getCamposByFormId('form123')

    expect(mockedAxios.get).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/campos/findByFormId/form123`,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual([fakeCampo])
  })

  it('getCampoById deve retornar um campo', async () => {
    mockedAxios.get.mockResolvedValueOnce({ data: fakeCampo })

    const service = CampoService()
    const result = await service.getCampoById('1')

    expect(mockedAxios.get).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/campos/1`,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual(fakeCampo)
  })

  it('alterarCampo deve enviar tipo e título via POST', async () => {
    mockedAxios.post.mockResolvedValueOnce({ data: {} })

    const service = CampoService()
    await service.alterarCampo('1', 'email', 'Novo Título')

    expect(mockedAxios.post).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/campos/alterar/1`,
      { tipo: 'email', titulo: 'Novo Título' },
      { headers: { Authorization: 'Bearer fake-token' } }
    )
  })

  it('deletarCampo deve chamar o endpoint de deleção', async () => {
    mockedAxios.delete.mockResolvedValueOnce({ data: fakeCampo })

    const service = CampoService()
    const result = await service.deletarCampo('1')

    expect(mockedAxios.delete).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/campos/remover/1`,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual(fakeCampo)
  })

  it('adicionarCampo deve enviar os dados corretamente', async () => {
    const newCampo: CampoCreateDTO = {
      campoTituloDto: 'Idade',
      campoTipoDto: 'número',
      resposta: Object
    }

    mockedAxios.post.mockResolvedValueOnce({ data: fakeCampo })

    const service = CampoService()
    const result = await service.adicionarCampo('form123', newCampo)

    expect(mockedAxios.post).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/campos/add/form123`,
      newCampo,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual(fakeCampo)
  })
})
