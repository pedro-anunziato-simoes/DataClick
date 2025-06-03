import Footer from "../../../components/footer/Footer";
import AlterarCamposForms from "../../../components/Formularios/Campos/AlterarCampos";
import CriarCampo from "../../../components/Formularios/Campos/CriarCampo";
import Sidebar from "../../../components/sideBar/Sidebar";

const ListarCampoPage = () => {  
    return (
      <div>
        <h1>Listando campos do formularios</h1>
        <AlterarCamposForms />
        <CriarCampo/>
        <Sidebar />
        <Footer />
      </div>
    );
  };

export default ListarCampoPage;