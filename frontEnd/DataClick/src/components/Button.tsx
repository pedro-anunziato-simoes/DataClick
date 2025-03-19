import React from "react";

interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => void; // Adicionando onClick como opcional
}

const Button: React.FC<ButtonProps> = ({ children, onClick }) => {
  return (
    <button onClick={onClick} className="button">
      {children}
    </button>
  );
};

export default Button;
