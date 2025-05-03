import AdministradorPerfil from "../../components/administradores/PerfilAdministrador";
import Sidebar from "../../components/sideBar/Sidebar";


const PerfilAdminitradorPage = () => {
  return (
    <div>
      <Sidebar />
      <div>
        <h1>Seu perfil</h1>
        <AdministradorPerfil/>
      </div>
    </div>
  );
};

export default PerfilAdminitradorPage;
