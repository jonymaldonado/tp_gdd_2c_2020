USE GD2C2020
GO
 
--script_creacion_BI

-----------------------------------------DROP TABLES-----------------------------------------
CREATE PROCEDURE GDD.DROP_TABLES
AS BEGIN
	
	DROP PROCEDURE GDD.CREAR_DIMENSIONES
	DROP PROCEDURE GDD.CREAR_HECHOS
	DROP PROCEDURE GDD.CREAR_PK
	DROP PROCEDURE GDD.CREAR_FK
	DROP PROCEDURE GDD.CARGAR_DIMENSIONES
	DROP PROCEDURE GDD.CARGAR_HECHOS_AUTOMOVILES
	DROP PROCEDURE GDD.CARGAR_HECHOS_AUTO_PARTES

	DROP TABLE GDD.BI_Fact_Compra_Automoviles

	DROP TABLE GDD.BI_Fact_Ventas_Automoviles

	DROP TABLE GDD.BI_Fact_Compra_Auto_Partes

	DROP TABLE GDD.BI_Fact_Ventas_Auto_Partes
	

	DROP TABLE GDD.BI_Dim_Tiempo

	DROP TABLE GDD.BI_Dim_Cliente

	DROP TABLE GDD.BI_Dim_Sucursal

	DROP TABLE GDD.BI_Dim_Modelo

	DROP TABLE GDD.BI_Dim_Fabricante

	DROP TABLE GDD.BI_Dim_TipoAutomovil

	DROP TABLE GDD.BI_Dim_TipoCajaCambios

	--TODO
	--DROP TABLE BI_GDD.Dim_CantidadCambios

	DROP TABLE GDD.BI_Dim_TipoMotor

	DROP TABLE GDD.BI_Dim_TipoTransmision

	DROP TABLE GDD.BI_Dim_Potencia

	DROP TABLE GDD.BI_Dim_AutoParte

	--TODO
	--DROP TABLE GDD.BI_Dim_RubroAutoParte


	DROP FUNCTION GDD.CALCULAR_EDAD
	DROP FUNCTION GDD.CALCULAR_RANGO_EDAD
	DROP FUNCTION GDD.CALCULAR_POTENCIA
END
GO

--DROP PROCEDURE GDD.DROP_TABLES
--EXEC GDD.DROP_TABLES


-----------------------------------------Funciones Auxiliares-----------------------------------------

CREATE FUNCTION GDD.CALCULAR_EDAD(@fecha_nac DATETIME2(3))
RETURNS INT
AS BEGIN
	RETURN FLOOR(DATEDIFF(DAY, @fecha_nac, GETDATE()) / 365.25)
END
GO

CREATE FUNCTION GDD.CALCULAR_RANGO_EDAD(@edad INT)
RETURNS NVARCHAR(50)
AS BEGIN
	RETURN CASE WHEN @edad < 18 THEN '< 18 años'
		WHEN @edad >= 18 AND @edad < 30 THEN '18-30 años'
		WHEN @edad >= 31 AND @edad < 50 THEN '31-50 años'
		ELSE '> 50 años' END
END
GO

CREATE FUNCTION GDD.CALCULAR_POTENCIA(@potencia DECIMAL(18,0))
RETURNS NVARCHAR(50)
AS BEGIN
	RETURN CASE WHEN @potencia < 50 THEN '< 50cv'
		WHEN @potencia >= 50 AND @potencia < 150 THEN '50-150cv'
		WHEN @potencia >= 151 AND @potencia < 300 THEN '151-300cv'
		ELSE '> 300cv' END
END
GO

