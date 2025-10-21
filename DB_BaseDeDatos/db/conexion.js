// db/conexion.js
import pkg from "pg";
const { Pool } = pkg;

export const mainDB = new Pool({
  user: "postgres",
  host: "localhost",
  database: "base_datos_principal",
  password: "tu_contraseña",
  port: 5432,
});

export const logsDB = new Pool({
  user: "postgres",
  host: "localhost",
  database: "logs_login",
  password: "tu_contraseña",
  port: 5432,
});
