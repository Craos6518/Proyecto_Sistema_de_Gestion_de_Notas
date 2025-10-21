import express from "express";
import authService from "../servicios/servicio_autenticacion.js";

const router = express.Router();

router.post("/login", async (req, res) => {
  const { email, contrasena } = req.body;

  try {
    const result = await authService.login(email, contrasena);
    res.json(result);
  } catch (error) {
    console.error("Error en login:", error);
    res.status(500).json({ success: false, message: "Error interno del servidor" });
  }
});

export default router;