-----------------------------------------Creación de tablas para dimensiones-----------------------------------------
CREATE PROCEDURE GDD.CREAR_DIMENSIONES
AS BEGIN
	CREATE TABLE GDD.BI_Dim_Tiempo (
		tiem_id INT IDENTITY(1,1) NOT NULL,
		tiem_anio NUMERIC(4) NOT NULL,
		tiem_mes NUMERIC(2) NOT NULL
	)

	CREATE TABLE GDD.BI_Dim_Cliente(
		clie_id INT NOT NULL,
		clie_edad NVARCHAR(50) NOT NULL,
		clie_sexo NVARCHAR(1) NULL
	)

	CREATE TABLE GDD.BI_Dim_Sucursal(
		sucu_id INT NOT NULL,
		sucu_telefono DECIMAL(18,0) NULL,
		sucu_direccion NVARCHAR(255) NULL,
		sucu_ciudad NVARCHAR(255) NULL,
		sucu_mail NVARCHAR(255) NULL
	)

	CREATE TABLE GDD.BI_Dim_Modelo(
		mode_codigo decimal(18,0) not null,
		mode_nombre nvarchar(255) null,
	)

	CREATE TABLE GDD.BI_Dim_Fabricante(
		fabr_id int not null,
		fabr_nombre nvarchar(255) null
	)

	CREATE TABLE GDD.BI_Dim_TipoAutomovil(
		tipoAutomovil_id decimal(18,0) not null,
		tipoAutomovil_desc nvarchar(255) null
	)

	CREATE TABLE GDD.BI_Dim_TipoCajaCambios(
		tipoCaja_id decimal(18,0) not null,
		tipoCaja_desc nvarchar(255) null
	)

	--CREATE TABLE GDD.BI_Dim_CantidadCambios(
		--TODO ???????
	--)

	CREATE TABLE GDD.BI_Dim_TipoMotor(
		tipoMotor_id decimal(18,0) not null,
		tipoMotor_desc nvarchar(255) null
	)

	CREATE TABLE GDD.BI_Dim_TipoTransmision(
		tipoTransmision_id decimal(18,0) not null,
		tipoTransmision_desc nvarchar(255) null
	)

	CREATE TABLE GDD.BI_Dim_Potencia(
		potencia_id decimal(18,0) identity(1,1) not null,
		potencia_rango NVARCHAR(50) null
	)

	CREATE TABLE GDD.BI_Dim_AutoParte(
		autoParte_id decimal(18,0) not null,
		autoParte_descripcion nvarchar(255) null,
		autoParte_fabricante int null,
		autoParte_modelo decimal(18,0) null
	)

	--CREATE TABLE GDD.BI_Dim_RubroAutoParte(
		--TODO ?????????????
	--)
END
GO


-----------------------------------------Creación de tablas para dimensiones hechos-----------------------------------------
CREATE PROCEDURE GDD.CREAR_HECHOS
AS BEGIN
	CREATE TABLE GDD.BI_Fact_Compra_Automoviles(
		tiempo INT not null,
		cliente INT not null,
		sucursal INT not null,
		modelo decimal(18,0) not null,
		tipoAutomovil decimal(18,0) not null,
		tipoCaja decimal(18,0) not null,
		--???cantidadCambios INT not null,
		tipoMotor decimal(18,0) not null,
		tipoTransmision decimal(18,0) not null,
		potencia decimal(18,0) not null,

		cant_comprados INT null,
		precio_promedio_comprados decimal(18,2) null,
	)

	CREATE TABLE GDD.BI_Fact_Ventas_Automoviles(
		tiempo INT not null,
		cliente INT not null,
		sucursal INT not null,
		modelo decimal(18,0) not null,
		tipoAutomovil decimal(18,0) not null,
		tipoCaja decimal(18,0) not null,
		--???cantidadCambios INT not null,
		tipoMotor decimal(18,0) not null,
		tipoTransmision decimal(18,0) not null,
		potencia decimal(18,0) not null,

		cant_vendidos INT null,
		precio_promedio_vendidos decimal(18,2) null,
		ganancia decimal(18,2) null,
		promedio_tiempo_en_stock decimal(18,2) null
	)

	CREATE TABLE GDD.BI_Fact_Compra_Auto_Partes(
		tiempo INT not null,
		cliente INT not null,
		sucursal INT not null,
		modelo decimal(18,0) not null,
		tipoAutomovil decimal(18,0) not null,
		tipoCaja decimal(18,0) not null,
		--???cantidadCambios INT not null,
		tipoMotor decimal(18,0) not null,
		tipoTransmision decimal(18,0) not null,
		potencia decimal(18,0) not null,
		autoParte decimal(18,0) not null,
		fabricante int not null,

		precio_promedio_comprado decimal(18,2) null,
		stock int null
	)

		CREATE TABLE GDD.BI_Fact_Ventas_Auto_Partes(
		tiempo INT not null,
		cliente INT not null,
		sucursal INT not null,
		modelo decimal(18,0) not null,
		tipoAutomovil decimal(18,0) not null,
		tipoCaja decimal(18,0) not null,
		--???cantidadCambios INT not null,
		tipoMotor decimal(18,0) not null,
		tipoTransmision decimal(18,0) not null,
		potencia decimal(18,0) not null,
		autoParte decimal(18,0) not null,
		fabricante int not null,

		precio_promedio_vendido decimal(18,2) null,
		ganancia decimal(18,2) null,
		promedio_tiempo_en_stock decimal(18,2) null,
		stock int null
	)
