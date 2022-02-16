
CREATE TABLE Tipo(
	IDTipo int IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(20),
	Descripcion varchar(50)
)

CREATE TABLE Provincia(
	IDProvincia int IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(20),
	Numero int
)

CREATE TABLE Bio(
	IDBio int IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(70),
	FechaNacimiento Date,
	Descripcion varchar(75),
	IDProvincia int,
	CONSTRAINT FK_ProvinciaB FOREIGN KEY (IDProvincia)
    REFERENCES Provincia(IDProvincia)
)

CREATE TABLE Bandera(
	IDBandera int IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(20),
)

CREATE TABLE Partido(
	IDPartido int IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(30),
	Siglas varchar(5),
	Canditato varchar(50),
	IDBandera int,
	CONSTRAINT FK_BanderaP FOREIGN KEY (IDBandera)
    REFERENCES Bandera(IDBandera)
)



CREATE TABLE Usuario(
	IDUsuario int IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(70),
	Correo varchar(30),
	Contraseña varchar(25),
	Foto varchar(45),
	Estado int,
	IDTipo int,
	IDPartido int,
	IDBandera int,
	IDBio int,
	CONSTRAINT FK_TipoU FOREIGN KEY (IDTipo)
    REFERENCES Tipo(IDTipo),
	CONSTRAINT FK_PartidoU FOREIGN KEY (IDPartido)
    REFERENCES Partido(IDPartido),
	CONSTRAINT FK_BanderaU FOREIGN KEY (IDBandera)
    REFERENCES Bandera(IDBandera),
	CONSTRAINT FK_BioU FOREIGN KEY (IDBio)
    REFERENCES Bio(IDBio)
)

CREATE TABLE PlanGobierno(
	IDPlan int IDENTITY(1,1) PRIMARY KEY,
	IDPartido int,
	CONSTRAINT FK_PartidoPlan FOREIGN KEY (IDPartido)
    REFERENCES Partido(IDPartido)
)

CREATE TABLE Accion(
	IDAccion int IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(25),
	Descripcion varchar(45)
)

CREATE TABLE AccionesPorPlan(
	IDAccion int,
	IDPlan int,
	CONSTRAINT FK_AccionAXP FOREIGN KEY (IDAccion)
    REFERENCES Accion(IDAccion),
	CONSTRAINT FK_PlanAXP FOREIGN KEY (IDPlan)
    REFERENCES PlanGobierno(IDPlan),
	PRIMARY KEY (IDAccion,IDPlan)
)

CREATE TABLE Canton(
	IDCanton int IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(25)
)

CREATE TABLE Entregable(
	IDEntregable int IDENTITY(1,1) PRIMARY KEY,
	Descripcion varchar(45),
	Fecha date,
	ValorKPI int,
	EnteKPI varchar(20)
)

CREATE TABLE EntregablesPorAccion(
	IDEntregable int,
	IDAccion int,
	CONSTRAINT FK_EntregableEXA FOREIGN KEY (IDEntregable)
    REFERENCES Entregable(IDEntregable),
	CONSTRAINT FK_AccionEXA FOREIGN KEY (IDAccion)
    REFERENCES Accion(IDAccion),
	PRIMARY KEY (IDEntregable,IDAccion)
)

CREATE TABLE EntregablesPorCanton(
	IDEntregable int,
	IDCanton int,
	CONSTRAINT FK_EntregableEXC FOREIGN KEY (IDEntregable)
    REFERENCES Entregable(IDEntregable),
	CONSTRAINT FK_CantonEXC FOREIGN KEY (IDCanton)
    REFERENCES Canton(IDCanton),
	PRIMARY KEY (IDEntregable,IDCanton)
)




