USE GD2C2020
GO

CREATE SCHEMA GDD
GO


/**************************
 *   CREACION DE TABLAS   *
 **************************/

CREATE TABLE GDD.Cliente (
	clie_id int identity(1,1) PRIMARY KEY not null,
	clie_nombre nvarchar(255) null,
	clie_apellido nvarchar(255) null,
	clie_direccion nvarchar(255) null,
	clie_dni decimal(18,0) null,
	clie_mail nvarchar(255) null,
	clie_fecha_nac datetime2(3)null
)
GO

create table GDD.FACTURA (
	factura_id int identity(1,1) not null PRIMARY KEY,
	factura_fecha datetime2(3) null,
	factura_clie int null,
	factura_numero decimal(18,0) null,
	factura_total decimal(18,0) null
)
GO

create table GDD.ITEM_FACTURA (
    item_factura_id int identity(1,1) not null PRIMARY KEY,
	item_cantidad decimal(18,0) null,
	item_precio decimal(18,0) null,
	factura int null,
	item_factura_auto_parte decimal(18,0) null
)
GO

create table GDD.SUCURSAL (
	sucursal_id int identity(1,1) not null PRIMARY KEY,
	sucursal_telefono decimal(18,0) null,
	sucursal_direccion nvarchar(255) null,
	sucursal_ciudad nvarchar(255) null,
	sucursal_mail nvarchar(255) null
)
GO
	
		
create table GDD.TIPO_TRANSMISION(
	tipo_transmision_id decimal(18,0) PRIMARY KEY not null,
	tipo_transmision_desc  nvarchar(255) null
)
GO

	
create table GDD.TIPO_CAJA(
	tipo_caja_id decimal(18,0) PRIMARY KEY not null,
	tipo_caja_desc nvarchar(255) null
)
GO

	
create table GDD.TIPO_MOTOR(
	tipo_motor_codigo decimal(18,0) PRIMARY KEY not null,
	tipo_motor_desc nvarchar(255) null
)
GO

	
create table GDD.TIPO_AUTO(
	tipo_auto_id decimal(18,0) PRIMARY KEY not null,
	tipo_auto_desc nvarchar(255) null
)
GO

	
create table GDD.MODELO(
	modelo_codigo decimal(18,0) PRIMARY KEY not null,
	modelo_tipo_caja decimal(18,0),
	modelo_tipo_auto decimal(18,0),
	modelo_tipo_motor decimal(18,0),
	modelo_tipo_transmision decimal(18,0),
	modelo_nombre nvarchar(255) null,
	modelo_potencia decimal(18,0) null
)
GO	
	
create table GDD.FABRICANTE(
	fabricante_id int identity(1,1) PRIMARY KEY not null,
	fabricante_nombre nvarchar(255) null
)
GO
		
	
create table GDD.COMPRA(
	compra_id int identity(1,1) not null PRIMARY KEY,
	compra_clie int null,
	compra_numero decimal(18,0) null,
	compra_sucursal int,
	compra_fecha datetime2(3) null,
	compra_precio decimal(18,0) null,
)
GO

create table GDD.ITEM_COMPRA(
    item_compra_id int identity(1,1) not null PRIMARY KEY,
	compra int null,
	item_compra_auto_parte decimal(18,0) null,
	item_compra_cant decimal(18,0) null,
	item_compra_precio decimal(18,0) null
)
GO

CREATE TABLE GDD.AUTO(
	auto_id  int identity(1,1) PRIMARY KEY not null,
	auto_factura int null,
	auto_compra int,
	auto_modelo decimal(18,0),
	auto_nro_chasis	nvarchar(50) null,
	auto_nro_motor nvarchar(50) null,
	auto_patente nvarchar(50) null,
	auto_fecha_alta datetime2(3) null,
	auto_cant_kms decimal(18,0) null
)
GO

	
create table GDD.AUTO_PARTE(
	auto_parte_id decimal(18,0) PRIMARY KEY not null,
	auto_parte_descripcion nvarchar(255) null,
	auto_parte_fabricante int null,
	auto_parte_modelo decimal(18,0) null
)
GO

create table GDD.ITEM_FACTURA_AUTO(
    item_factura_auto_id int identity(1,1) PRIMARY KEY not null,
	item_factura_auto_factura int null,
	auto int null,
	item_factura_auto_precio decimal(18,0) null

)

