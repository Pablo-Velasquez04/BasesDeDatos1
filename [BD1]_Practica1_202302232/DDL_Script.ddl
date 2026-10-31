DROP TABLE Bitacora CASCADE CONSTRAINTS;
DROP TABLE Detalle_Evaluacion CASCADE CONSTRAINTS;
DROP TABLE Evaluacion CASCADE CONSTRAINTS;
DROP TABLE Criterio_Evaluacion CASCADE CONSTRAINTS;
DROP TABLE Colocacion CASCADE CONSTRAINTS;
DROP TABLE Plaza CASCADE CONSTRAINTS;
DROP TABLE Contacto_Empresarial CASCADE CONSTRAINTS;
DROP TABLE Empresa CASCADE CONSTRAINTS;
DROP TABLE Catedratico_Supervisor CASCADE CONSTRAINTS;
DROP TABLE Instituto CASCADE CONSTRAINTS;
DROP TABLE Estudiante CASCADE CONSTRAINTS;
DROP TABLE Municipio CASCADE CONSTRAINTS;
DROP TABLE Departamento CASCADE CONSTRAINTS;

CREATE TABLE Departamento 
    ( 
     id_departamento NUMBER NOT NULL, 
     nombre VARCHAR2(50) 
    );

ALTER TABLE Departamento ADD CONSTRAINT Departamento_PK PRIMARY KEY ( id_departamento );

CREATE TABLE Municipio 
    ( 
     id_municipio NUMBER NOT NULL, 
     nombre VARCHAR2(50), 
     Departamento_id_departamento NUMBER NOT NULL 
    );

ALTER TABLE Municipio ADD CONSTRAINT Municipio_PK PRIMARY KEY ( id_municipio );

CREATE TABLE Estudiante 
    ( 
     id_estudiante NUMBER NOT NULL, 
     carne VARCHAR2(20) NOT NULL, 
     nombre_completo VARCHAR2(50), 
     carrera_tecnica VARCHAR2(50), 
     direccion VARCHAR2(100), 
     telefono VARCHAR2(20), 
     fecha_nacimiento DATE, 
     genero VARCHAR2(20), 
     es_repitente CHAR(1), 
     Municipio_id_municipio NUMBER NOT NULL 
    );

ALTER TABLE Estudiante ADD CONSTRAINT Estudiante_PK PRIMARY KEY ( id_estudiante );
ALTER TABLE Estudiante ADD CONSTRAINT Estudiante_carne_UN UNIQUE ( carne );

CREATE TABLE Instituto 
    ( 
     id_instituto NUMBER NOT NULL, 
     nombre VARCHAR2(50), 
     direccion VARCHAR2(100), 
     codigo_autorizacion VARCHAR2(50) 
    );

ALTER TABLE Instituto ADD CONSTRAINT Instituto_PK PRIMARY KEY ( id_instituto );

CREATE TABLE Catedratico_Supervisor 
    ( 
     id_catedratico NUMBER NOT NULL, 
     identificacion VARCHAR2(50), 
     nombre VARCHAR2(50), 
     telefono VARCHAR2(20), 
     especialidad_supervisada VARCHAR2(50), 
     Instituto_id_instituto NUMBER NOT NULL 
    );

ALTER TABLE Catedratico_Supervisor ADD CONSTRAINT Catedratico_Supervisor_PK PRIMARY KEY ( id_catedratico );

CREATE TABLE Empresa 
    ( 
     id_empresa INTEGER NOT NULL, 
     nombre VARCHAR2(100), 
     direccion VARCHAR2(150), 
     sector_economico VARCHAR2(50) 
    );

ALTER TABLE Empresa ADD CONSTRAINT Empresa_PK PRIMARY KEY ( id_empresa );

CREATE TABLE Contacto_Empresarial 
    ( 
     id_contacto NUMBER NOT NULL, 
     nombre VARCHAR2(100), 
     telefono VARCHAR2(20), 
     correo VARCHAR2(100), 
     Empresa_id_empresa INTEGER NOT NULL 
    );

ALTER TABLE Contacto_Empresarial ADD CONSTRAINT Contacto_Empresarial_PK PRIMARY KEY ( id_contacto );

CREATE TABLE Plaza 
    ( 
     id_plaza NUMBER NOT NULL, 
     especialidad_tecnica VARCHAR2(50), 
     Empresa_id_empresa INTEGER NOT NULL, 
     id_contacto NUMBER NOT NULL 
    );

ALTER TABLE Plaza ADD CONSTRAINT Plaza_PK PRIMARY KEY ( id_plaza );

CREATE TABLE Colocacion 
    ( 
     id_colocacion NUMBER NOT NULL, 
     fecha_inicio DATE, 
     fecha_inicializacion DATE, 
     estado VARCHAR2(50), 
     id_catedratico NUMBER NOT NULL, 
     Estudiante_id_estudiante NUMBER NOT NULL, 
     Plaza_id_plaza NUMBER NOT NULL 
    );

