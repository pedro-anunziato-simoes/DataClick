import { describe, it, expect, vi, beforeEach } from 'vitest'
import axios from 'axios'
import { EntityEvento } from '../../types/entityes/EntityEvento'
import { EventoCreateDTO } from '../../types/entityes/DTO/EventoCreateDTO'
import { EventoService } from '../../api/EventoService'

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

describe('EventoService', () => {
    const fakeEvento: EntityEvento = {
        eventoId: 'e1',
        eventoTitulo: 'Evento Teste',
        eventoData: new Date,
        eventoDescricao: 'teste descrição',
        adminid: '1',
        eventoFormularios: []
    }

    it('getEventos deve retornar a lista de eventos', async () => {
        mockedAxios.get.mockResolvedValueOnce({ data: [fakeEvento] })

        const service = EventoService()
        const result = await service.getEventos()

        expect(mockedAxios.get).toHaveBeenCalledWith(
            `${import.meta.env.VITE_API_URL}/eventos`,
            { headers: { Authorization: 'Bearer fake-token' } }
        )
        expect(result).toEqual([fakeEvento])
    })

    it('criarEvento deve enviar os dados e retornar o evento criado', async () => {
        const newEvento: EventoCreateDTO = {
            eventoTituloDto: 'teste titulo',
            eventoDescricaoDto: 'teste descrição',
            eventoDataDto: new Date
        }

        mockedAxios.post.mockResolvedValueOnce({ data: fakeEvento })

        const service = EventoService()
        const result = await service.criarEvento(newEvento)

        expect(mockedAxios.post).toHaveBeenCalledWith(
            `${import.meta.env.VITE_API_URL}/eventos/criar`,
            newEvento,
            { headers: { Authorization: 'Bearer fake-token' } }
        )
        expect(result).toEqual(fakeEvento)
    })

    it('excluirEvento deve chamar o endpoint com o ID do evento', async () => {
        mockedAxios.delete.mockResolvedValueOnce({ data: fakeEvento })

        const service = EventoService()
        const result = await service.excluirEvento('e1')

        expect(mockedAxios.delete).toHaveBeenCalledWith(
            `${import.meta.env.VITE_API_URL}/eventos/remove/e1`,
            { headers: { Authorization: 'Bearer fake-token' } }
        )
        expect(result).toEqual(fakeEvento)
    })
})