END
GO


-----------------------------------------Creacion de Primary Keys-----------------------------------------
CREATE PROCEDURE GDD.CREAR_PK
AS BEGIN

	ALTER TABLE GDD.BI_Fact_Compra_Automoviles
	ADD CONSTRAINT PK_Fact_Compra_Automoviles
		PRIMARY KEY(tiempo, cliente, sucursal, modelo, tipoAutomovil, tipoCaja, tipoMotor, tipoTransmision, potencia)
	
	ALTER TABLE GDD.BI_Fact_Ventas_Automoviles
	ADD CONSTRAINT PK_Fact_Venta_Automoviles 
		PRIMARY KEY(tiempo, cliente, sucursal, modelo, tipoAutomovil, tipoCaja, tipoMotor, tipoTransmision, potencia)

	ALTER TABLE GDD.BI_Fact_Compra_Auto_Partes
	ADD CONSTRAINT PK_Fact_Compra_Auto_Partes 
		PRIMARY KEY(tiempo, cliente, sucursal, modelo, tipoAutomovil, tipoCaja, tipoMotor, tipoTransmision, potencia, autoParte, fabricante)

	ALTER TABLE GDD.BI_Fact_Ventas_Auto_Partes
	ADD CONSTRAINT PK_Fact_Ventas_Auto_Partes
		PRIMARY KEY(tiempo, cliente, sucursal, modelo, tipoAutomovil, tipoCaja, tipoMotor, tipoTransmision, potencia, autoParte, fabricante)

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

	ALTER TABLE GDD.BI_Dim_AutoParte
	ADD CONSTRAINT PK_Dim_AutoParte PRIMARY KEY(autoParte_id)

	--TODO
	--ALTER TABLE GDD.BI_Dim_RubroAutoParte
	--ADD CONSTRAINT PK_Dim_RubroAutoParte PRIMARY KEY()
END
GO


