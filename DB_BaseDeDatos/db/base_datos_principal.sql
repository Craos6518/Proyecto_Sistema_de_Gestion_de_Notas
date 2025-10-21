--Base de datos para PostgreSQL

-- ================================
-- TABLA USUARIO
-- ================================
CREATE TABLE USUARIO (
    id_usuario SERIAL PRIMARY KEY,  -- Se usa SERIAL para auto incremento
    documento VARCHAR(50) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
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
