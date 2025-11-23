// mock-server.js
const express = require('express');
const app = express();

app.get('/get-user/:id', (req, res) => {
  res.json({ id: req.params.id, name: 'Usuario de prueba' });
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Mock API listening on http://localhost:${port}`));