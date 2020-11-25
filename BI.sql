USE GD2C2020
GO 

--DROP TABLES
DROP TABLE 

--

--Funciones Auxiliares
CREATE FUNCTION GDD.CALCULAR_EDAD(@fecha_nac DATETIME2(3))
RETURNS INT
AS
BEGIN
	RETURN FLOOR(DATEDIFF(DAY, @fecha_nac, GETDATE()) / 365.25)
END
GO

CREATE FUNCTION GDD.CALCULAR_RANGO_EDAD(@edad INT)
RETURNS NVARCHAR(50)
AS
BEGIN
	RETURN CASE WHEN @edad < 18 THEN '< 18 años'
		WHEN @edad >= 18 AND @edad < 30 THEN '18-30 años'
		WHEN @edad >= 31 AND @edad < 50 THEN '31-50 años'
		ELSE '> 50 años' END
END
GO

CREATE FUNCTION GDD.CALCULAR_POTENCIA(@potencia DECIMAL(18,0))
RETURNS NVARCHAR(50)
AS
BEGIN
	RETURN CASE WHEN @potencia < 50 THEN '< 50cv'
		WHEN @potencia >= 50 AND @potencia < 150 THEN '50-150cv'
		WHEN @potencia >= 151 AND @potencia < 300 THEN '151-300cv'
		ELSE '> 300cv' END
END
GO


--Creación de tablas para dimensiones 

CREATE TABLE GDD.BI_Dim_Tiempo (
	tiem_id INT IDENTITY(1,1) NOT NULL,
	tiem_anio NUMERIC(4) NOT NULL,
	tiem_mes NUMERIC(2) NOT NULL
)
GO

CREATE TABLE GDD.BI_Dim_Cliente(
	clie_id INT IDENTITY(1,1) NOT NULL,
	clie_edad NVARCHAR(50) NOT NULL,
	clie_sexo NVARCHAR(1) NULL
)
GO

CREATE TABLE GDD.BI_Dim_Sucursal(
	sucu_id INT IDENTITY(1,1) NOT NULL,
	sucu_telefono DECIMAL(18,0) NULL,
	sucu_direccion NVARCHAR(255) NULL,
	sucu_ciudad NVARCHAR(255) NULL,
	sucu_mail NVARCHAR(255) NULL
)
GO

-->------------Checkear esto---------------------<--
CREATE TABLE GDD.BI_Dim_Modelo(
	mode_codigo decimal(18,0) not null,
	--mode_tipo_caja decimal(18,0),
	--mode_tipo_auto decimal(18,0),
	--mode_tipo_motor decimal(18,0),
	--mode_tipo_transmision decimal(18,0),
	mode_nombre nvarchar(255) null,
	--mode_potencia decimal(18,0) null
)
GO

CREATE TABLE GDD.BI_Dim_Fabricante(
	fabr_id int identity(1,1) not null,
	fabr_nombre nvarchar(255) null
)
GO

CREATE TABLE GDD.BI_Dim_TipoAutomovil(
	tipoAutomovil_id decimal(18,0) not null,
	tipoAutomovil_desc nvarchar(255) null
)
GO

CREATE TABLE GDD.BI_Dim_TipoCajaCambios(
	tipoCaja_id decimal(18,0) not null,
	tipoCaja_desc nvarchar(255) null
)
GO

CREATE TABLE GDD.BI_Dim_CantidadCambios(
	--TODO ???????
)
GO

CREATE TABLE GDD.BI_Dim_TipoMotor(
	tipoMotor_id decimal(18,0) not null,
	tipoMotor_desc nvarchar(255) null
)
GO

CREATE TABLE GDD.BI_Dim_TipoTransmision(
	tipoTransmision_id decimal(18,0) not null,
	tipoTransmision_desc nvarchar(255) null
)
GO

CREATE TABLE GDD.BI_Dim_Potencia(
	potencia_id decimal(18,0) not null,
	potencia_rango NVARCHAR(50) null
)
GO

CREATE TABLE GDD.BI_Dim_AutoParte(
	--TODO
)
GO

CREATE TABLE GDD.BI_Dim_RubroAutoParte(
	--TODO ?????????????
)
GO


--Creacion de Primary Keys

ALTER TABLE GDD.BI_Dim_Tiempo
ADD CONSTRAINT PK_Dim_Tiempo PRIMARY KEY(tiem_id)

ALTER TABLE GDD.BI_Dim_Cliente
ADD CONSTRAINT PK_Dim_Cliente PRIMARY KEY(clie_id)

ALTER TABLE GDD.BI_Dim_Sucursal
ADD CONSTRAINT PK_Dim_Sucursal PRIMARY KEY(sucu_id)

ALTER TABLE GDD.BI_Dim_Modelo
ADD CONSTRAINT PK_Dim_Modelo PRIMARY KEY(mode_codigo)

ALTER TABLE GDD.BI_Dim_Fabricante
ADD CONSTRAINT PK_Dim_Fabricante PRIMARY KEY(fabr_id)

ALTER TABLE GDD.BI_Dim_TipoAutomovil
ADD CONSTRAINT PK_Dim_TipoAutomovil PRIMARY KEY(tipoAutomovil_id)

ALTER TABLE GDD.BI_Dim_TipoCajaCambios
ADD CONSTRAINT PK_Dim_TipoCajaCambios PRIMARY KEY(tipoCaja_id)

--TODO
--ALTER TABLE BI_GDD.Dim_CantidadCambios
--ADD CONSTRAINT PK_Dim_CantidadCambios PRIMARY KEY()

ALTER TABLE GDD.BI_Dim_TipoMotor
ADD CONSTRAINT PK_Dim_TipoMotor PRIMARY KEY(tipoMotor_id)

