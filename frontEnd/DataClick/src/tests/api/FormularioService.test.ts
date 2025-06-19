import { describe, it, expect, vi, beforeEach } from 'vitest'
import axios from 'axios'
import { EntityFormulario } from '../../types/entityes/EntityFormulario'
import { FormularioCreateDTO } from '../../types/entityes/DTO/FormualrioCreateDTO'
import { FormularioUpdateDTO } from '../../types/entityes/DTO/FormularioUpdateDTO'
import { FormularioService } from '../../api/FormularioService'

// Mock do axios
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

describe('FormularioService', () => {
  const fakeFormulario: EntityFormulario = {
      formularioTitulo: 'Formulário Teste',
      campos: [],
      formAdminId: '1'
  }

  it('getFormulariosEvento deve retornar os formulários de um evento', async () => {
    mockedAxios.get.mockResolvedValueOnce({ data: [fakeFormulario] })

    const service = FormularioService()
    const result = await service.getFormulariosEvento('e1')

    expect(mockedAxios.get).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/formularios/formulario/evento/e1`,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual([fakeFormulario])
  })

  it('getFormularioById deve retornar um formulário pelo ID', async () => {
    mockedAxios.get.mockResolvedValueOnce({ data: fakeFormulario })

    const service = FormularioService()
    const result = await service.getFormularioById('f1')

    expect(mockedAxios.get).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/formularios/f1`,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual(fakeFormulario)
  })

  it('criarForms deve enviar dados e retornar o formulário criado', async () => {
    const newForm: FormularioCreateDTO = {
        formularioTituloDto: 'teste titulo'
    }

    mockedAxios.post.mockResolvedValueOnce({ data: fakeFormulario })

    const service = FormularioService()
    const result = await service.criarForms(newForm, 'e1')

    expect(mockedAxios.post).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/formularios/add/e1`,
      newForm,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual(fakeFormulario)
  })

  it('alterarForms deve enviar os dados e retornar lista de formulários atualizados', async () => {
    const updateData: FormularioUpdateDTO = {
        titulo: 'teste titulo'
    }

    const updatedForms: EntityFormulario[] = [fakeFormulario]

    mockedAxios.post.mockResolvedValueOnce({ data: updatedForms })

    const service = FormularioService()
    const result = await service.alterarForms('f1', updateData)

    expect(mockedAxios.post).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/formularios/alterar/f1`,
      updateData,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual(updatedForms)
  })

  it('removerForms deve deletar o formulário e retornar lista atualizada', async () => {
    const updatedForms: EntityFormulario[] = []

    mockedAxios.delete.mockResolvedValueOnce({ data: updatedForms })

    const service = FormularioService()
    const result = await service.removerForms('f1')

    expect(mockedAxios.delete).toHaveBeenCalledWith(
      `${import.meta.env.VITE_API_URL}/formularios/remove/f1`,
      { headers: { Authorization: 'Bearer fake-token' } }
    )
    expect(result).toEqual(updatedForms)
  })
})
