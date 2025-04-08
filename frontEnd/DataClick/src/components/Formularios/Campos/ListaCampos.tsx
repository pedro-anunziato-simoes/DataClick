import React, { useEffect, useState } from "react";
import { CampoService } from "../../../api/CampoService";
import { EntityCampo } from "../../../types/entityes/EntityCampo";



const ListarCampos = () => {
  useEffect(() => {
    const campoService = CampoService();
    const fetchCampo = async () => {
      try {
        const campos: EntityCampo[] = await campoService.getCamposByFormId('67f431364c35e374b6cb4c55');
        setCampos(campos); 
      } catch (error) {
        console.error("Erro ao buscar campos:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchCampo();
  }, []);
  const [campos, setCampos] = useState<EntityCampo[]>([]);
  const [loading, setLoading] = useState(true);
  const handleRespostaChange = (index: number, e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { value, type } = e.target;
  
    const resposta = type === 'checkbox' && e.target instanceof HTMLInputElement
      ? e.target.checked
      : value;
  
    const novosCampos = [...campos];
    novosCampos[index] = {
      ...novosCampos[index],
      resposta: {
        tipo: resposta
      }
    };
  
    setCampos(novosCampos);
  };

  const renderCampoResposta = (campo: EntityCampo, index: number) => {
    const tipo = campo.tipo;
  
    switch (tipo) {
      case "TEXTO":
      case "NUMERO":
      case "DATA":
      case "EMAIL":
        return (
          <input
            type={tipo === "NUMERO" ? "number" : tipo.toLowerCase()}
            value={typeof campo.resposta.tipo === 'boolean'
              ? campo.resposta.tipo ? 'true' : 'false'
              : campo.resposta.tipo}
            onChange={(e) => handleRespostaChange(index, e)}
          />
        );
      case "CHECKBOX":
        return (
          <label>
            <input
              type="checkbox"
              checked={campo.resposta?.tipo === true}
              onChange={(e) => handleRespostaChange(index, e)}
            />
            Marcar
          </label>
        );
      case "RADIO":
        return (
          <>
            <label>
              <input
                type="radio"
                value="sim"
                checked={campo.resposta.tipo === "sim"}
                onChange={(e) => handleRespostaChange(index, e)}
              />
              Sim
            </label>
            <label>
              <input
                type="radio"
                value="nao"
                checked={campo.resposta.tipo === "nao"}
                onChange={(e) => handleRespostaChange(index, e)}
              />
              Não
            </label>
          </>
        );
      default:
        return <p>Tipo de campo não suportado</p>;
    }
  };
// Aqui você tem certeza que `campo` não é mais null
if (loading) return <p>Carregando campos...</p>;
if (!campos.length) return <p>Nenhum campo encontrado</p>;

return (
  <form>
    {campos.map((campo, index) => (
      <div key={campo.campoId || index}>
        <h3>{campo.titulo}</h3>
        {renderCampoResposta(campo, index)}
        <br />
      </div>
    ))}
    <button type="submit">Enviar Respostas</button>
  </form>
);
};

export default ListarCampos;
