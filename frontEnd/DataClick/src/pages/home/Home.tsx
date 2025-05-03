import Sidebar from "../../components/Sidebar";


const Home = () => {
  return (
    <div className="home-container">
      <Sidebar />
      <div className="content">
        <h1>Bem-vindo à Home</h1>
        <p>Escolha uma opção no menu lateral.</p>
      </div>
    </div>
  );
};

export default Home;
