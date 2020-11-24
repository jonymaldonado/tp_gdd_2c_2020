USE GD2C2020
GO 

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

CREATE FUNCTION GDD.CALCULAR_POTENCIA(@potencia INT)
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
	mode_tipo_caja decimal(18,0),
	mode_tipo_auto decimal(18,0),
	mode_tipo_motor decimal(18,0),
	mode_tipo_transmision decimal(18,0),
	mode_nombre nvarchar(255) null,
	mode_potencia decimal(18,0) null
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
