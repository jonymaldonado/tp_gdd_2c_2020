CREATE DATABASE BASE2
DROP DATABASE BASE2
use BASE2

CREATE TABLE Cliente (
	clie_id int identity(1,1) PRIMARY KEY not null,
	clie_nombre nvarchar(255) null,
	clie_apellido nvarchar(255) null,
	clie_direccion nvarchar(255) null,
	clie_dni decimal(18,0) null,
	clie_mail nvarchar(255) null,
	clie_fecha_nac datetime2(3)null
);


create table Factura (
	factura_id int identity(1,1) not null PRIMARY KEY,
	factura_fecha datetime2(3) null,
	factura_clie int FOREIGN KEY REFERENCES Cliente(clie_id) null,
	factura_numero decimal(18,0)null 
);


create table Sucursal (
	sucursal_id int identity(1,1) not null PRIMARY KEY,
	sucursal_telefono decimal(18,0) null,
	sucursal_direccion nvarchar(255) null,
	sucursal_ciudad nvarchar(255) null,
	sucursal_mail nvarchar(255) null
);
	
		
create table Tipo_transmision(
	tipo_transmision_id decimal(18,0) PRIMARY KEY not null,
	tipo_transmision_desc  nvarchar(255) null
);

	
create table Tipo_Caja(
	tipo_caja_id decimal(18,0) PRIMARY KEY not null,
	tipo_caja_desc nvarchar(255) null
);

	
create table Tipo_Motor(
	tipo_motor_id decimal(18,0) PRIMARY KEY not null,
	tipo_motor_codigo decimal(18,0) null
);

	
create table Tipo_Auto(
	tipo_auto_id decimal(18,0) PRIMARY KEY not null,
	tipo_auto_desc nvarchar(255) null
);

	
create table Modelo(
	modelo_id decimal(18,0) PRIMARY KEY not null,
	modelo_tipo_caja decimal(18,0) FOREIGN KEY REFERENCES Tipo_Caja (tipo_caja_id),
	modelo_tipo_auto decimal(18,0) FOREIGN KEY REFERENCES Tipo_Auto (tipo_auto_id),
	modelo_tipo_motor decimal(18,0) FOREIGN KEY REFERENCES Tipo_Motor (tipo_motor_id),
	modelo_tipo_transmision decimal(18,0) FOREIGN KEY REFERENCES Tipo_transmision (tipo_transmision_id),
	modelo_codigo decimal(18,0) null,
	modelo_nombre nvarchar(255) null,
	modelo_potencia decimal(18,0) null
);
	
	
create table Fabricante(
	fabricante_id int identity(1,1) PRIMARY KEY not null,
	fabricante_nombre nvarchar(255) null
);
		
	
create table Compra(
	compra_id int identity(1,1) not null PRIMARY KEY,
	compra_numero decimal(18,0) null,
	compra_auto int ,
	compra_factura int FOREIGN KEY REFERENCES Factura (factura_id),
	compra_sucursal int FOREIGN KEY REFERENCES Sucursal (sucursal_id),
	compra_fecha datetime2(3) null,
	compra_precio decimal(18,0) null,
	compra_cant decimal(18,0) null
);


create table Auto(
	auto_id  int identity(1,1) PRIMARY KEY not null,
	auto_compra int FOREIGN KEY REFERENCES Compra (compra_id),
	auto_modelo decimal(18,0) FOREIGN KEY REFERENCES Modelo (modelo_id),
	auto_nro_chasis	nvarchar(50) null,
	auto_nro_motor nvarchar(50) null,
	auto_patente nvarchar(50) null,
	auto_fecha_alta datetime2(3) null,
	auto_cant_kms decimal(18,0) null
);

	
create table Auto_Parte(
	auto_parte_id decimal(18,0) PRIMARY KEY not null,
	auto_parte_codigo decimal(18,0) null,
	auto_parte_descripcion nvarchar(255) null,
	auto_parte_fabricante int FOREIGN KEY REFERENCES Fabricante (fabricante_id) null
);

		
create table Stock(
	stock_id int identity(1,1) PRIMARY KEY not null,
	stock_auto_parte_id decimal(18,0) null FOREIGN KEY REFERENCES Auto_Parte (auto_parte_id),
	stock_sucursal_id int null FOREIGN KEY REFERENCES Sucursal (sucursal_id),
	stock_cant decimal(18,0) null
);


-- Insersión de datos

INSERT INTO dbo.Cliente (clie_apellido, clie_nombre, clie_direccion, clie_dni, clie_fecha_nac, clie_mail)
SELECT distinct [CLIENTE_APELLIDO]
      ,[CLIENTE_NOMBRE]
      ,[CLIENTE_DIRECCION]
      ,[CLIENTE_DNI]
      ,[CLIENTE_FECHA_NAC]
      ,[CLIENTE_MAIL]
  FROM [GD2C2020].[gd_esquema].[Maestra]

SET IDENTITY_INSERT GD2C2020.dbo.Tipo_Auto ON 
INSERT INTO dbo.Tipo_Auto(tipo_auto_id, tipo_auto_desc)
SELECT DISTINCT TIPO_AUTO_CODIGO, TIPO_AUTO_DESC
FROM [GD2C2020].[gd_esquema].[Maestra]
WHERE TIPO_AUTO_CODIGO IS NOT NULL

SET IDENTITY_INSERT GD2C2020.dbo.Tipo_Motor ON 
INSERT INTO dbo.Tipo_Motor(tipo_motor_id)
SELECT DISTINCT TIPO_MOTOR_CODIGO 
FROM [GD2C2020].[gd_esquema].[Maestra]
WHERE TIPO_MOTOR_CODIGO IS NOT NULL

SET IDENTITY_INSERT GD2C2020.dbo.Tipo_Caja ON 
INSERT INTO dbo.Tipo_Caja(tipo_caja_id, tipo_caja_desc)
SELECT DISTINCT TIPO_CAJA_CODIGO, TIPO_CAJA_DESC
FROM [GD2C2020].[gd_esquema].[Maestra]
WHERE TIPO_CAJA_CODIGO IS NOT NULL

SET IDENTITY_INSERT GD2C2020.dbo.Tipo_Transmision ON 
INSERT INTO dbo.Tipo_Transmision(tipo_transmision_id, tipo_transmision_desc)
SELECT DISTINCT TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC
FROM [GD2C2020].[gd_esquema].[Maestra]
WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL

INSERT INTO dbo.Fabricante (fabricante_nombre)
SELECT DISTINCT FABRICANTE_NOMBRE 
FROM [GD2C2020].[gd_esquema].[Maestra]

INSERT INTO dbo.Sucursal (sucursal_mail, sucursal_telefono, sucursal_ciudad, sucursal_direccion)
SELECT DISTINCT SUCURSAL_MAIL, SUCURSAL_TELEFONO, SUCURSAL_CIUDAD, SUCURSAL_DIRECCION 
FROM [GD2C2020].[gd_esquema].[Maestra]