/*
create table GDD.STOCK(
	stock_id int identity(1,1) PRIMARY KEY not null,
	stock_auto_parte_id decimal(18,0) null,
	stock_sucursal_id int,
	stock_cant decimal(18,0) null
)
GO
*/


/***********************************
 *   CREACION DE CLAVES FORANEAS   *
 ***********************************/

ALTER TABLE GDD.MODELO
ADD CONSTRAINT FK_modelo_tipo_motor
FOREIGN KEY (modelo_tipo_motor) REFERENCES GDD.TIPO_MOTOR(tipo_motor_codigo)
GO 

ALTER TABLE GDD.MODELO
ADD CONSTRAINT FK_modelo_tipo_transmision
FOREIGN KEY (modelo_tipo_transmision) REFERENCES GDD.TIPO_TRANSMISION(tipo_transmision_id)
GO 

ALTER TABLE GDD.MODELO
ADD CONSTRAINT FK_modelo_tipo_auto
FOREIGN KEY (modelo_tipo_auto) REFERENCES GDD.TIPO_AUTO(tipo_auto_id)
GO 

ALTER TABLE GDD.MODELO
ADD CONSTRAINT FK_modelo_tipo_caja
FOREIGN KEY (modelo_tipo_caja) REFERENCES GDD.TIPO_CAJA(tipo_caja_id)
GO 

ALTER TABLE GDD.AUTO_PARTE
ADD CONSTRAINT FK_auto_parte_fabricante
FOREIGN KEY (auto_parte_fabricante) REFERENCES GDD.FABRICANTE(fabricante_id)
GO 

ALTER TABLE GDD.AUTO_PARTE
ADD CONSTRAINT FK_auto_parte_modelo
FOREIGN KEY (auto_parte_modelo) REFERENCES GDD.MODELO(modelo_codigo)
GO 

/*
ALTER TABLE GDD.STOCK
ADD CONSTRAINT FK_stock_auto_parte
FOREIGN KEY (stock_auto_parte_id) REFERENCES GDD.AUTO_PARTE(auto_parte_id)
GO 

ALTER TABLE GDD.STOCK
ADD CONSTRAINT FK_stock_sucursal
FOREIGN KEY (stock_sucursal_id) REFERENCES GDD.SUCURSAL(sucursal_id)
GO 
*/

ALTER TABLE GDD.FACTURA
ADD CONSTRAINT FK_factura_cliente
FOREIGN KEY (factura_clie) REFERENCES GDD.CLIENTE(clie_id)
GO

ALTER TABLE GDD.ITEM_FACTURA
ADD CONSTRAINT FK_factura_item
FOREIGN KEY (factura) REFERENCES GDD.FACTURA(factura_id)

ALTER TABLE GDD.ITEM_FACTURA
ADD CONSTRAINT FK_auto_parte_item
FOREIGN KEY (item_factura_auto_parte) REFERENCES GDD.AUTO_PARTE(auto_parte_id)

ALTER TABLE GDD.COMPRA
ADD CONSTRAINT FK_compra_sucursal
FOREIGN KEY (compra_sucursal) REFERENCES GDD.SUCURSAL(sucursal_id)
GO 

ALTER TABLE GDD.COMPRA
ADD CONSTRAINT FK_compra_cliente
FOREIGN KEY (compra_clie) REFERENCES GDD.CLIENTE(clie_id)
GO

ALTER TABLE GDD.ITEM_COMPRA
ADD CONSTRAINT FK_item_compra_auto_parte
FOREIGN KEY (item_compra_auto_parte) REFERENCES GDD.AUTO_PARTE(auto_parte_id)
GO

ALTER TABLE GDD.ITEM_COMPRA
ADD CONSTRAINT FK_item_compra_compra
FOREIGN KEY (compra) REFERENCES GDD.COMPRA(compra_id)
GO    

ALTER TABLE GDD.AUTO
ADD CONSTRAINT FK_auto_compra
FOREIGN KEY (auto_compra) REFERENCES GDD.COMPRA(compra_id)
GO

ALTER TABLE GDD.AUTO
ADD CONSTRAINT FK_auto_modelo
FOREIGN KEY (auto_modelo) REFERENCES GDD.MODELO(modelo_codigo)
GO 

ALTER TABLE GDD.ITEM_FACTURA_AUTO
ADD CONSTRAINT FK_facturaAuto_factura
FOREIGN KEY (item_factura_auto_factura) REFERENCES GDD.Factura(factura_id)
GO 

