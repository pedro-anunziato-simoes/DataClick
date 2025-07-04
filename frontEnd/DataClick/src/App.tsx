import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import ListarFormsPage from "./pages/formularios/lista_formularios/ListarFormsPage";
import ListarCampoPage from "./pages/formularios/campo/ListarCamposByFormsPage";
import CriarCampoPage from "./pages/formularios/campo/CriarCampoPage";
import CampoByIdPage from "./pages/formularios/campo/CampoByIdPage";
import CadastrarRecrutadorPage from "./pages/recrutadores/CadastrarRecrutadoresPage";
import VisualizarRecrutadoresPage from "./pages/recrutadores/VisualizarRecrutadoresPage";
import EditarRecrutadorPage from "./pages/recrutadores/EditarRecrutadorPage";
import CriarFormsPage from "./pages/formularios/CriarFormsPage";
import EditarFormPage from "./pages/formularios/EditarFormsPage";
import PerfilAdminitradorPage from "./pages/administrador/PerfilAdminitradorPage";
import PrivateRoute from "./api/privateRoute";
import Home from "./pages/home/Home";
import SuportePage from "./pages/suporte/SuportePage";
import ListaEventosPage from "./pages/evento/ListaEventosPage";
import CriarEventoPage from "./pages/evento/CriarEventoPage";
import FormulariosPreenchidosPage from "./pages/formulariosPreechidos/FormulariosPreenchidosPage";
import RegistrarPage from "./pages/registrar/RegistrarPage";
import LoginPage from "./pages/login/loginPage";

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<LoginPage />} />
        <Route path="/home" element={<PrivateRoute><Home /></PrivateRoute>} />
        <Route path="/register" element={<RegistrarPage />} />
        <Route path="/recrutadores" element={<PrivateRoute><VisualizarRecrutadoresPage /></PrivateRoute>} />
        <Route path="/cadastrarRecrutadores" element={<PrivateRoute><CadastrarRecrutadorPage /></PrivateRoute>} />
        <Route path="/editarRecrutador/:id" element={<PrivateRoute><EditarRecrutadorPage /></PrivateRoute>} />
        <Route path="/formularios/:idEvento" element={<PrivateRoute><ListarFormsPage /></PrivateRoute>} />
        <Route path="/editarFormulario/:formId" element={<PrivateRoute>< EditarFormPage /></PrivateRoute>} />
        <Route path="/criarFormularios/:idEvento" element={<PrivateRoute><CriarFormsPage /></PrivateRoute>} />
        <Route path="/campos/:formId" element={<PrivateRoute><ListarCampoPage /></PrivateRoute>} />
        <Route path="/campos/add/:formId" element={<PrivateRoute><CriarCampoPage /></PrivateRoute>} />
        <Route path="/campo/find" element={<PrivateRoute><CampoByIdPage /></PrivateRoute>} />
        <Route path="/perfilAdministrador" element={<PrivateRoute><PerfilAdminitradorPage /></PrivateRoute>} />
        <Route path="/eventos" element={<PrivateRoute><ListaEventosPage /></PrivateRoute>} />
        <Route path="/criarEventos" element={<PrivateRoute><CriarEventoPage /></PrivateRoute>} />
        <Route path="/visualizarLeads/:eventoId" element={<PrivateRoute><FormulariosPreenchidosPage /></PrivateRoute>} />
        <Route path="/suporte" element={<PrivateRoute><SuportePage /></PrivateRoute>} />
      </Routes>
    </Router>
  );
};

export default App;
