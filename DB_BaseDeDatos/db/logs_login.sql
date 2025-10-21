-- ================================
-- TABLA LOGS_LOGIN
-- ================================
CREATE TABLE logs_login (
    id_log SERIAL PRIMARY KEY,
    id_usuario INT,
    email VARCHAR(100) NOT NULL,
    tipo_intento VARCHAR(20) NOT NULL,  -- 'exitoso' o 'fallido'
    razon_fallo VARCHAR(255),
    ip_address VARCHAR(45),
    user_agent TEXT,
    fecha_intento TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================
-- PROCEDIMIENTO: REGISTRAR INTENTO DE LOGIN
-- ================================
CREATE OR REPLACE FUNCTION sp_registrar_intento_login(
    p_email VARCHAR,
    p_id_usuario INT,
    p_tipo_intento VARCHAR,
    p_razon_fallo VARCHAR,
    p_ip_address VARCHAR,
    p_user_agent TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO logs_login (
        email, id_usuario, tipo_intento, razon_fallo, ip_address, user_agent, fecha_intento
    ) VALUES (
        p_email, p_id_usuario, p_tipo_intento, p_razon_fallo, p_ip_address, p_user_agent, NOW()
    );
END;
$$ LANGUAGE plpgsql;
