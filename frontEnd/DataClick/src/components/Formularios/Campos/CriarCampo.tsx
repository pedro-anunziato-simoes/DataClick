import { useState } from "react";

const tipos = [
  "TEXTO",
  "NUMERO",
  "DATA",
  "CHECKBOX",
  "RADIO",
  "EMAIL",
];

const CriarCampo = (Campos: any) => {
  const [formData, setFormData] = useState(Campos);

  const handleTipoChange = (e: { target: { value: any; }; }) => {
    const tipoSelecionado = e.target.value;
    setFormData({
      ...formData,
      tipo: tipoSelecionado,
      resposta: {
        tipo: "",
      },
    });
  };

  const handleRespostaChange = (e: { target: { checked: any; value: any; }; }) => {
    const value =
      formData.tipo === "CHECKBOX" ? e.target.checked : e.target.value;

    setFormData({
      ...formData,
      resposta: {
        tipo: value,
      },
    });
  };

  const renderCampoResposta = () => {
    const tipo = formData.tipo;

    switch (tipo) {
      case "TEXTO":
        return (
          <input
            type="text"
            value={formData.resposta.tipo}
            onChange={handleRespostaChange}
          />
        );
      case "NUMERO":
        return (
          <input
            type="number"
            value={formData.resposta.tipo}
            onChange={handleRespostaChange}
          />
        );
      case "DATA":
        return (
          <input
            type="date"
            value={formData.resposta.tipo}
            onChange={handleRespostaChange}
          />
        );
      case "CHECKBOX":
        return (
          <label>
            <input
              type="checkbox"
              checked={formData.resposta.tipo === true}
              onChange={handleRespostaChange}
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
                checked={formData.resposta.tipo === "sim"}
                onChange={handleRespostaChange}
              />
              Sim
            </label>
            <label>
              <input
                type="radio"
                value="nao"
                checked={formData.resposta.tipo === "nao"}
                onChange={handleRespostaChange}
              />
              Não
            </label>
          </>
        );
      case "EMAIL":
        return (
          <input
            type="email"
            value={formData.resposta.tipo}
            onChange={handleRespostaChange}
          />
        );
      default:
        return null;
    }
  };

    return (
    <form>
      <div>
        <label>Título:</label>
        <input
          type="text"
          value={formData.titulo}
          onChange={(e) => setFormData({ ...formData, titulo: e.target.value })}
        />
      </div>

      <div>
        <label>Tipo:</label>
        <select value={formData.tipo} onChange={handleTipoChange}>
          <option value="">Selecione o tipo</option>
          {tipos.map((tipo) => (
            <option key={tipo} value={tipo}>
              {tipo}
            </option>
          ))}
        </select>
      </div>

      <div>
        <label>Resposta:</label>
        {renderCampoResposta()}
      </div>

      <button type="submit">Enviar</button>
    </form>
  );
};

export default CriarCampo;
