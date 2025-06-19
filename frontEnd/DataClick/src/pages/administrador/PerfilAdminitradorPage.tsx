import AdministradorPerfil from "../../components/administradores/PerfilAdministrador";
import Footer from "../../components/footer/Footer";
import Sidebar from "../../components/sideBar/Sidebar";


const PerfilAdminitradorPage = () => {
  return (
    <div>
      <Sidebar />
      <div>
        <h1>Seu perfil</h1>
        <AdministradorPerfil/>
        <Footer />
      </div>
    </div>
  );
};

export default PerfilAdminitradorPage;
