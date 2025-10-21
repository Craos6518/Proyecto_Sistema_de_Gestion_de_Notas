// index.js
import express from "express";
import rutaAutenticacion from "./rutas/ruta_autenticacion.js";

const app = express();

// Middleware para parsear JSON
app.use(express.json());

// Rutas
app.use("/api/autenticacion", rutaAutenticacion);

// Puerto del servidor
const PORT = process.env.PORT || 3000;

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
});
