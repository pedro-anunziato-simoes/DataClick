import AdministradorPerfil from "../../components/administradores/PerfilAdministrador";
import Footer from "../../components/footer/Footer";
import Sidebar from "../../components/sideBar/Sidebar";

const PerfilAdminitradorPage = () => {
  return (
    <div
      style={{
        display: "flex",
        background: "linear-gradient(to bottom, #b2dfdb, #4db6ac)",
        minHeight: "100vh"
      }}
    >
      <Sidebar />

      <div
        style={{
          display: "flex",
          flexDirection: "column",
          minHeight: "100vh",
          flexGrow: 1
        }}
      >
        <main
          style={{
            flexGrow: 1,
            display: "flex",
            flexDirection: "column",
            justifyContent: "center",
            alignItems: "center",
            padding: "2rem"
          }}
        >
          <h1 style={{ marginBottom: "1rem", color: "#004d40" }}>Seu perfil</h1>
          <AdministradorPerfil />
        </main>

        <Footer />
      </div>
    </div>
  );
};

export default PerfilAdminitradorPage;
