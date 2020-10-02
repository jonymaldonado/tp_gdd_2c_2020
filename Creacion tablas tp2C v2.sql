
use BASE2



CREATE TABLE Cliente (
	cliente_id int identity(1,1) PRIMARY KEY not null,
	cliente_nombre nvarchar(255) null,
	cliente_apellido nvarchar(255) null,
	cliente_dni decimal(18,0) null,
	cliente_mail nvarchar(255) null,
	cliente_fecha_nac datetime2(3)null,);

create table Factura (
	factura_id int identity(1,1) not null PRIMARY KEY,
	factura_fecha datetime2(3) null,
	factura_cliente_id int FOREIGN KEY REFERENCES Cliente(cliente_id) null,
	factura_numero decimal(18,0)null ,);


create table Sucursal (
	sucursal_id int identity(1,1) not null PRIMARY KEY,
	sucursal_telefono decimal(18,0) null,
	sucursal_direccion nvarchar(255) null,
	sucursal_ciudad nvarchar(255) null,
	sucursal_mail nvarchar(255) null ,);
	
		
create table Tipo_transmision(
	tipo_transmision_id int identity(1,1) PRIMARY KEY not null,
	tipo_transmision_desc  nvarchar(255) null,);
	
create table Tipo_Caja(
	tipo_caja_id int identity(1,1) PRIMARY KEY not null,
	tipo_caja_desc nvarchar(255) null,);
	
create table Tipo_Motor(
	tipo_motor_id int identity(1,1) PRIMARY KEY not null,
	tipo_motor_codigo decimal(18,0) null,);
	
create table Tipo_Auto(
	tipo_auto_id int identity(1,1) PRIMARY KEY not null,
	tipo_auto_desc nvarchar(255) null,);

	
create table Modelo(
	modelo_id int identity(1,1) PRIMARY KEY not null,
	modelo_codigo decimal(18,0) null,
	modelo_nombre nvarchar(255) null,
	modelo_potencia decimal(18,0) null,);
	
	
create table Fabricante(
	fabricante_id int identity(1,1) PRIMARY KEY not null,
	fabricante_nombre nvarchar(255) null,);
		
	
create table Compra (
	compra_id int identity(1,1) not null PRIMARY KEY,
	compra_numero decimal(18,0) null,
	compra_auto_id int ,
	compra_factura_id int FOREIGN KEY REFERENCES Factura (factura_id),
	compra_sucursal_id int FOREIGN KEY REFERENCES Sucursal (sucursal_id),
	compra_fecha datetime2(3) null,
	compra_precio decimal(18,0) null,
	compra_cant decimal(18,0) null,);


create table Auto(
	auto_id  int identity(1,1) PRIMARY KEY not null,
	auto_compra_id int FOREIGN KEY REFERENCES Compra (compra_id),
	auto_modelo_id int FOREIGN KEY REFERENCES Modelo (modelo_id),
	auto_tipo_caja_id int FOREIGN KEY REFERENCES Tipo_Caja (tipo_caja_id),
	auto_tipo_auto_id int FOREIGN KEY REFERENCES Tipo_Auto (tipo_auto_id),
	auto_tipo_motor_id int FOREIGN KEY REFERENCES Tipo_Motor (tipo_motor_id),
	auto_tipo_transmision_id int FOREIGN KEY REFERENCES Tipo_transmision (tipo_transmision_id),
	auto_nro_chasis	nvarchar(50) null,
	auto_nro_motor nvarchar(50) null,
	auto_patente nvarchar(50) null,
	auto_fecha_alta datetime2(3) null,
	auto_cant_kms decimal(18,0) null,);
	
create table Auto_Parte(
	auto_parte_id int identity(1,1) PRIMARY KEY not null,
	auto_parte_codigo decimal(18,0) null,
	auto_parte_descripcion nvarchar(255) null,
	auto_parte_fabricante_id int FOREIGN KEY REFERENCES Fabricante (fabricante_id) null,);
	

	

create table Stock(
	stock_id int identity(1,1) PRIMARY KEY not null,
	stock_auto_parte_id int null FOREIGN KEY REFERENCES Auto_Parte (auto_parte_id),
	stock_sucursal_id int null FOREIGN KEY REFERENCES Sucursal (sucursal_id),
	stock_cant decimal(18,0) null
	,);


