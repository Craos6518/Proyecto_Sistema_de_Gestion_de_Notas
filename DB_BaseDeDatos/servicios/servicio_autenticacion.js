// servicios/servicio_autenticacion.js
import { mainDB } from "../db/conexion.js";

class ServicioAutenticacion {
  // Método para iniciar sesión
  async login(email, password) {
    // Consulta al usuario por email
    const query = "SELECT id_usuario, email, contrasena FROM usuario WHERE email = $1";
    const { rows } = await mainDB.query(query, [email]);
    const usuario = rows[0];

    // Verificar si existe el usuario
    if (!usuario) {
      return { success: false, message: "Usuario no encontrado" };
    }

    // Verificar contraseña
    if (password !== usuario.contrasena) {
      return { success: false, message: "Contraseña incorrecta" };
    }

    // Login exitoso
    return { success: true, message: "Inicio de sesión exitoso" };
  }
}

// Exportar una instancia de la clase
export default new ServicioAutenticacion();
