-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2026-09-18 01:10:47 CST
--   sitio:      Oracle Database 21c
--   tipo:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE Cargo_Empleado 
    ( 
     Id_Cargo     NUMBER (20)  NOT NULL , 
     Nombre_Cargo VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE Cargo_Empleado 
    ADD CONSTRAINT Cargo_Empleado_PK PRIMARY KEY ( Id_Cargo ) ;

ALTER TABLE Cargo_Empleado 
    ADD CONSTRAINT Cargo_Empleado_Nombre_Cargo_UN UNIQUE ( Nombre_Cargo ) ;

CREATE TABLE Categoria_Producto 
    ( 
     Codigo_Categoria NUMBER (20)  NOT NULL , 
     Nombre           VARCHAR2 (100)  NOT NULL 
    ) 
;

ALTER TABLE Categoria_Producto 
    ADD CONSTRAINT Categoria_Producto_PK PRIMARY KEY ( Codigo_Categoria ) ;

ALTER TABLE Categoria_Producto 
    ADD CONSTRAINT Categoria_Producto_Nombre_UN UNIQUE ( Nombre ) ;

CREATE TABLE Cliente 
    ( 
     Codigo_Cliente                 NUMBER (20)  NOT NULL , 
     Nombres                        VARCHAR2 (100)  NOT NULL , 
     Apellidos                      VARCHAR2 (100)  NOT NULL , 
     Numero_Identificacion          VARCHAR2 (50)  NOT NULL , 
     Correo                         VARCHAR2 (100) , 
     Direccion                      VARCHAR2 (200) , 
     Id_Municipio                   NUMBER (20)  NOT NULL , 
     Tipo_Identificacion_Id_Tipo_Id NUMBER (20) NOT NULL
    ) 
;

ALTER TABLE Cliente 
    ADD CONSTRAINT Cliente_PK PRIMARY KEY ( Codigo_Cliente ) ;

ALTER TABLE Cliente 
    ADD CONSTRAINT CLI_NUMID_TIPO_UN UNIQUE ( Numero_Identificacion , Tipo_Identificacion_Id_Tipo_Id ) ;

ALTER TABLE Cliente 
    ADD CONSTRAINT Cliente_Correo_UN UNIQUE ( Correo ) ;

CREATE TABLE Departamento 
    ( 
     Id_Departamento   NUMBER (10)  NOT NULL , 
     Nombre            VARCHAR2 (100)  NOT NULL , 
     Pais_Codigo_Pais  NUMBER (10)  NOT NULL  
    );

ALTER TABLE Departamento 
    ADD CONSTRAINT Departamento_PK PRIMARY KEY ( Id_Departamento ) ;

ALTER TABLE Departamento 
    ADD CONSTRAINT Departamento_Nombre_UN UNIQUE ( Nombre ) ;

CREATE TABLE Detalle_Pago 
    ( 
     Id_Pago               NUMBER (20)  NOT NULL , 
     Monto_Pagado          NUMBER (10,2)  NOT NULL , 
     Venta_Numero_Venta    NUMBER (20) NOT NULL , 
     Metodo_Pago_Id_Metodo NUMBER (20) NOT NULL
    ) 
;

ALTER TABLE Detalle_Pago 
    ADD CONSTRAINT Detalle_Pago_CK_Monto_Pagado 
    CHECK (Monto_Pagado > 0)
;
ALTER TABLE Detalle_Pago 
    ADD CONSTRAINT Detalle_Pago_PK PRIMARY KEY ( Id_Pago ) ;

CREATE TABLE Detalle_Venta 
    ( 
     Id_Detalle               NUMBER (20)  NOT NULL , 
     Cantidad                 NUMBER (20)  NOT NULL , 
     Precio_Unitario          NUMBER (10,2)  NOT NULL , 
     Subtotal                 NUMBER (10,2)  NOT NULL , 
     Venta_Numero_Venta       NUMBER (20) NOT NULL, 
     Producto_Codigo_Producto NUMBER (20) NOT NULL
    ) 
;

ALTER TABLE Detalle_Venta 
    ADD CONSTRAINT Detalle_Venta_CK_Cantidad 
    CHECK (Cantidad > 0)
;


ALTER TABLE Detalle_Venta 
    ADD CONSTRAINT DV_CK_PRECIO 
    CHECK (Precio_Unitario > 0)
;
ALTER TABLE Detalle_Venta 
    ADD CONSTRAINT Detalle_Venta_PK PRIMARY KEY ( Id_Detalle ) ;

-- 2. Crea la restricción UNIQUE compuesta correcta (Venta + Producto)
ALTER TABLE Detalle_Venta 
    ADD CONSTRAINT DV_VENTA_PROD_UN UNIQUE ( Venta_Numero_Venta, Producto_Codigo_Producto );

CREATE TABLE Empleado 
    ( 
     Codigo_Empleado         NUMBER (20)  NOT NULL , 
     Nombres                 VARCHAR2 (100)  NOT NULL , 
     Apellidos               VARCHAR2 (100)  NOT NULL , 
     Correo                  VARCHAR2 (100)  NOT NULL , 
     Telefono                VARCHAR2 (20) , 
     Fecha_Contratacion      DATE  NOT NULL , 
     Tienda_Id_Tienda        NUMBER (20) NOT NULL , 
     Cargo_Empleado_Id_Cargo NUMBER (20) NOT NULL
    ) 
;

ALTER TABLE Empleado 
    ADD CONSTRAINT Empleado_CK_1 
    CHECK (Fecha_Contratacion <= SYSDATE)
;
ALTER TABLE Empleado 
    ADD CONSTRAINT Empleado_PK PRIMARY KEY ( Codigo_Empleado ) ;

ALTER TABLE Empleado 
    ADD CONSTRAINT Empleado_Correo_UN UNIQUE ( Correo ) ;

CREATE TABLE Estado_Venta 
    ( 
     Id_Estado   NUMBER (20)  NOT NULL , 
     Tipo_Estado VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE Estado_Venta 
    ADD CONSTRAINT Estado_Venta_PK PRIMARY KEY ( Id_Estado ) ;

ALTER TABLE Estado_Venta 
    ADD CONSTRAINT Estado_Venta_Tipo_Estado_UN UNIQUE ( Tipo_Estado ) ;

CREATE TABLE Marca_Producto 
    ( 
     Codigo_Marca NUMBER (20)  NOT NULL , 
     Nombre       VARCHAR2 (100)  NOT NULL 
    ) 
;

ALTER TABLE Marca_Producto 
    ADD CONSTRAINT Marca_Producto_PK PRIMARY KEY ( Codigo_Marca ) ;

ALTER TABLE Marca_Producto 
    ADD CONSTRAINT Marca_Producto_Nombre_UN UNIQUE ( Nombre ) ;

CREATE TABLE Metodo_Pago 
    ( 
     Id_Metodo     NUMBER (20)  NOT NULL , 
     Nombre_Metodo VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE Metodo_Pago 
    ADD CONSTRAINT Metodo_Pago_PK PRIMARY KEY ( Id_Metodo ) ;

ALTER TABLE Metodo_Pago 
    ADD CONSTRAINT Metodo_Pago_Nombre_Metodo_UN UNIQUE ( Nombre_Metodo ) ;

CREATE TABLE Municipio 
    ( 
     Id_Municipio                  NUMBER (20)  NOT NULL , 
     Nombre                        VARCHAR2 (100)  NOT NULL , 
     Departamento_Id_Departamento NUMBER (10) NOT NULL
    ) 
;

ALTER TABLE Municipio 
    ADD CONSTRAINT Municipio_PK PRIMARY KEY ( Id_Municipio ) ;

ALTER TABLE Municipio 
    ADD CONSTRAINT Municipio_Nombre_UN UNIQUE ( Nombre ) ;

-- 3. Crear la relación faltante Cliente -> Municipio
ALTER TABLE Cliente 
    ADD CONSTRAINT Cliente_Municipio_FK FOREIGN KEY ( Id_Municipio ) 
    REFERENCES Municipio ( Id_Municipio );

CREATE TABLE Pais 
    ( 
     Codigo_Pais NUMBER (10)  NOT NULL , 
     Nombre      VARCHAR2 (100)  NOT NULL 
    ) 
;

ALTER TABLE Pais 
    ADD CONSTRAINT Pais_PK PRIMARY KEY ( Codigo_Pais ) ;

ALTER TABLE Pais 
    ADD CONSTRAINT Pais_Nombre_UN UNIQUE ( Nombre ) ;

CREATE TABLE Producto 
    ( 
     Codigo_Producto             NUMBER (20)  NOT NULL , 
     Nombre                      VARCHAR2 (150)  NOT NULL , 
     Descripcion                 VARCHAR2 (300) , 
     Precio                      NUMBER (10,2)  NOT NULL , 
     Existencia_Actual           NUMBER (20)  NOT NULL , 
     Categoria_Codigo            NUMBER (20) , 
     Marca_Producto_Codigo NUMBER (20) 
    ) 
;

ALTER TABLE Producto 
    ADD CONSTRAINT Producto_CK_Precio 
    CHECK (Precio > 0)
;


ALTER TABLE Producto 
    ADD CONSTRAINT Producto_CK_Existencia_Actual 
    CHECK (Existencia_Actual >= 0)
;
ALTER TABLE Producto 
    ADD CONSTRAINT Producto_PK PRIMARY KEY ( Codigo_Producto ) ;

CREATE TABLE Tienda 
    ( 
     Id_Tienda                  NUMBER (20)  NOT NULL , 
     Nombre                     VARCHAR2 (100)  NOT NULL , 
     Direccion                  VARCHAR2 (200)  NOT NULL , 
     Telefono                   VARCHAR2 (20) , 
     Municipio_Id_Municipio     NUMBER (20) NOT NULL, 
     Tipo_Tienda_Id_Tipo_Tienda NUMBER (20) NOT NULL
    ) 
;

ALTER TABLE Tienda 
    ADD CONSTRAINT Tienda_PK PRIMARY KEY ( Id_Tienda ) ;

CREATE TABLE Tipo_Identificacion 
    ( 
     Id_Tipo_Id            NUMBER (20)  NOT NULL , 
     Nombre_Identificacion VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE Tipo_Identificacion 
    ADD CONSTRAINT Tipo_Identificacion_PK PRIMARY KEY ( Id_Tipo_Id ) ;

ALTER TABLE Tipo_Identificacion 
    ADD CONSTRAINT TIPOID_NOMBRE_UN UNIQUE ( Nombre_Identificacion ) ;

CREATE TABLE Tipo_Tienda 
    ( 
     Id_Tipo_Tienda NUMBER (20)  NOT NULL , 
     Nombre_Tipo    VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE Tipo_Tienda 
    ADD CONSTRAINT Tipo_Tienda_PK PRIMARY KEY ( Id_Tipo_Tienda ) ;

ALTER TABLE Tipo_Tienda 
    ADD CONSTRAINT Tipo_Tienda_Nombre_Tipo_UN UNIQUE ( Nombre_Tipo ) ;

CREATE TABLE Venta 
    ( 
     Numero_Venta             NUMBER (20)  NOT NULL , 
     Fecha                    DATE  NOT NULL , 
     Tienda_Id_Tienda         NUMBER (20) NOT NULL, 
     Empleado_Codigo_Empleado NUMBER (20) NOT NULL, 
     Cliente_Codigo_Cliente   NUMBER (20) NOT NULL, 
     Estado_Venta_Id_Estado   NUMBER (20) NOT NULL
    ) 
;

ALTER TABLE Venta 
    ADD CONSTRAINT Venta_PK PRIMARY KEY ( Numero_Venta ) ;

ALTER TABLE Cliente 
    ADD CONSTRAINT Cliente_Tipo_Identificacion_FK FOREIGN KEY 
    ( 
     Tipo_Identificacion_Id_Tipo_Id
    ) 
    REFERENCES Tipo_Identificacion 
    ( 
     Id_Tipo_Id
    ) 
;

ALTER TABLE Departamento 
    ADD CONSTRAINT Departamento_Pais_FK FOREIGN KEY 
    ( 
     Pais_Codigo_Pais
    ) 
    REFERENCES Pais 
    ( 
     Codigo_Pais
    ) 
;

ALTER TABLE Detalle_Pago 
    ADD CONSTRAINT Detalle_Pago_Metodo_Pago_FK FOREIGN KEY 
    ( 
     Metodo_Pago_Id_Metodo
    ) 
    REFERENCES Metodo_Pago 
    ( 
     Id_Metodo
    ) 
;

ALTER TABLE Detalle_Pago 
    ADD CONSTRAINT Detalle_Pago_Venta_FK FOREIGN KEY 
    ( 
     Venta_Numero_Venta
    ) 
    REFERENCES Venta 
    ( 
     Numero_Venta
    ) 
;

ALTER TABLE Detalle_Venta 
    ADD CONSTRAINT Detalle_Venta_Producto_FK FOREIGN KEY 
    ( 
     Producto_Codigo_Producto
    ) 
    REFERENCES Producto 
    ( 
     Codigo_Producto
    ) 
;

ALTER TABLE Detalle_Venta 
    ADD CONSTRAINT Detalle_Venta_Venta_FK FOREIGN KEY 
    ( 
     Venta_Numero_Venta
    ) 
    REFERENCES Venta 
    ( 
     Numero_Venta
    ) 
;

ALTER TABLE Empleado 
    ADD CONSTRAINT Empleado_Cargo_Empleado_FK FOREIGN KEY 
    ( 
     Cargo_Empleado_Id_Cargo
    ) 
    REFERENCES Cargo_Empleado 
    ( 
     Id_Cargo
    ) 
;

ALTER TABLE Empleado 
    ADD CONSTRAINT Empleado_Tienda_FK FOREIGN KEY 
    ( 
     Tienda_Id_Tienda
    ) 
    REFERENCES Tienda 
    ( 
     Id_Tienda
    ) 
;

ALTER TABLE Municipio 
    ADD CONSTRAINT Municipio_Departamento_FK FOREIGN KEY 
    ( 
     Departamento_Id_Departamento
    ) 
    REFERENCES Departamento 
    ( 
     Id_Departamento
    ) 
;


ALTER TABLE Producto 
    ADD CONSTRAINT Producto_Categoria_Producto_FK FOREIGN KEY 
    ( 
     Categoria_Codigo
    ) 
    REFERENCES Categoria_Producto 
    ( 
     Codigo_Categoria
    ) 
;

ALTER TABLE Producto 
    ADD CONSTRAINT Producto_Marca_Producto_FK FOREIGN KEY 
    ( 
     Marca_Producto_Codigo
    ) 
    REFERENCES Marca_Producto 
    ( 
     Codigo_Marca
    ) 
;

ALTER TABLE Tienda 
    ADD CONSTRAINT Tienda_Municipio_FK FOREIGN KEY 
    ( 
     Municipio_Id_Municipio
    ) 
    REFERENCES Municipio 
    ( 
     Id_Municipio
    ) 
;

ALTER TABLE Tienda 
    ADD CONSTRAINT Tienda_Tipo_Tienda_FK FOREIGN KEY 
    ( 
     Tipo_Tienda_Id_Tipo_Tienda
    ) 
    REFERENCES Tipo_Tienda 
    ( 
     Id_Tipo_Tienda
    ) 
;

ALTER TABLE Venta 
    ADD CONSTRAINT Venta_Cliente_FK FOREIGN KEY 
    ( 
     Cliente_Codigo_Cliente
    ) 
    REFERENCES Cliente 
    ( 
     Codigo_Cliente
    ) 
;

ALTER TABLE Venta 
    ADD CONSTRAINT Venta_Empleado_FK FOREIGN KEY 
    ( 
     Empleado_Codigo_Empleado
    ) 
    REFERENCES Empleado 
    ( 
     Codigo_Empleado
    ) 
;

ALTER TABLE Venta 
    ADD CONSTRAINT Venta_Estado_Venta_FK FOREIGN KEY 
    ( 
     Estado_Venta_Id_Estado
    ) 
    REFERENCES Estado_Venta 
    ( 
     Id_Estado
    ) 
;

ALTER TABLE Venta 
    ADD CONSTRAINT Venta_Tienda_FK FOREIGN KEY 
    ( 
     Tienda_Id_Tienda
    ) 
    REFERENCES Tienda 
    ( 
     Id_Tienda
    ) 
;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            17
-- CREATE INDEX                             0
-- ALTER TABLE                             54
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
