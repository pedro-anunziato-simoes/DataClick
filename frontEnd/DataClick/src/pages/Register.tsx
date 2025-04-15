// src/pages/Register.tsx
import { useNavigate } from "react-router-dom";
import "./Register.css";
import Input from "../components/Input";
import Button from "../components/Button";

const Register = () => {
  const navigate = useNavigate();

  const handleRegister = () => {
    // Aqui você pode adicionar lógica para enviar os dados do usuário
    alert("Usuário registrado com sucesso!");
    navigate("/"); // Após registrar, volta para a tela de login
  };

  return (
    <div className="register-container">
      <h2>Crie sua conta</h2>
      <Input type="text" placeholder="Nome completo" />
      <Input type="email" placeholder="E-mail" />
      <Input type="password" placeholder="Senha" />
      <Input type="password" placeholder="Confirme a senha" />
      <Button onClick={handleRegister}>Registrar</Button>
    </div>
  );
};

export default Register;
