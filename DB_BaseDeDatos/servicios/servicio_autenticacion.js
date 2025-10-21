// servicios/servicio_autenticacion.js
import { mainDB, logsDB } from "../db/conexion.js";

class ServicioAutenticacion {
  async login(email, password, ipAddress, userAgent) {
    const query = "SELECT id_usuario, email, contraseña FROM usuario WHERE email = $1";
    const { rows } = await mainDB.query(query, [email]);
    const usuario = rows[0];

    if (!usuario) {
      await this.registrarIntento(email, null, "fallido", "usuario_no_existe", ipAddress, userAgent);
      return { success: false, message: "Usuario no encontrado" };
    }

    if (password !== usuario.contraseña) {
      await this.registrarIntento(email, usuario.id_usuario, "fallido", "contraseña_incorrecta", ipAddress, userAgent);
      return { success: false, message: "Contraseña incorrecta" };
    }

    await this.registrarIntento(email, usuario.id_usuario, "exitoso", null, ipAddress, userAgent);
    return { success: true, message: "Inicio de sesión exitoso" };
  }

  async registrarIntento(email, idUsuario, tipo, razon, ip, userAgent) {
    const sql = "CALL sp_registrar_intento_login($1, $2, $3, $4, $5, $6)";
    await logsDB.query(sql, [email, idUsuario, tipo, razon, ip, userAgent]);
  }
}

export default new ServicioAutenticacion();
