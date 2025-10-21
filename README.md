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
-- ================================
-- TABLA USUARIO
-- ================================
CREATE TABLE USUARIO (
    id_usuario SERIAL PRIMARY KEY,  -- Se usa SERIAL para auto incremento
    documento VARCHAR(50) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL,  -- 'docente', 'estudiante', 'directivo'
    activo BOOLEAN DEFAULT TRUE
);

-- ================================
-- TABLA ASIGNATURA
-- ================================
CREATE TABLE ASIGNATURA (
    id_asignatura SERIAL PRIMARY KEY,  
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    creditos INT NOT NULL,
    descripcion TEXT,
    activa BOOLEAN DEFAULT TRUE
);

-- ================================
-- TABLA PERIODO_ACADEMICO
-- ================================
CREATE TABLE PERIODO_ACADEMICO (
    id_periodo SERIAL PRIMARY KEY,  
    nombre VARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

-- ================================
-- TABLA ASIGNACION (docente ↔ asignatura ↔ periodo)
-- ================================
CREATE TABLE ASIGNACION (
    id_asignacion SERIAL PRIMARY KEY,  
    id_docente INT NOT NULL,
    id_asignatura INT NOT NULL,
    id_periodo INT NOT NULL,
    grupo VARCHAR(20) NOT NULL,
    horario VARCHAR(100),
    FOREIGN KEY (id_docente) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_asignatura) REFERENCES ASIGNATURA(id_asignatura),
    FOREIGN KEY (id_periodo) REFERENCES PERIODO_ACADEMICO(id_periodo)
);

-- ================================
-- TABLA MATRICULA (estudiante ↔ asignatura ↔ periodo)
-- ================================
CREATE TABLE MATRICULA (
    id_matricula SERIAL PRIMARY KEY,  
    id_estudiante INT NOT NULL,
    id_asignatura INT NOT NULL,
    id_periodo INT NOT NULL,
    fecha_matricula DATE DEFAULT CURRENT_DATE,  
    estado VARCHAR(20) DEFAULT 'Activa',
    FOREIGN KEY (id_estudiante) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_asignatura) REFERENCES ASIGNATURA(id_asignatura),
    FOREIGN KEY (id_periodo) REFERENCES PERIODO_ACADEMICO(id_periodo)
);

-- ================================
-- TABLA CONFIGURACION_NOTA (estructura de notas por asignatura)
-- ================================
CREATE TABLE CONFIGURACION_NOTA (
    id_config SERIAL PRIMARY KEY,  
    id_asignatura INT NOT NULL,
    tipo_nota VARCHAR(50) NOT NULL,  -- Ej: Parcial, Taller, Proyecto
    porcentaje DECIMAL(5,2) NOT NULL, -- Ej: 30.00
    orden INT NOT NULL,
    FOREIGN KEY (id_asignatura) REFERENCES ASIGNATURA(id_asignatura)
);

-- ================================
-- TABLA NOTA (notas registradas para un estudiante en una config)
-- ================================
CREATE TABLE NOTA (
    id_nota SERIAL PRIMARY KEY,  
    id_matricula INT NOT NULL,
    id_config INT NOT NULL,
    id_docente INT NOT NULL,
    valor_nota DECIMAL(5,2) CHECK (valor_nota >= 0 AND valor_nota <= 5),  
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Se usa CURRENT_TIMESTAMP para fecha y hora
    fecha_modificacion TIMESTAMP,
    observaciones TEXT,
    FOREIGN KEY (id_matricula) REFERENCES MATRICULA(id_matricula),
    FOREIGN KEY (id_config) REFERENCES CONFIGURACION_NOTA(id_config),
    FOREIGN KEY (id_docente) REFERENCES USUARIO(id_usuario)
);

-- ================================
-- TABLA REPORTE (generado por directivo)
-- ================================
CREATE TABLE REPORTE (
    id_reporte SERIAL PRIMARY KEY,  
    id_directivo INT NOT NULL,
    tipo_reporte VARCHAR(50) NOT NULL,
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    parametros TEXT,
    resultado TEXT,
    FOREIGN KEY (id_directivo) REFERENCES USUARIO(id_usuario)
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