ALTER TABLE GDD.ITEM_FACTURA_AUTO
ADD CONSTRAINT FK_facturaAuto_auto
FOREIGN KEY (auto) REFERENCES GDD.AUTO(auto_id)
GO 

/***************************
 *   CREACION DE INDICES   *
 ***************************/

CREATE INDEX CLIENTE_DNI_APELLIDO ON GDD.CLIENTE(clie_dni, clie_apellido)
GO

CREATE INDEX SUCURSAL_CIUDAD ON GDD.SUCURSAL(sucursal_ciudad)
GO

CREATE INDEX FABRICANTE_NOMBRE ON GDD.FABRICANTE(fabricante_nombre)
GO

CREATE INDEX FACTURA_NUMERO ON GDD.FACTURA(factura_numero)
GO

/*********************************
 *   SPs DE MIGRACION DE DATOS   *
 *********************************/

IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_tipo_auto' AND type='p')
	DROP PROCEDURE GDD.migrar_tipo_auto
GO

CREATE PROCEDURE GDD.migrar_tipo_auto
AS
INSERT INTO GDD.Tipo_Auto(tipo_auto_id, tipo_auto_desc)
SELECT DISTINCT TIPO_AUTO_CODIGO, TIPO_AUTO_DESC
FROM [gd_esquema].[Maestra]
WHERE TIPO_AUTO_CODIGO IS NOT NULL
GO


IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_tipo_motor' AND type='p')
	DROP PROCEDURE GDD.migrar_tipo_motor
GO

CREATE PROCEDURE GDD.migrar_tipo_motor
AS
INSERT INTO GDD.Tipo_Motor(tipo_motor_codigo)
SELECT DISTINCT TIPO_MOTOR_CODIGO 
FROM [gd_esquema].[Maestra]
WHERE TIPO_MOTOR_CODIGO IS NOT NULL
GO


IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_tipo_caja' AND type='p')
	DROP PROCEDURE GDD.migrar_tipo_caja
GO

CREATE PROCEDURE GDD.migrar_tipo_caja
AS
INSERT INTO GDD.Tipo_Caja(tipo_caja_id, tipo_caja_desc)
SELECT DISTINCT TIPO_CAJA_CODIGO, TIPO_CAJA_DESC
FROM [gd_esquema].[Maestra]
WHERE TIPO_CAJA_CODIGO IS NOT NULL
GO


IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_tipo_transmision' AND type='p')
	DROP PROCEDURE GDD.migrar_tipo_transmision
GO

CREATE PROCEDURE GDD.migrar_tipo_transmision
AS
INSERT INTO GDD.Tipo_Transmision(tipo_transmision_id, tipo_transmision_desc)
SELECT DISTINCT TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC
FROM [gd_esquema].[Maestra]
WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL
GO


IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_modelo' AND type='p')
	DROP PROCEDURE GDD.migrar_modelo
GO

CREATE PROCEDURE GDD.migrar_modelo
AS
INSERT INTO GDD.MODELO(modelo_codigo, modelo_nombre, modelo_potencia, modelo_tipo_motor, modelo_tipo_transmision, modelo_tipo_auto, modelo_tipo_caja)
SELECT DISTINCT MODELO_CODIGO, MODELO_NOMBRE, MODELO_POTENCIA, TIPO_MOTOR_CODIGO,
                TIPO_TRANSMISION_CODIGO, TIPO_AUTO_CODIGO, TIPO_CAJA_CODIGO  
FROM gd_esquema.MAESTRA
WHERE TIPO_MOTOR_CODIGO IS NOT NULL
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_cliente' AND type='p')
	DROP PROCEDURE GDD.migrar_cliente
GO

CREATE PROCEDURE GDD.migrar_cliente
AS
INSERT INTO GDD.CLIENTE(clie_nombre, clie_apellido, clie_direccion, clie_dni, clie_mail, clie_fecha_nac)
SELECT DISTINCT CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_DNI, CLIENTE_MAIL, CLIENTE_FECHA_NAC
FROM gd_esquema.MAESTRA
WHERE CLIENTE_DNI IS NOT NULL
UNION
SELECT DISTINCT FAC_CLIENTE_NOMBRE, FAC_CLIENTE_APELLIDO, FAC_CLIENTE_DIRECCION, FAC_CLIENTE_DNI, FAC_CLIENTE_MAIL, FAC_CLIENTE_FECHA_NAC
FROM gd_esquema.MAESTRA
WHERE FAC_CLIENTE_DNI IS NOT NULL
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_factura' AND type='p')
	DROP PROCEDURE GDD.migrar_factura
