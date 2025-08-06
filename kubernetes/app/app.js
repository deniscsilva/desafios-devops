const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  const name = process.env.NAME || 'candidato';
  res.send(`Olá ${name}!`);
});

// Endpoint para healthcheck
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.listen(port, () => {
  console.log(`Aplicação teste executando em http://localhost:${port}`);
});
