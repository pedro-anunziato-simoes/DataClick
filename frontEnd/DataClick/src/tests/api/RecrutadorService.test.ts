import { describe, it, expect, vi, beforeEach } from 'vitest'
import axios from 'axios'
import { EntityRecrutador } from '../../types/entityes/EntityRecrutador'
import { RecrutadorCreateDTO } from '../../types/entityes/DTO/RecrutadorDTO'
import { RecrutadorUpdateDTO } from '../../types/entityes/DTO/RecrutadorUpdateDTO'
import { RecrutadorService } from '../../api/RecrutadorService'

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

describe('RecrutadorService', () => {
  const fakeRecrutador: EntityRecrutador = {
      usuarioId: '1',
      adminId: '2',
      nome: 'teste nome',
      telefone: '449999999',
      email: 'teste@gmail.com',
      senha: 'testeSenha',
      formularios: []
  }

  it('getRecrutadores deve retornar a lista de recrutadores', async () => {
    mockedAxios.get.mockResolvedValueOnce({ data: [fakeRecrutador] })

    const service = RecrutadorService()
    const result = await service.getRecrutadores()

    expect(mockedAxios.get).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/recrutadores/list`,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual([fakeRecrutador])
  })

  it('getRecrutadorById deve retornar um recrutador específico', async () => {
    mockedAxios.get.mockResolvedValueOnce({ data: fakeRecrutador })

    const service = RecrutadorService()
    const result = await service.getRecrutadorById('r1')

    expect(mockedAxios.get).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/recrutadores/r1`,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual(fakeRecrutador)
  })

  it('criarRecrutador deve enviar os dados e retornar o recrutador criado', async () => {
    const newRecrutador: RecrutadorCreateDTO = {
        nome: 'Novo Recrutador',
        email: 'novo@empresa.com',
        telefone: '11912345678',
        senha: 'teste senha'
    }

    mockedAxios.post.mockResolvedValueOnce({ data: fakeRecrutador })

    const service = RecrutadorService()
    const result = await service.criarRecrutador(newRecrutador)

    expect(mockedAxios.post).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/recrutadores`,
      newRecrutador,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual(fakeRecrutador)
  })

  it('alterarRecrutador deve enviar os dados atualizados e retornar o recrutador', async () => {
    const updatedRecrutador: RecrutadorUpdateDTO = {
      nome: 'João Atualizado',
      email: 'joao@atualizado.com',
      telefone: '11911112222'
    }

    mockedAxios.post.mockResolvedValueOnce({ data: fakeRecrutador })

    const service = RecrutadorService()
    const result = await service.alterarRecrutador('r1', updatedRecrutador)

    expect(mockedAxios.post).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/recrutadores/alterar/r1`,
      updatedRecrutador,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual(fakeRecrutador)
  })

  it('excluirRecrutador deve chamar a rota de exclusão e retornar a resposta', async () => {
    mockedAxios.delete.mockResolvedValueOnce({ data: { success: true } })

    const service = RecrutadorService()
    const result = await service.excluirRecrutador('r1')

    expect(mockedAxios.delete).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/recrutadores/remover/r1`,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual({ success: true })
  })
})
