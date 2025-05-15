import CriarEvento from "../../components/eventos/CrirarEvento";
import Sidebar from "../../components/sideBar/Sidebar";


const ListaEventosPage = () => {
  return (
    <div>
      <Sidebar />
      <div>
        <CriarEvento />
      </div>
    </div>
  );
};

export default ListaEventosPage;