ALTER TABLE Colocacion ADD CONSTRAINT Colocacion_PK PRIMARY KEY ( id_colocacion );

CREATE TABLE Bitacora 
    ( 
     id_bitacora NUMBER NOT NULL, 
     correlativo NUMBER, 
     fecha DATE, 
     horas_trabajadas NUMBER, 
     actividades_realizadas VARCHAR2(2000), 
     observaciones VARCHAR2(2000), 
     validacion_contacto CHAR(1), 
     Colocacion_id_colocacion NUMBER NOT NULL 
    );

ALTER TABLE Bitacora ADD CONSTRAINT Bitacora_PK PRIMARY KEY ( id_bitacora );

CREATE TABLE Evaluacion 
    ( 
     id_evaluacion NUMBER NOT NULL, 
     momento_evaluacion VARCHAR2(100), 
     fecha_evaluacion DATE, 
     Colocacion_id_colocacion NUMBER NOT NULL 
    );

ALTER TABLE Evaluacion ADD CONSTRAINT Evaluacion_PK PRIMARY KEY ( id_evaluacion );

CREATE TABLE Criterio_Evaluacion 
    ( 
     id_criterio NUMBER NOT NULL, 
     nombre_criterio VARCHAR2(100) 
    );

ALTER TABLE Criterio_Evaluacion ADD CONSTRAINT Criterio_Evaluacion_PK PRIMARY KEY ( id_criterio );

CREATE TABLE Detalle_Evaluacion 
    ( 
     id_detalle_eval NUMBER NOT NULL, 
     puntuacion NUMBER, 
     Evaluacion_id_evaluacion NUMBER NOT NULL, 
     id_criterio NUMBER NOT NULL 
    );

ALTER TABLE Detalle_Evaluacion ADD CONSTRAINT Detalle_Evaluacion_PK PRIMARY KEY ( id_detalle_eval );

-- Creación de Restricciones Foreign Key (FK)
ALTER TABLE Municipio 
    ADD CONSTRAINT Municipio_Departamento_FK FOREIGN KEY ( Departamento_id_departamento ) 
    REFERENCES Departamento ( id_departamento );

ALTER TABLE Estudiante 
    ADD CONSTRAINT Estudiante_Municipio_FK FOREIGN KEY ( Municipio_id_municipio ) 
    REFERENCES Municipio ( id_municipio );

ALTER TABLE Catedratico_Supervisor 
    ADD CONSTRAINT Catedratico_Inst_FK FOREIGN KEY ( Instituto_id_instituto ) 
    REFERENCES Instituto ( id_instituto );

ALTER TABLE Contacto_Empresarial 
    ADD CONSTRAINT Contacto_Empresa_FK FOREIGN KEY ( Empresa_id_empresa ) 
    REFERENCES Empresa ( id_empresa );

ALTER TABLE Plaza 
    ADD CONSTRAINT Plaza_Empresa_FK FOREIGN KEY ( Empresa_id_empresa ) 
    REFERENCES Empresa ( id_empresa );

ALTER TABLE Plaza 
    ADD CONSTRAINT Plaza_Contacto_FK FOREIGN KEY ( id_contacto ) 
    REFERENCES Contacto_Empresarial ( id_contacto );

ALTER TABLE Colocacion 
    ADD CONSTRAINT Colocacion_Catedratico_FK FOREIGN KEY ( id_catedratico ) 
    REFERENCES Catedratico_Supervisor ( id_catedratico );

ALTER TABLE Colocacion 
    ADD CONSTRAINT Colocacion_Estudiante_FK FOREIGN KEY ( Estudiante_id_estudiante ) 
    REFERENCES Estudiante ( id_estudiante );

ALTER TABLE Colocacion 
    ADD CONSTRAINT Colocacion_Plaza_FK FOREIGN KEY ( Plaza_id_plaza ) 
    REFERENCES Plaza ( id_plaza );

ALTER TABLE Bitacora 
    ADD CONSTRAINT Bitacora_Colocacion_FK FOREIGN KEY ( Colocacion_id_colocacion ) 
    REFERENCES Colocacion ( id_colocacion );

ALTER TABLE Evaluacion 
    ADD CONSTRAINT Evaluacion_Colocacion_FK FOREIGN KEY ( Colocacion_id_colocacion ) 
    REFERENCES Colocacion ( id_colocacion );

ALTER TABLE Detalle_Evaluacion 
    ADD CONSTRAINT Det_Eval_Evaluacion_FK FOREIGN KEY ( Evaluacion_id_evaluacion ) 
    REFERENCES Evaluacion ( id_evaluacion );

ALTER TABLE Detalle_Evaluacion 
    ADD CONSTRAINT Det_Eval_Criterio_FK FOREIGN KEY ( id_criterio ) 
    REFERENCES Criterio_Evaluacion ( id_criterio );