# 📋 DataClick - Formulário Offline

DataClick é uma aplicação voltada para a coleta de informações offline por meio de formulários customizáveis. Recrutadores podem utilizar o aplicativo móvel para capturar dados em eventos, mesmo sem conexão com a internet. Posteriormente, os dados são sincronizados com a nuvem para análise e visualização por parte dos administradores.

---

## 🚀 Visão Geral

- 🎯 **Objetivo**: Facilitar a coleta de leads em eventos de forma offline, com sincronização posterior dos dados.
- 📱 **Público-alvo**: Recrutadores de campo e administradores de operações.

---

## 🧩 Funcionalidades

### 👤 Administrador
- Gerenciar recrutadores (adicionar/remover).
- Criar, editar e excluir formulários e eventos personalizados.
- Visualizar quantidade de leads capturados:
  - Por evento

### 🧑‍💼 Recrutador
- Baixar formulários previamente definidos.
- Preencher formulários de forma offline durante os eventos.
- Subir os dados preenchidos para a nuvem assim que houver conexão com a internet.

---

## 🛠️ Tecnologias Utilizadas

### Backend
- **Spring Boot** (Java)
- Banco de Dados: **MongoDB Atlas**

### Frontend (Admin Web)
- **React**

### Mobile (App Recrutador)
- **Flutter**

---

## 📦 Estrutura dos Formulários

Os formulários são compostos por campos dinâmicos, com diferentes tipos suportados:

- Texto
- Número
- Data
- Múltipla escolha (checkbox/radio/select)
- E-mail
- Telefone

As respostas são armazenadas em uma estrutura flexível no MongoDB, permitindo a personalização total dos formulários pelo administrador.

---

## 🌐 Fluxo de Funcionamento

1. **Administrador** cria e gerencia os formulários via sistema web.
2. **Recrutador** baixa os formulários pelo app e os preenche offline.
3. Quando houver conexão com a internet:
   - Os dados preenchidos são sincronizados com a nuvem.
4. **Administrador** pode visualizar relatórios e métricas via dashboard web.

---

## 📈 Futuras Melhorias

- Autenticação com múltiplos níveis de acesso.
- Exportação de dados em formatos CSV/Excel.
- Dashboards com gráficos e KPIs.
- Histórico de sincronizações por dispositivo.

---

## 🧑‍💻 Equipe de Desenvolvimento

- Backend: Java & Spring Boot (Pedro Henrique, João Paulo)
- Frontend: React (Caian, Rafael)
- Mobile: Flutter (João Vitor, Murilo)

---

## 📄 Licença

Este projeto é privado e de uso exclusivo da 4Click. Todos os direitos reservados.

---
