import React from "react";
import { CardContent, Fab, Tooltip } from "@mui/material";
import WhatsAppIcon from "@mui/icons-material/WhatsApp";

const WHATSAPP_NUMBER = "5511999998888";
const WHATSAPP_MESSAGE = "Olá, preciso de ajuda com o dataClick";

const Suporte: React.FC = () => {
  const link = `https://api.whatsapp.com/send?phone=${WHATSAPP_NUMBER}&text=${encodeURIComponent(WHATSAPP_MESSAGE)}`;

  return (
    <Tooltip title="Falar com o suporte" placement="left">
      <CardContent
        sx={{
          position: "fixed",
          bottom: 80, //
          right: 16,
          zIndex: 1000,
        }}
      >
        <Fab
          color="success"
          href={link}
          target="_blank"
          rel="noopener noreferrer"
        >
          <WhatsAppIcon />
        </Fab>
      </CardContent>
    </Tooltip>
  );
};

export default Suporte;