GO

CREATE PROCEDURE GDD.migrar_factura
AS
INSERT INTO GDD.FACTURA(factura_numero, factura_clie, factura_fecha, factura_total)
SELECT DISTINCT FACTURA_NRO, (SELECT clie_id FROM GDD.CLIENTE WHERE clie_dni = A.FAC_CLIENTE_DNI AND clie_apellido = A.FAC_CLIENTE_APELLIDO), 
       A.FACTURA_FECHA, SUM(A.PRECIO_FACTURADO)
FROM gd_esquema.MAESTRA A
WHERE FACTURA_NRO IS NOT NULL
GROUP BY FACTURA_NRO, FACTURA_FECHA, FAC_CLIENTE_APELLIDO, FAC_CLIENTE_DNI
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_sucursal' AND type='p')
	DROP PROCEDURE GDD.migrar_sucursal
GO

CREATE PROCEDURE GDD.migrar_sucursal
AS
INSERT INTO GDD.SUCURSAL(sucursal_ciudad, sucursal_direccion, sucursal_mail, sucursal_telefono)
SELECT DISTINCT SUCURSAL_CIUDAD, SUCURSAL_DIRECCION, SUCURSAL_MAIL, SUCURSAL_TELEFONO
FROM gd_esquema.MAESTRA
WHERE SUCURSAL_CIUDAD IS NOT NULL
UNION
SELECT DISTINCT FAC_SUCURSAL_CIUDAD, FAC_SUCURSAL_DIRECCION, FAC_SUCURSAL_MAIL, FAC_SUCURSAL_TELEFONO
FROM gd_esquema.MAESTRA
WHERE FAC_SUCURSAL_CIUDAD IS NOT NULL
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_fabricante' AND type='p')
	DROP PROCEDURE GDD.migrar_fabricante
GO

CREATE PROCEDURE GDD.migrar_fabricante
AS
INSERT INTO GDD.FABRICANTE(fabricante_nombre)
SELECT DISTINCT FABRICANTE_NOMBRE
FROM gd_esquema.MAESTRA
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_auto_parte' AND type='p')
	DROP PROCEDURE GDD.migrar_auto_parte
GO

CREATE PROCEDURE GDD.migrar_auto_parte
AS
INSERT INTO GDD.AUTO_PARTE(auto_parte_id, auto_parte_descripcion,auto_parte_fabricante, auto_parte_modelo)
SELECT DISTINCT M.AUTO_PARTE_CODIGO, M.AUTO_PARTE_DESCRIPCION, (SELECT fabricante_id FROM GDD.FABRICANTE WHERE fabricante_nombre = M.FABRICANTE_NOMBRE),
       (SELECT modelo_codigo FROM GDD.MODELO WHERE modelo_codigo = M.MODELO_CODIGO)
FROM gd_esquema.MAESTRA M
WHERE M.AUTO_PARTE_DESCRIPCION is NOT NULL
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_auto' AND type='p')
	DROP PROCEDURE GDD.migrar_auto
GO

CREATE PROCEDURE GDD.migrar_auto
AS
INSERT INTO GDD.AUTO(auto_cant_kms, auto_compra, auto_fecha_alta, auto_modelo, auto_nro_chasis, auto_nro_motor, auto_patente)
SELECT DISTINCT M.AUTO_CANT_KMS, (SELECT compra_id FROM GDD.COMPRA WHERE compra_numero = M.COMPRA_NRO),  
       M.AUTO_FECHA_ALTA, M.MODELO_CODIGO, M.AUTO_NRO_CHASIS, M.AUTO_NRO_MOTOR, M.AUTO_PATENTE
FROM gd_esquema.MAESTRA M
WHERE M.AUTO_PARTE_CODIGO is NULL
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_item_factura_auto' AND type='p')
	DROP PROCEDURE GDD.migrar_item_factura_auto
GO

CREATE PROCEDURE GDD.migrar_item_factura_auto
AS
INSERT INTO GDD.ITEM_FACTURA_AUTO(item_factura_auto_factura, auto, item_factura_auto_precio)
SELECT (SELECT factura_id FROM GDD.FACTURA WHERE factura_numero = M.FACTURA_NRO),
       (SELECT auto_id FROM GDD.AUTO WHERE auto_nro_motor = M.AUTO_NRO_MOTOR AND M.FACTURA_NRO IS NOT NULL), M.PRECIO_FACTURADO