-----------------------------------------Creacion de Foreign Keys-----------------------------------------
CREATE PROCEDURE GDD.CREAR_FK
AS BEGIN
	--Compra Automoviles--------------------------------
	ALTER TABLE GDD.BI_Fact_Compra_Automoviles
	ADD CONSTRAINT FK_Fact_Compra_Automoviles_Tiempo FOREIGN KEY(tiempo) REFERENCES GDD.BI_Dim_Tiempo(tiem_id)

	ALTER TABLE GDD.BI_Fact_Compra_Automoviles
	ADD CONSTRAINT FK_Fact_Compra_Automoviles_Cliente FOREIGN KEY(cliente) REFERENCES GDD.BI_Dim_Cliente(clie_id)

	ALTER TABLE GDD.BI_Fact_Compra_Automoviles
	ADD CONSTRAINT FK_Fact_Compra_Automoviles_Sucursal FOREIGN KEY(sucursal) REFERENCES GDD.BI_Dim_Sucursal(sucu_id)

	ALTER TABLE GDD.BI_Fact_Compra_Automoviles
	ADD CONSTRAINT FK_Fact_Compra_Automoviles_Modelo FOREIGN KEY(modelo) REFERENCES GDD.BI_Dim_Modelo(mode_codigo)

	ALTER TABLE GDD.BI_Fact_Compra_Automoviles
	ADD CONSTRAINT FK_Fact_Compra_Automoviles_TipoAutomovil FOREIGN KEY(tipoAutomovil) REFERENCES GDD.BI_Dim_TipoAutomovil(tipoAutomovil_id)

	ALTER TABLE GDD.BI_Fact_Compra_Automoviles
	ADD CONSTRAINT FK_Fact_Compra_Automoviles_TipoCaja FOREIGN KEY(tipoCaja) REFERENCES GDD.BI_Dim_TipoCajaCambios(tipoCaja_id)

	--TODO: FK cantidad cambios

	ALTER TABLE GDD.BI_Fact_Compra_Automoviles
	ADD CONSTRAINT FK_Fact_Compra_Automoviles_TipoTransmision FOREIGN KEY(tipoTransmision) REFERENCES GDD.BI_Dim_TipoTransmision(tipoTransmision_id)

	ALTER TABLE GDD.BI_Fact_Compra_Automoviles
	ADD CONSTRAINT FK_Fact_Compra_Automoviles_TipoMotor FOREIGN KEY(tipoMotor) REFERENCES GDD.BI_Dim_TipoMotor(tipoMotor_id)

	ALTER TABLE GDD.BI_Fact_Compra_Automoviles
	ADD CONSTRAINT FK_Fact_Compra_Automoviles_Potencia FOREIGN KEY(potencia) REFERENCES GDD.BI_Dim_Potencia(potencia_id)



	--Venta Automoviles--------------------------------
	ALTER TABLE GDD.BI_Fact_Ventas_Automoviles
	ADD CONSTRAINT FK_Fact_Venta_Automoviles_Tiempo FOREIGN KEY(tiempo) REFERENCES GDD.BI_Dim_Tiempo(tiem_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Automoviles
	ADD CONSTRAINT FK_Fact_Venta_Automoviles_Cliente FOREIGN KEY(cliente) REFERENCES GDD.BI_Dim_Cliente(clie_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Automoviles
	ADD CONSTRAINT FK_Fact_Venta_Automoviles_Sucursal FOREIGN KEY(sucursal) REFERENCES GDD.BI_Dim_Sucursal(sucu_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Automoviles
	ADD CONSTRAINT FK_Fact_Venta_Automoviles_Modelo FOREIGN KEY(modelo) REFERENCES GDD.BI_Dim_Modelo(mode_codigo)

	ALTER TABLE GDD.BI_Fact_Ventas_Automoviles
	ADD CONSTRAINT FK_Fact_Venta_Automoviles_TipoAutomovil FOREIGN KEY(tipoAutomovil) REFERENCES GDD.BI_Dim_TipoAutomovil(tipoAutomovil_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Automoviles
	ADD CONSTRAINT FK_Fact_Venta_Automoviles_TipoCaja FOREIGN KEY(tipoCaja) REFERENCES GDD.BI_Dim_TipoCajaCambios(tipoCaja_id)

	--TODO: FK cantidad cambios

	ALTER TABLE GDD.BI_Fact_Ventas_Automoviles
	ADD CONSTRAINT FK_Fact_Venta_Automoviles_TipoTransmision FOREIGN KEY(tipoTransmision) REFERENCES GDD.BI_Dim_TipoTransmision(tipoTransmision_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Automoviles
	ADD CONSTRAINT FK_Fact_Venta_Automoviles_TipoMotor FOREIGN KEY(tipoMotor) REFERENCES GDD.BI_Dim_TipoMotor(tipoMotor_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Automoviles
	ADD CONSTRAINT FK_Fact_Venta_Automoviles_Potencia FOREIGN KEY(potencia) REFERENCES GDD.BI_Dim_Potencia(potencia_id)




	--Compra Auto Partes--------------------------------
	ALTER TABLE GDD.BI_Fact_Compra_Auto_Partes
	ADD CONSTRAINT FK_Fact_Compra_Auto_Partes_Tiempo FOREIGN KEY(tiempo) REFERENCES GDD.BI_Dim_Tiempo(tiem_id)

	ALTER TABLE GDD.BI_Fact_Compra_Auto_Partes
	ADD CONSTRAINT FK_Fact_Compra_Auto_Partes_Cliente FOREIGN KEY(cliente) REFERENCES GDD.BI_Dim_Cliente(clie_id)

	ALTER TABLE GDD.BI_Fact_Compra_Auto_Partes
	ADD CONSTRAINT FK_Fact_Compra_Auto_Partes_Sucursal FOREIGN KEY(sucursal) REFERENCES GDD.BI_Dim_Sucursal(sucu_id)

	ALTER TABLE GDD.BI_Fact_Compra_Auto_Partes
	ADD CONSTRAINT FK_Fact_Compra_Auto_Partes_Modelo FOREIGN KEY(modelo) REFERENCES GDD.BI_Dim_Modelo(mode_codigo)

	ALTER TABLE GDD.BI_Fact_Compra_Auto_Partes
	ADD CONSTRAINT FK_Fact_Compra_Auto_Partes_TipoAutomovil FOREIGN KEY(tipoAutomovil) REFERENCES GDD.BI_Dim_TipoAutomovil(tipoAutomovil_id)

	ALTER TABLE GDD.BI_Fact_Compra_Auto_Partes
	ADD CONSTRAINT FK_Fact_Compra_Auto_Partes_TipoCaja FOREIGN KEY(tipoCaja) REFERENCES GDD.BI_Dim_TipoCajaCambios(tipoCaja_id)

	--TODO: FK cantidad cambios

	ALTER TABLE GDD.BI_Fact_Compra_Auto_Partes
	ADD CONSTRAINT FK_Fact_Compra_Auto_Partes_TipoTransmision FOREIGN KEY(tipoTransmision) REFERENCES GDD.BI_Dim_TipoTransmision(tipoTransmision_id)

	ALTER TABLE GDD.BI_Fact_Compra_Auto_Partes
	ADD CONSTRAINT FK_Fact_Compra_Auto_Partes_TipoMotor FOREIGN KEY(tipoMotor) REFERENCES GDD.BI_Dim_TipoMotor(tipoMotor_id)

	ALTER TABLE GDD.BI_Fact_Compra_Auto_Partes
	ADD CONSTRAINT FK_Fact_Compra_Auto_Partes_Potencia FOREIGN KEY(potencia) REFERENCES GDD.BI_Dim_Potencia(potencia_id)

	ALTER TABLE GDD.BI_Fact_Compra_Auto_Partes
	ADD CONSTRAINT FK_Fact_Compra_Auto_Partes_AutoParte FOREIGN KEY(autoParte) REFERENCES GDD.BI_Dim_AutoParte(autoParte_id)

	ALTER TABLE GDD.BI_Fact_Compra_Auto_Partes
	ADD CONSTRAINT FK_Fact_Compra_Auto_Partes_Fabricante FOREIGN KEY(fabricante) REFERENCES GDD.BI_Dim_Fabricante(fabr_id)



		--Venta Auto Partes--------------------------------
	ALTER TABLE GDD.BI_Fact_Ventas_Auto_Partes
	ADD CONSTRAINT FK_Fact_Ventas_Auto_Partes_Tiempo FOREIGN KEY(tiempo) REFERENCES GDD.BI_Dim_Tiempo(tiem_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Auto_Partes
	ADD CONSTRAINT FK_Fact_Ventas_Auto_Partes_Cliente FOREIGN KEY(cliente) REFERENCES GDD.BI_Dim_Cliente(clie_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Auto_Partes
	ADD CONSTRAINT FK_Fact_Ventas_Auto_Partes_Sucursal FOREIGN KEY(sucursal) REFERENCES GDD.BI_Dim_Sucursal(sucu_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Auto_Partes
	ADD CONSTRAINT FK_Fact_Ventas_Auto_Partes_Modelo FOREIGN KEY(modelo) REFERENCES GDD.BI_Dim_Modelo(mode_codigo)

	ALTER TABLE GDD.BI_Fact_Ventas_Auto_Partes
	ADD CONSTRAINT FK_Fact_Ventas_Auto_Partes_TipoAutomovil FOREIGN KEY(tipoAutomovil) REFERENCES GDD.BI_Dim_TipoAutomovil(tipoAutomovil_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Auto_Partes
	ADD CONSTRAINT FK_Fact_Ventas_Auto_Partes_TipoCaja FOREIGN KEY(tipoCaja) REFERENCES GDD.BI_Dim_TipoCajaCambios(tipoCaja_id)

	--TODO: FK cantidad cambios

	ALTER TABLE GDD.BI_Fact_Ventas_Auto_Partes
	ADD CONSTRAINT FK_Fact_Ventas_Auto_Partes_TipoTransmision FOREIGN KEY(tipoTransmision) REFERENCES GDD.BI_Dim_TipoTransmision(tipoTransmision_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Auto_Partes
	ADD CONSTRAINT FK_Fact_Ventas_Auto_Partes_TipoMotor FOREIGN KEY(tipoMotor) REFERENCES GDD.BI_Dim_TipoMotor(tipoMotor_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Auto_Partes
	ADD CONSTRAINT FK_Fact_Ventas_Auto_Partes_Potencia FOREIGN KEY(potencia) REFERENCES GDD.BI_Dim_Potencia(potencia_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Auto_Partes
	ADD CONSTRAINT FK_Fact_Ventas_Auto_Partes_AutoParte FOREIGN KEY(autoParte) REFERENCES GDD.BI_Dim_AutoParte(autoParte_id)

	ALTER TABLE GDD.BI_Fact_Ventas_Auto_Partes
	ADD CONSTRAINT FK_Fact_Ventas_Auto_Partes_Fabricante FOREIGN KEY(fabricante) REFERENCES GDD.BI_Dim_Fabricante(fabr_id)


END
GO






-----------------------------------------Carga de dimensiones-----------------------------------------
CREATE PROCEDURE GDD.CARGAR_DIMENSIONES
AS BEGIN
	INSERT INTO GDD.BI_Dim_Tiempo
	SELECT YEAR(factura_fecha), MONTH(factura_fecha) from GDD.FACTURA
	UNION
	SELECT YEAR(compra_fecha), MONTH(compra_fecha) from GDD.COMPRA

	INSERT INTO GDD.BI_Dim_Cliente(clie_id, clie_edad)
	SELECT C.clie_id, GDD.CALCULAR_RANGO_EDAD(GDD.CALCULAR_EDAD(C.clie_fecha_nac)) FROM GDD.Cliente C

	INSERT INTO GDD.BI_Dim_Sucursal
	SELECT * FROM GDD.SUCURSAL

	--TODO INSERT MODELO
	INSERT INTO GDD.BI_Dim_Modelo
	SELECT modelo_codigo, modelo_nombre FROM GDD.MODELO

	INSERT INTO GDD.BI_Dim_Fabricante
	SELECT * FROM GDD.FABRICANTE

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

	INSERT INTO GDD.BI_Dim_AutoParte
	SELECT * FROM GDD.AUTO_PARTE

	--TODO INSERT RUBRO AUTO PARTE
END
GO

-----------------------------------------Carga de hechos-----------------------------------------
CREATE PROCEDURE GDD.CARGAR_HECHOS_AUTOMOVILES
AS BEGIN 
	--Compra Automoviles
	INSERT INTO GDD.BI_Fact_Compra_Automoviles
		SELECT 
			T.tiem_id,
			DC.clie_id,
			DS.sucu_id,
			DM.mode_codigo,
			DTA.tipoAutomovil_id,
			DTC.tipoCaja_id,
			DTM.tipoMotor_id,
			DTT.tipoTransmision_id,
			DP.potencia_id,

			COUNT(A.auto_compra), --cant_comprados
			AVG(C.compra_precio) --precio_promedio_comprados

		FROM GDD.AUTO A
			JOIN GDD.COMPRA C ON C.compra_id = A.auto_compra
		
			JOIN GDD.BI_Dim_Tiempo T ON T.tiem_anio = YEAR(C.compra_fecha) AND T.tiem_mes = MONTH(C.compra_fecha)
			JOIN GDD.BI_Dim_Cliente DC ON DC.clie_id = C.compra_clie
			JOIN GDD.BI_Dim_Sucursal DS ON DS.sucu_id = C.compra_sucursal
			JOIN GDD.MODELO M ON M.modelo_codigo = A.auto_modelo
			JOIN GDD.BI_Dim_Modelo DM ON DM.mode_codigo = M.modelo_codigo
				JOIN GDD.BI_Dim_TipoAutomovil DTA ON DTA.tipoAutomovil_id = M.modelo_tipo_auto
				JOIN GDD.BI_Dim_TipoCajaCambios DTC ON DTC.tipoCaja_id = M.modelo_tipo_caja
				JOIN GDD.BI_Dim_TipoMotor DTM ON DTM.tipoMotor_id = M.modelo_tipo_motor
				JOIN GDD.BI_Dim_TipoTransmision DTT ON DTT.tipoTransmision_id = M.modelo_tipo_transmision
			JOIN GDD.BI_Dim_Potencia DP ON DP.potencia_rango = GDD.CALCULAR_POTENCIA(M.modelo_potencia)

		GROUP BY T.tiem_id, DC.clie_id, DS.sucu_id, DM.mode_codigo,
			DTA.tipoAutomovil_id, DTC.tipoCaja_id, DTM.tipoMotor_id, DTT.tipoTransmision_id, DP.potencia_id



		--Venta Automoviles
		INSERT INTO GDD.BI_Fact_Ventas_Automoviles
		SELECT 
			T.tiem_id,
			DC.clie_id,
			DS.sucu_id,
			DM.mode_codigo,
			DTA.tipoAutomovil_id,
			DTC.tipoCaja_id,
			DTM.tipoMotor_id,
			DTT.tipoTransmision_id,
			DP.potencia_id,

			COUNT(I.auto), --cant_vendidos
			AVG(I.item_factura_auto_precio), --precio_promedio_vendidos
			SUM(I.item_factura_auto_precio - C.compra_precio), --decimal
			AVG(DATEDIFF(day, C.compra_fecha, F.factura_fecha)) --promedio_tiempo_en_stock

		FROM GDD.AUTO A
			JOIN GDD.ITEM_FACTURA_AUTO I ON I.auto = A.auto_id
			JOIN GDD.FACTURA F ON F.factura_id = I.item_factura_auto_factura
			LEFT JOIN GDD.COMPRA C ON C.compra_id = A.auto_compra
			
			JOIN GDD.BI_Dim_Tiempo T ON T.tiem_anio = YEAR(F.factura_fecha) AND T.tiem_mes = MONTH(F.factura_fecha)
			JOIN GDD.BI_Dim_Cliente DC ON DC.clie_id = F.factura_clie
			JOIN GDD.BI_Dim_Sucursal DS ON DS.sucu_id = C.compra_sucursal
			JOIN GDD.MODELO M ON M.modelo_codigo = A.auto_modelo
			JOIN GDD.BI_Dim_Modelo DM ON DM.mode_codigo = M.modelo_codigo
				JOIN GDD.BI_Dim_TipoAutomovil DTA ON DTA.tipoAutomovil_id = M.modelo_tipo_auto
				JOIN GDD.BI_Dim_TipoCajaCambios DTC ON DTC.tipoCaja_id = M.modelo_tipo_caja
				JOIN GDD.BI_Dim_TipoMotor DTM ON DTM.tipoMotor_id = M.modelo_tipo_motor
				JOIN GDD.BI_Dim_TipoTransmision DTT ON DTT.tipoTransmision_id = M.modelo_tipo_transmision
			JOIN GDD.BI_Dim_Potencia DP ON DP.potencia_rango = GDD.CALCULAR_POTENCIA(M.modelo_potencia)

		GROUP BY T.tiem_id, DC.clie_id, DS.sucu_id, DM.mode_codigo,
			DTA.tipoAutomovil_id, DTC.tipoCaja_id, DTM.tipoMotor_id, DTT.tipoTransmision_id, DP.potencia_id
END
GO


CREATE PROCEDURE GDD.CARGAR_HECHOS_AUTO_PARTES
AS BEGIN 
	
	INSERT INTO GDD.BI_Dim_Compra_AutoParte
	SELECT
			T.tiem_id,
			DC.clie_id,
			DS.sucu_id,
			DM.mode_codigo,
			DTA.tipoAutomovil_id,
			DTC.tipoCaja_id,
			DTM.tipoMotor_id,
			DTT.tipoTransmision_id,
			DP.potencia_id,
			A.autoParte_id,
			DF.fabr_id,

			AVG(IC.item_compra_precio),
			SUM(IC.item_compra_cant)

	FROM GDD.BI_Dim_AutoParte A
		JOIN GDD.ITEM_COMPRA IC ON IC.item_compra_auto_parte = A.autoParte_id
		JOIN GDD.COMPRA C ON C.compra_id = IC.compra

		JOIN GDD.BI_Dim_Tiempo T ON T.tiem_anio = YEAR(C.compra_fecha) AND T.tiem_mes = MONTH(C.compra_fecha)
			JOIN GDD.BI_Dim_Cliente DC ON DC.clie_id = C.compra_clie
			JOIN GDD.BI_Dim_Sucursal DS ON DS.sucu_id = C.compra_sucursal
			JOIN GDD.MODELO M ON M.modelo_codigo = A.autoParte_modelo
			JOIN GDD.BI_Dim_Modelo DM ON DM.mode_codigo = M.modelo_codigo
				JOIN GDD.BI_Dim_TipoAutomovil DTA ON DTA.tipoAutomovil_id = M.modelo_tipo_auto
				JOIN GDD.BI_Dim_TipoCajaCambios DTC ON DTC.tipoCaja_id = M.modelo_tipo_caja
				JOIN GDD.BI_Dim_TipoMotor DTM ON DTM.tipoMotor_id = M.modelo_tipo_motor
				JOIN GDD.BI_Dim_TipoTransmision DTT ON DTT.tipoTransmision_id = M.modelo_tipo_transmision
			JOIN GDD.BI_Dim_Potencia DP ON DP.potencia_rango = GDD.CALCULAR_POTENCIA(M.modelo_potencia)
			JOIN GDD.BI_Dim_Fabricante DF ON DF.fabr_id = A.autoParte_fabricante

		GROUP BY T.tiem_id, DC.clie_id, DS.sucu_id, DM.mode_codigo, DTA.tipoAutomovil_id, DTC.tipoCaja_id, 
			DTM.tipoMotor_id, DTT.tipoTransmision_id, DP.potencia_id, A.autoParte_id, DF.fabr_id


	INSERT INTO GDD.BI_Fact_Ventas_Auto_Partes
	SELECT
			T.tiem_id,
			DC.clie_id,
			DS.sucu_id,
			DM.mode_codigo,
			DTA.tipoAutomovil_id,
			DTC.tipoCaja_id,
			DTM.tipoMotor_id,
			DTT.tipoTransmision_id,
			DP.potencia_id,
			A.autoParte_id,
			DF.fabr_id,

			AVG(I.item_precio),
			SUM(I.item_precio - IC.item_compra_precio),
			ABS(AVG(DATEDIFF(day, C.compra_fecha, F.factura_fecha))),
			SUM(I.item_cantidad)

	FROM GDD.BI_Dim_AutoParte A
		JOIN GDD.ITEM_FACTURA I ON I.item_factura_auto_parte = A.autoParte_id
		JOIN GDD.FACTURA F ON F.factura_id = I.factura
		JOIN GDD.ITEM_COMPRA IC ON IC.item_compra_auto_parte = A.autoParte_id
		JOIN GDD.COMPRA C ON C.compra_id = IC.compra AND C.compra_sucursal = F.factura_sucursal

		JOIN GDD.BI_Dim_Tiempo T ON T.tiem_anio = YEAR(F.factura_fecha) AND T.tiem_mes = MONTH(F.factura_fecha)
		JOIN GDD.BI_Dim_Cliente DC ON DC.clie_id = F.factura_clie
		JOIN GDD.BI_Dim_Sucursal DS ON DS.sucu_id = F.factura_sucursal
		JOIN GDD.MODELO M ON M.modelo_codigo = A.autoParte_modelo
		JOIN GDD.BI_Dim_Modelo DM ON DM.mode_codigo = M.modelo_codigo
			JOIN GDD.BI_Dim_TipoAutomovil DTA ON DTA.tipoAutomovil_id = M.modelo_tipo_auto
			JOIN GDD.BI_Dim_TipoCajaCambios DTC ON DTC.tipoCaja_id = M.modelo_tipo_caja
			JOIN GDD.BI_Dim_TipoMotor DTM ON DTM.tipoMotor_id = M.modelo_tipo_motor
			JOIN GDD.BI_Dim_TipoTransmision DTT ON DTT.tipoTransmision_id = M.modelo_tipo_transmision
		JOIN GDD.BI_Dim_Potencia DP ON DP.potencia_rango = GDD.CALCULAR_POTENCIA(M.modelo_potencia)
		JOIN GDD.BI_Dim_Fabricante DF ON DF.fabr_id = A.autoParte_fabricante
	
	WHERE C.compra_id = (SELECT TOP 1 C2.compra_id FROM GDD.COMPRA C2
								JOIN GDD.ITEM_COMPRA IC2 ON IC2.compra = C2.compra_id
							WHERE C2.compra_sucursal = F.factura_sucursal
								AND IC2.item_compra_auto_parte = A.autoParte_id
							ORDER BY C2.compra_fecha)

	GROUP BY T.tiem_id, DC.clie_id, DS.sucu_id, DM.mode_codigo, DTA.tipoAutomovil_id, DTC.tipoCaja_id, 
			DTM.tipoMotor_id, DTT.tipoTransmision_id, DP.potencia_id, A.autoParte_id, DF.fabr_id


END
GO

-----------------------------------------Ejecutar procedures-----------------------------------------
EXEC GDD.CREAR_DIMENSIONES
EXEC GDD.CREAR_HECHOS

EXEC GDD.CREAR_PK
EXEC GDD.CREAR_FK

EXEC GDD.CARGAR_DIMENSIONES
EXEC GDD.CARGAR_HECHOS_AUTOMOVILES



--SELECT * FROM GDD.AUTO_PARTE
--	JOIN GDD.ITEM_COMPRA I ON item_compra_auto_parte = auto_parte_id
--	JOIN GDD.COMPRA C ON I.compra = C.compra_id






















