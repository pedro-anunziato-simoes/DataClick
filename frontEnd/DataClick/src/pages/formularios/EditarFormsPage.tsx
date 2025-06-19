import Footer from "../../components/footer/Footer";
import EditarFormulario from "../../components/Formularios/EditarFormulario";
import Sidebar from "../../components/sideBar/Sidebar";

const EditarFormPage = () => {  
    return (
      <div>
        <h1>Editando formulário</h1>
        < EditarFormulario/>
        <Footer />
        <Sidebar />
      </div>
    );
  };

export default EditarFormPage;