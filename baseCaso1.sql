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
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																				CRUD
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------CRUD TIPO---------------------------------------------------------------------------------
CREATE PROCEDURE spInsertarTipo @Nombre varchar(20), @Descripcion varchar(50)
AS
BEGIN
	IF(@Nombre is not null and @Descripcion is not null)
		IF NOT(EXISTS(SELECT Nombre FROM Tipo WHERE Nombre=@Nombre))
			BEGIN
				INSERT INTO Tipo(Nombre,Descripcion)
				VALUES (@Nombre,@Descripcion)
			END
		ELSE RAISERROR ( 'El tipo ya se encuentra registrado',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END
GO

CREATE PROCEDURE spLeerTipo
AS
BEGIN
	SELECT Nombre,Descripcion FROM Tipo
END
GO

CREATE PROCEDURE spActualizarTipo @IDTipo int, @Nombre varchar(25), @Descripcion varchar(50)
AS
BEGIN 
	IF(@Nombre is not null and @IDTipo is not null and @Descripcion is not null)
		IF (EXISTS(SELECT IDTipo FROM Tipo WHERE Nombre=@Nombre))
			BEGIN
				UPDATE Tipo set Nombre=@Nombre, Descripcion=@Descripcion WHERE IDTipo=@IDTipo		
			END
		ELSE RAISERROR ( 'El tipo no se encuentra registrado',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END	
GO

CREATE PROCEDURE spEliminarTipo @Nombre varchar(25)  
AS
BEGIN
	DELETE Tipo WHERE Nombre=@Nombre
END
GO

------------------------------------------------------------CRUD Provincia---------------------------------------------------------------------------------

CREATE PROCEDURE spInsertarProvincia @Nombre varchar(20), @Numero int
AS
BEGIN
	IF(@Nombre is not null and @Numero is not null)
		IF NOT(EXISTS(SELECT Nombre FROM Tipo WHERE Nombre=@Nombre))
			BEGIN
				INSERT INTO Provincia(Nombre,Numero)
				VALUES (@Nombre,@Numero)
			END
		ELSE RAISERROR ( 'La provincia ya se encuentra registrada',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END
GO

CREATE PROCEDURE spLeerProvincia
AS
BEGIN
	SELECT Nombre,Numero FROM Provincia
END
GO

CREATE PROCEDURE spActualizarProvincia @IDProvincia int, @Nombre varchar(25), @Numero int
AS
BEGIN 
	IF(@Nombre is not null and @IDTipo is not null and @Numero is not null)
		IF (EXISTS(SELECT IDProvincia FROM Provincia WHERE Nombre=@Nombre))
			BEGIN
				UPDATE Provincia set Nombre=@Nombre, Numero=@Numero WHERE IDProvincia=@IDProvincia	
			END
		ELSE RAISERROR ( 'La provincia no se encuentra registrada',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END	
GO

CREATE PROCEDURE spEliminarProvincia @Nombre varchar(25)  
AS
BEGIN
	DELETE Provincia WHERE Nombre=@Nombre
END
GO

------------------------------------------------------------CRUD Bio---------------------------------------------------------------------------------

CREATE PROCEDURE spInsertarBio @IDUsuario int,@Nombre varchar(70), @FechaNacimiento date, @Descripcion varchar(75), @IDProvincia int
AS
BEGIN
	IF(@IDUsuario is not null and @Nombre is not null and @FechaNacimiento is not null and @Descripcion is not null and @IDProvincia is not null)
		IF NOT(EXISTS(SELECT Nombre FROM Tipo WHERE Nombre=@Nombre))
			BEGIN
				INSERT INTO Bio(Nombre,Numero)
				VALUES (@Nombre,@Numero)
			END
		ELSE RAISERROR ( 'El bio de este usuario ya se encuentra registrado',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END
GO

CREATE PROCEDURE spLeerProvincia
AS
BEGIN
	SELECT Nombre,Numero FROM Provincia
END
GO

CREATE PROCEDURE spActualizarProvincia @IDProvincia int, @Nombre varchar(25), @Numero int
AS
BEGIN 
	IF(@Nombre is not null and @IDTipo is not null and @Numero is not null)
		IF (EXISTS(SELECT IDProvincia FROM Provincia WHERE Nombre=@Nombre))
			BEGIN
				UPDATE Provincia set Nombre=@Nombre, Numero=@Numero WHERE IDProvincia=@IDProvincia	
			END
		ELSE RAISERROR ( 'La provincia no se encuentra registrada',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END	
GO

CREATE PROCEDURE spEliminarProvincia @Nombre varchar(25)  
AS
BEGIN
	DELETE Provincia WHERE Nombre=@Nombre
END
GO









-------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE spInsertTipo @Nombre varchar(20), @Descripcion varchar(50)
AS
BEGIN
END



CREATE PROCEDURE spInsertTipo @Nombre varchar(20), @Descripcion varchar(50)
AS
BEGIN
	IF(@Nombre is not null and @Descripcion is not null)
		IF NOT(EXISTS(SELECT Nombre FROM Tipo WHERE Nombre=@Nombre))
			BEGIN
				
			END
		ELSE RAISERROR ( 'La sucursal ya se encuentra registrada',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END