FROM gd_esquema.MAESTRA M
WHERE M.AUTO_PARTE_CODIGO is NULL AND M.FACTURA_NRO IS NOT NULL
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_compras' AND type='p')
	DROP PROCEDURE GDD.migrar_compras
GO

CREATE PROCEDURE GDD.migrar_compras
AS
INSERT INTO GDD.COMPRA(compra_clie,compra_fecha, compra_numero, compra_precio, compra_sucursal)
SELECT DISTINCT (SELECT clie_id FROM GDD.Cliente WHERE M.CLIENTE_DNI = clie_dni AND M.CLIENTE_APELLIDO = clie_apellido),
       M.COMPRA_FECHA, M.COMPRA_NRO, SUM(M.COMPRA_PRECIO), (SELECT sucursal_id from GDD.SUCURSAL where M.SUCURSAL_CIUDAD = sucursal_ciudad AND M.SUCURSAL_DIRECCION = sucursal_direccion)        
FROM gd_esquema.MAESTRA M
WHERE COMPRA_NRO IS NOT NULL
GROUP BY M.COMPRA_FECHA, M.COMPRA_NRO, M.CLIENTE_DNI, M.CLIENTE_APELLIDO, M.SUCURSAL_CIUDAD, M.SUCURSAL_DIRECCION
ORDER BY COMPRA_NRO
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_item_compra' AND type='p')
	DROP PROCEDURE GDD.migrar_item_compra
GO

CREATE PROCEDURE GDD.migrar_item_compra
AS
INSERT INTO GDD.ITEM_COMPRA(item_compra_auto_parte, item_compra_cant, item_compra_precio, compra)
SELECT DISTINCT (SELECT auto_parte_id FROM GDD.AUTO_PARTE WHERE auto_parte_id = M.AUTO_PARTE_CODIGO), M.COMPRA_CANT, COMPRA_PRECIO,
       (SELECT compra_id FROM GDD.COMPRA WHERE compra_numero = M.COMPRA_NRO)
FROM gd_esquema.MAESTRA M
WHERE COMPRA_CANT IS NOT NULL
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_item_factura' AND type='p')
	DROP PROCEDURE GDD.migrar_item_factura
GO

CREATE PROCEDURE GDD.migrar_item_factura
AS
INSERT INTO GDD.ITEM_FACTURA(item_cantidad, item_factura_auto_parte, factura, item_precio)
SELECT M.CANT_FACTURADA, (SELECT auto_parte_id FROM GDD.AUTO_PARTE WHERE auto_parte_id = M.AUTO_PARTE_CODIGO),
       (SELECT factura_id FROM GDD.FACTURA WHERE factura_numero = M.FACTURA_NRO), M.PRECIO_FACTURADO
FROM gd_esquema.MAESTRA M
WHERE M.AUTO_PARTE_CODIGO IS NOT NULL AND M.PRECIO_FACTURADO IS NOT NULL
GO


IF EXISTS (SELECT name FROM sysobjects WHERE name='migrar_maestra' AND type='p')
	DROP PROCEDURE GDD.migrar_maestra
GO

CREATE PROCEDURE GDD.migrar_maestra
AS
EXEC GDD.migrar_tipo_auto
EXEC GDD.migrar_tipo_motor
EXEC GDD.migrar_tipo_caja
EXEC GDD.migrar_tipo_transmision
EXEC GDD.migrar_modelo
EXEC GDD.migrar_cliente
EXEC GDD.migrar_factura
EXEC GDD.migrar_sucursal
EXEC GDD.migrar_fabricante
EXEC GDD.migrar_compras
EXEC GDD.migrar_auto_parte
EXEC GDD.migrar_auto
EXEC GDD.migrar_item_compra
EXEC GDD.migrar_item_factura
EXEC GDD.migrar_item_factura_auto
GO


EXEC GDD.migrar_maestra

/*
select * from GDD.TIPO_AUTO
select * from GDD.COMPRA
select * from GDD.AUTO
select * from GDD.AUTO_PARTE
select * from GDD.ITEM_COMPRA
select * from GDD.ITEM_FACTURA
select * from GDD.ITEM_FACTURA_AUTO
select * from GDD.FACTURA
select * from GDD.SUCURSAL
*/