ALTER TABLE GDD.BI_Dim_TipoTransmision
ADD CONSTRAINT PK_Dim_TipoTransmision PRIMARY KEY(tipoTransmision_id)

ALTER TABLE GDD.BI_Dim_Potencia
ADD CONSTRAINT PK_Dim_Potencia PRIMARY KEY(potencia_id)

--TODO
--ALTER TABLE GDD.BI_Dim_AutoParte
--ADD CONSTRAINT PK_Dim_AutoParte PRIMARY KEY()

--TODO
--ALTER TABLE GDD.BI_Dim_RubroAutoParte
--ADD CONSTRAINT PK_Dim_RubroAutoParte PRIMARY KEY()





--Creación de tablas para dimensiones hechos 

CREATE TABLE GDD.BI_Fact_Automoviles(
	tiempo INT not null,
	cliente INT not null,
	sucursal INT not null,
	modelo INT not null,
	--fabricante INT not null,
	tipoAutomovil INT not null,
	tipoCaja INT not null,
	--???cantidadCambios INT not null,
	tipoMotor INT not null,
	tipoTransmision INT not null,
	potencia INT not null,
	--autoParte INT not null,
	--rubro INT not null,

	cant_vendidos INT null,
	cant_comprados INT null,
	precio_promedio DECIMAL(18,2) null,
	ganancia DECIMAL(18,2) null
)
GO

ALTER TABLE GDD.BI_Fact_Automoviles
ADD CONSTRAINT PK_Fact_Automoviles 
PRIMARY KEY(	
	tiempo,
	cliente,
	sucursal,
	modelo,
	--fabricante,
	tipoAutomovil,
	tipoCaja,
	cantidadCambios,
	tipoMotor,
	tipoTransmision,
	potencia
	--autoParte,
	--rubro
)



--Carga de dimensiones

INSERT INTO GDD.BI_Dim_Cliente(clie_edad)
SELECT clie_id, GDD.CALCULAR_RANGO_EDAD(GDD.CALCULAR_EDAD(clie_fecha_nac)) FROM GDD.Cliente

INSERT INTO GDD.BI_Dim_Sucursal
SELECT * FROM GDD.SUCURSAL

--TODO INSERT MODELO
INSERT INTO GDD.BI_Dim_Modelo
SELECT modelo_codigo, modelo_nombre FROM GDD.MODELO

INSERT INTO GDD.BI_Dim_Fabricante
SELECT * FROM GDD.BI_Dim_Fabricante

INSERT INTO GDD.BI_Dim_TipoAutomovil
SELECT * FROM GDD.TIPO_AUTO

INSERT INTO GDD.BI_Dim_TipoCajaCambios
SELECT * FROM GDD.TIPO_CAJA

--TODO INSERT CANTIDAD CAMBIOS

INSERT INTO GDD.BI_Dim_TipoMotor
SELECT * FROM GDD.TIPO_MOTOR

INSERT INTO GDD.BI_Dim_TipoTransmision
SELECT * FROM GDD.TIPO_TRANSMISION

INSERT INTO GDD.BI_Dim_Potencia VALUES('< 50cv')
INSERT INTO GDD.BI_Dim_Potencia VALUES('50-150cv')
INSERT INTO GDD.BI_Dim_Potencia VALUES('151-300cv')
INSERT INTO GDD.BI_Dim_Potencia VALUES('> 300cv')

--TODO INSERT AUTO PARTE

--TODO INSERT RUBRO AUTO PARTE

SELECT FACTURA_FECHA FROM gd_esquema.Maestra
order by FACTURA_FECHA


--Carga de hechos
INSERT INTO GDD.BI_Fact_Automoviles


SELECT 
	YEAR(F.factura_fecha), 
	MONTH(F.factura_fecha),
	DC.clie_id,
	DS.sucu_id,
	DM.mode_codigo,
	DTA.tipoAutomovil_id,
	DTC.tipoCaja_id,
	DTM.tipoMotor_id,
	DTT.tipoTransmision_id,
	DP.potencia_id



FROM GDD.AUTO A
	JOIN GDD.COMPRA C ON C.compra_id = A.auto_compra
	JOIN GDD.ITEM_FACTURA_AUTO I ON I.auto = A.auto_id
	JOIN GDD.FACTURA F ON F.factura_id = I.item_factura_auto_factura
	JOIN GDD.BI_Dim_Cliente DC ON DC.clie_id = F.factura_clie
	JOIN GDD.BI_Dim_Sucursal DS ON DS.sucu_id = C.compra_sucursal
	JOIN GDD.MODELO M ON M.modelo_codigo = A.auto_modelo
	JOIN GDD.BI_Dim_Modelo DM ON DM.mode_codigo = M.modelo_codigo
	JOIN GDD.BI_Dim_TipoAutomovil DTA ON DTA.tipoAutomovil_id = M.modelo_tipo_auto
	JOIN GDD.BI_Dim_TipoCajaCambios DTC ON DTC.tipoCaja_id = M.modelo_tipo_caja
	JOIN GDD.BI_Dim_TipoMotor DTM ON DTM.tipoMotor_id = M.modelo_tipo_motor
	JOIN GDD.BI_Dim_TipoTransmision DTT ON DTT.tipoTransmision_id = M.modelo_tipo_transmision
	JOIN GDD.BI_Dim_Potencia DP ON DP.potencia_rango = GDD.CALCULAR_POTENCIA(M.modelo_potencia)

GROUP BY YEAR(F.factura_fecha), MONTH(F.factura_fecha), DC.clie_id, DS.sucu_id, DM.mode_codigo,
	DTA.tipoAutomovil_id, DTC.tipoCaja_id, DTM.tipoMotor_id, DTT.tipoTransmision_id, DP.potencia_id




































