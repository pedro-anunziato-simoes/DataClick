import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "./pages/Login";
import Home from "./pages/Home";
import Register from "./pages/Register";
import ListarFormsPage from "./pages/formularios/lista_formularios/ListarFormsPage";
import ListarCampoPage from "./pages/formularios/campo/ListarCamposByFormsPage";
import CriarCampoPage from "./pages/formularios/campo/CriarCampoPage";
import CampoByIdPage from "./pages/formularios/campo/CampoByIdPage";

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/home" element={<Home />} />
        <Route path="/register" element={<Register />} />
        <Route path="/formularios" element={<ListarFormsPage />} />
        <Route path="//campos/:formId" element={<ListarCampoPage />} />
        <Route path="/campos/add" element={<CriarCampoPage />} />
        <Route path="/campo/find" element={<CampoByIdPage />} />
      </Routes>
    </Router>
  );
};

export default App;
