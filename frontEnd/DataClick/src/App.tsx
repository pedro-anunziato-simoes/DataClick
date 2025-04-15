import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "./pages/Login";
import Home from "./pages/Home";
import Register from "./pages/Register";
import ListarFormsPage from "./pages/formularios/lista_formularios/ListarFormsPage";
import ListarCampoPage from "./pages/formularios/campo/ListarCamposByFormsPage";
import CriarCampoPage from "./pages/formularios/campo/CriarCampoPage";
import CampoByIdPage from "./pages/formularios/campo/CampoByIdPage";
import PrivateRoute from "./api/privateRoute";

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/home" element={<PrivateRoute><Home /></PrivateRoute>} />
        <Route path="/register" element={<Register />} />
        <Route path="/formularios" element={<PrivateRoute><ListarFormsPage /></PrivateRoute>} />
        <Route path="/campos/:formId" element={<PrivateRoute><ListarCampoPage /></PrivateRoute>} />
        <Route path="/campos/add/:formId" element={<PrivateRoute><CriarCampoPage /></PrivateRoute>} />
        <Route path="/campo/find" element={<PrivateRoute><CampoByIdPage /></PrivateRoute>} />
      </Routes>
    </Router>
  );
};

export default App;
