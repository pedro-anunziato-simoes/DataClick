import { JSX } from "react";
import { Navigate } from "react-router-dom";
import { AuthService } from "./AuthService";

const PrivateRoute = ({ children }: { children: JSX.Element }) => {
    return AuthService.isAuthenticated() ? children : <Navigate to="/" replace />;
  };

export default PrivateRoute;
