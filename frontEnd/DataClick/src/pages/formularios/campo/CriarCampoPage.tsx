import Footer from "../../../components/footer/Footer";
import CriarCampo from "../../../components/Formularios/Campos/CriarCampo";
import Sidebar from "../../../components/sideBar/Sidebar";

const CriarCampoPage = () => {  
    return (
      <div>
        <h1>Criando campos</h1>
        <CriarCampo />
        <Sidebar />
        <Footer />
      </div>
    );
  };

export default CriarCampoPage;