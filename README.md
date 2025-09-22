# Sistema de Gestión de Notas

**Portal educativo** para la gestión de notas: los docentes registran notas parciales y finales, los estudiantes consultan sus notas y los directivos gestionan usuarios y asignaturas.

**Tecnologías principales**
- **Frontend**: HTML, CSS, JavaScript (React recomendado)
- **Backend**: Node.js + Express
- **Base de datos**: MySQL o PostgreSQL
- **Autenticación**: JWT (o sesiones según preferencia)

---

## Contenido

1. [Características](#características)
2. [Arquitectura](#arquitectura)
3. [Requisitos](#requisitos)
4. [Instalación & ejecución local](#instalación--ejecución-local)
5. [Base de datos: esquema](#base-de-datos-esquema)
6. [Variables de entorno](#variables-de-entorno)
7. [Pruebas](#pruebas)
8. [Despliegue](#despliegue)
9. [Contribuir](#contribuir)
10. [Licencia](#licencia)

---

## Características

- Registro e inicio de sesión para **Docentes**, **Estudiantes** y **Directivos**.
- **Docentes**: crear, editar y eliminar notas parciales y finales.
- **Estudiantes**: consultar notas y promedios por asignatura.
- **Directivos**: gestionar usuarios, asignar materias y ver reportes.
- Control de acceso por roles y validaciones (p. ej., rango de notas).
- Cálculo de nota final por ponderación configurada.

---

## Arquitectura (sugerida)

```
frontend/   -> React (Vite / Create React App)
backend/    -> Node.js + Express
database/   -> scripts SQL / migrations (MySQL / Postgres)
```

---

## Requisitos

- Node.js >= 16
- NPM o Yarn
- MySQL >= 5.7 / PostgreSQL >= 12
- (Opcional) Docker para levantar DB y app

---

## Instalación & ejecución local

### 1. Clona el repositorio

```bash
git clone https://github.com/<tu-usuario>/<repo>.git
cd <repo>
```

### 2. Configura el backend

```bash
cd backend
cp .env.example .env
# Ajusta .env con tus credenciales de DB
npm install
# Para desarrollo:
npm run dev
# Para producción:
npm run start
```

### 3. Configura el frontend

```bash
cd ../frontend
cp .env.example .env
npm install
npm run dev
```

---

## Base de datos: esquema

```sql
-- Tabla roles
CREATE TABLE roles (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla usuarios
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(150),
  email VARCHAR(150),
  role_id INTEGER REFERENCES roles(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla asignaturas (courses)
CREATE TABLE courses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  code VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Relación docente-curso
CREATE TABLE teacher_courses (
  id SERIAL PRIMARY KEY,
  teacher_id INTEGER REFERENCES users(id),
  course_id INTEGER REFERENCES courses(id)
);

-- Tabla notas
CREATE TABLE grades (
  id SERIAL PRIMARY KEY,
  student_id INTEGER REFERENCES users(id),
  course_id INTEGER REFERENCES courses(id),
  parcial1 NUMERIC(4,2),
  parcial2 NUMERIC(4,2),
  final NUMERIC(4,2),
  calculated_final NUMERIC(4,2),
  created_by INTEGER REFERENCES users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Variables de entorno

```env
PORT=4000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=notas_db
DB_USER=postgres
DB_PASS=postgres
JWT_SECRET=un_secret_fuerte_aqui
NODE_ENV=development
VITE_API_URL=http://localhost:4000/api
```

---

## Pruebas

```bash
# backend
npm run test
```

---

## Despliegue

- Opciones: Heroku, Railway, Render, VPS con Docker, o servicio de tu preferencia.
- Recuerda configurar variables de entorno en el hosting y la cadena de conexión a la base de datos.

---

## Contribuir

1. Crear un issue describiendo la mejora o bug.
2. Crear una rama: `feature/<nombre>` o `fix/<nombre>`.
3. Hacer PR indicando qué se resolvió y pruebas realizadas.

---

## Roadmap / Tareas pendientes

- Importar masivamente listas de estudiantes (CSV).
- Auditoría de cambios (quién y cuándo modificó una nota).
- Notificaciones por correo al estudiante cuando su nota cambia.
- Historial de notas por periodo académico.

---

## Licencia

Este proyecto está bajo la licencia MIT — ver [LICENSE](LICENSE).

---

## Contacto

**Autor**: Andrés Felipe Martínez Henao  
**Email**: f.martinez5@utp.edu.co
```
