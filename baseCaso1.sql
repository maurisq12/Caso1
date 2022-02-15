
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

CREATE TABLE AccionesPorPlan(
	IDCliente int,
	IDTelefono int,
	CONSTRAINT FK_ClienteTC FOREIGN KEY (IDCliente)
    REFERENCES Cliente(IDCliente),
	CONSTRAINT FK_TelefonoTC FOREIGN KEY (IDTelefono)
    REFERENCES Telefono(IDTelefono),
	PRIMARY KEY (IDCliente,IDTelefono),

)