import { mainDB } from "../db/conexion.js";

class ServicioAutenticacion {
  async login(email, contrasena, ip = null, userAgent = null) {
    const query = "SELECT id_usuario, email, contrasena FROM usuario WHERE email = $1";
    const { rows } = await mainDB.query(query, [email]);
    const usuario = rows[0];

    if (!usuario) {
      await this.registrarIntento(email, null, "fallido", "usuario_no_existe", ip, userAgent);
      return { success: false, message: "Usuario no encontrado" };
    }

    if (contrasena !== usuario.contrasena) {
      await this.registrarIntento(email, usuario.id_usuario, "fallido", "contrasena_incorrecta", ip, userAgent);
      return { success: false, message: "Contraseña incorrecta" };
    }

    await this.registrarIntento(email, usuario.id_usuario, "exitoso", null, ip, userAgent);
    return { success: true, message: "Inicio de sesión exitoso" };
  }

  async registrarIntento(email, idUsuario, tipo, razon, ip, userAgent) {
    const sql = "SELECT sp_registrar_intento_login($1, $2, $3, $4, $5, $6)";
    await mainDB.query(sql, [email, idUsuario, tipo, razon, ip, userAgent]);
  }
}

export default new ServicioAutenticacion();
