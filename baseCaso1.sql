
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


CREATE TABLE Partido(
	IDPartido int IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(30),
	Siglas varchar(5),
	Candidato varchar(50),
	URLBandera varchar(150),
	FechaCreacion date,
	Estado int
)

CREATE TABLE Usuario(
	IDUsuario int IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(70),
	Correo varchar(30) UNIQUE,
	Contraseña varchar(25),
	URLFoto varchar(150),
	Estado int,
	IDTipo int,
	IDPartido int,
	IDBio int,
	FechaCreacion date,
	CONSTRAINT FK_TipoU FOREIGN KEY (IDTipo)
    REFERENCES Tipo(IDTipo),
	CONSTRAINT FK_PartidoU FOREIGN KEY (IDPartido)
    REFERENCES Partido(IDPartido),
	CONSTRAINT FK_BioU FOREIGN KEY (IDBio)
    REFERENCES Bio(IDBio)
)

CREATE TABLE PlanGobierno(
	IDPlan int IDENTITY(1,1) PRIMARY KEY,
	Titulo varchar(100),
	Descripcion varchar(300),
	IDPartido int,
	CONSTRAINT FK_PartidoPlan FOREIGN KEY (IDPartido)
    REFERENCES Partido(IDPartido)
)

CREATE TABLE Accion(
	IDAccion int IDENTITY(1,1) PRIMARY KEY,
	Descripcion varchar(700),
	IDPlan int,
	CONSTRAINT FK_PlanA FOREIGN KEY (IDPlan)
    REFERENCES PlanGobierno(IDPLan)
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
	Nombre varchar(25),
	IDProvincia int,
	CONSTRAINT FK_ProvinciaC FOREIGN KEY (IDProvincia)
    REFERENCES Provincia(IDProvincia)
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
	IF(@Nombre is not null and @IDProvincia is not null and @Numero is not null)
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
				INSERT INTO Bio(Nombre,FechaNacimiento,Descripcion,IDProvincia)
				VALUES (@Nombre,@FechaNacimiento,@Descripcion,@IDProvincia)
			END
		ELSE RAISERROR ( 'El bio de este usuario ya se encuentra registrado',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END
GO

CREATE PROCEDURE spLeerBio
AS
BEGIN
	SELECT Bio.Nombre,FechaNacimiento,Descripcion,Provincia.Nombre as Provincia FROM Bio
	INNER JOIN Provincia
	ON Provincia.IDProvincia = Bio.IDProvincia
END
GO

CREATE PROCEDURE spActualizarBio @IDBio int, @Descripcion varchar(75)=NULL, @IDProvincia int=NULL
AS
BEGIN 
	IF(@IDBio is not null and @Descripcion is not null and @IDProvincia is not null)
		IF(@IDBio is not null)
			IF (EXISTS(SELECT Nombre FROM Bio WHERE IDBio=@IDBio))
				BEGIN
					IF(@Descripcion is null)
						UPDATE Bio set IDProvincia=@IDProvincia WHERE IDBio=@IDBio
					ELSE
						BEGIN
							IF(@IDProvincia is null)
								UPDATE Bio set Descripcion=@Descripcion WHERE IDBio=@IDBio
							ELSE
								UPDATE Bio set Descripcion=@Descripcion, IDProvincia=@IDProvincia WHERE IDBio=@IDBio	
						END
				END
			ELSE RAISERROR ( 'La bio no se encuentra registrada',1,1)
		ELSE RAISERROR ( 'Por favor indique el ID del bio',1,1)
	ELSE RAISERROR ( 'Parametros nulos',1,1)
END	
GO

CREATE PROCEDURE spEliminarBio @IDBio int
AS
BEGIN
	IF(@IDBio is not null)
		UPDATE Bio set Descripcion='', IDProvincia=0 WHERE IDBio=@IDBio
	ELSE RAISERROR ( 'Parametro nulo',1,1)
END
GO

------------------------------------------------------------CRUD Partido---------------------------------------------------------------------------------



CREATE PROCEDURE spInsertarPartido @Nombre varchar(20), @Siglas varchar(5), @Candidato varchar(50), @URLBandera varchar(150)
AS
BEGIN
	IF(@Nombre is not null and @Siglas is not null and @Candidato is not null and @URLBandera is not null )
		IF NOT(EXISTS(SELECT Nombre FROM Partido WHERE Nombre=@Nombre))
			BEGIN
				INSERT INTO Partido(Nombre,Siglas,Candidato,URLBandera,FechaCreacion,Estado)
				VALUES (@Nombre,@Siglas,@Candidato,@URLBandera,GETDATE(),1)
			END
		ELSE RAISERROR ( 'La provincia ya se encuentra registrada',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END
GO

CREATE PROCEDURE spLeerPartido
AS
BEGIN
	SELECT Nombre,Siglas,Candidato,URLBandera,FechaCreacion FROM Partido
END
GO

CREATE PROCEDURE spActualizarPartido @IDPartido int,@Candidato varchar(50)=NULL,@URLBandera varchar(150)=NULL
AS
BEGIN 
	IF(@IDPartido is not null and @Candidato is not null and @URLBandera is not null)
		IF(@IDPartido is not null)
			IF (EXISTS(SELECT Nombre FROM Partido WHERE IDPartido=@IDPartido))
				BEGIN
					IF(@Candidato is null)
						UPDATE Partido set URLBandera=@URLBandera WHERE IDPartido=@IDPartido					
					ELSE
						BEGIN
							IF(@URLBandera is null)
								UPDATE Partido set Candidato=@Candidato WHERE IDPartido=@IDPartido
							ELSE
								UPDATE Partido set Candidato=@Candidato, URLBandera=@URLBandera WHERE IDPartido=@IDPartido	
						END
				END
			ELSE RAISERROR ( 'El partido no se encuentra registrado',1,1)
		ELSE RAISERROR ( 'Por favor indique el ID del partido',1,1)
	ELSE RAISERROR ( 'Parametros nulos',1,1)
END	
GO

CREATE PROCEDURE spEliminarPartido @IDPartido int  
AS
BEGIN
	UPDATE Partido SET Estado=0 WHERE IDPartido=@IDPartido
END
GO



------------------------------------------------------------CRUD Usuario---------------------------------------------------------------------------------



CREATE PROCEDURE spInsertarUsuario @Nombre varchar(70), @Correo varchar(30), @Contraseña varchar(25), @IDTipo int
AS
BEGIN
	IF(@Nombre is not null and @Correo is not null and @Contraseña is not null and @IDTipo is not null )
		IF NOT(EXISTS(SELECT Nombre FROM Usuario WHERE Correo=@Correo))
			BEGIN
				INSERT INTO Usuario(Nombre,Correo,Contraseña,IDTipo,FechaCreacion,Estado)
				VALUES (@Nombre,@Correo,@Contraseña,@IDTipo,GETDATE(),1)
			END
		ELSE RAISERROR ( 'Ya hay un usuario registrado con ese correo',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END
GO

CREATE PROCEDURE spLeerUsuario
AS
BEGIN
	SELECT Nombre,Correo,IDTipo,Estado FROM Usuario
END
GO

CREATE PROCEDURE spActualizarUsuario @IDUsuario int,@Nombre varchar(70),@Correo varchar(30), @Contraseña varchar(25)
AS
BEGIN 
	IF(@IDUsuario is not null and @Nombre is not null and @Correo is not null and @Contraseña is not null )
		IF(@IDUsuario is not null)
			IF (EXISTS(SELECT Nombre FROM Usuario WHERE IDUsuario=@IDUsuario))
				BEGIN
					UPDATE Usuario SET Nombre=@Nombre,Correo=@Correo,Contraseña=@Contraseña
				END
			ELSE RAISERROR ( 'El usuario no se encuentra registrado',1,1)
		ELSE RAISERROR ( 'Por favor indique el ID del usuario',1,1)
	ELSE RAISERROR ( 'Parametros nulos',1,1)
END	
GO

CREATE PROCEDURE spEliminarUsuario @IDUsuario int  
AS
BEGIN
	UPDATE Usuario SET Estado=0 WHERE IDUsuario=@IDUsuario
END
GO

------------------------------------------------------------CRUD Plan Gobierno---------------------------------------------------------------------------------



CREATE PROCEDURE spInsertarPlanGobierno @Titulo varchar(100), @Descripcion varchar(300), @IDPartido int
AS
BEGIN
	IF(@Titulo is not null and @Descripcion is not null and @IDPartido is not null )
		IF (EXISTS(SELECT Nombre FROM Partido WHERE IDPartido=@IDPartido))
			BEGIN
				INSERT INTO PlanGobierno(Titulo,Descripcion,IDPartido)
				VALUES (@Titulo,@Descripcion,@IDPartido)
			END
		ELSE RAISERROR ('No existe un partido con el ID indicado',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END
GO

CREATE PROCEDURE spLeerPlan
AS
BEGIN
	SELECT Titulo,Descripcion, Partido.Nombre Partido FROM PlanGobierno
	INNER JOIN Partido
	ON Partido.IDPartido=PlanGobierno.IDPartido
END
GO

CREATE PROCEDURE spActualizarPlanGobierno @IDPlanGobierno int,@Titulo varchar(100), @Descripcion varchar(300)
AS
BEGIN 
	IF(@IDPlanGobierno is not null and @Titulo is not null and @Descripcion is not null)
		IF(@IDPlanGobierno is not null)
			IF (EXISTS(SELECT Titulo FROM PlanGobierno WHERE IDPlan=@IDPlanGobierno))
				BEGIN
					UPDATE PlanGobierno SET Titulo=@Titulo,Descripcion=@Descripcion WHERE IDPlan=@IDPlanGobierno
				END
			ELSE RAISERROR ( 'El plan de gobierno no se encuentra registrado',1,1)
		ELSE RAISERROR ( 'Por favor indique el ID del plan de gobierno',1,1)
	ELSE RAISERROR ( 'Parametros nulos',1,1)
END	
GO

CREATE PROCEDURE spEliminarPlanGobierno @IDPlan int
AS
BEGIN
	DELETE PlanGobierno WHERE IDPlan=@IDPlan
END
GO




------------------------------------------------------------CRUD Accion---------------------------------------------------------------------------------



CREATE PROCEDURE spInsertarAccion @Descripcion varchar(700),@IDPlan int
AS
BEGIN
	IF(@Descripcion is not null and @IDPlan is not null)
		IF (EXISTS(SELECT Titulo FROM PlanGobierno WHERE IDPlan=@IDPlan))
			BEGIN
				INSERT INTO Accion(Descripcion,IDPlan)
				VALUES (@Descripcion,@IDPlan)
			END
		ELSE RAISERROR ('No existe un plan de gobierno con el ID indicado',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END
GO

CREATE PROCEDURE spLeerAccion
AS
BEGIN
	SELECT Accion.Descripcion Descripcion, PlanGobierno.Titulo PlanGobierno ,Partido.Nombre Partido FROM Accion
	INNER JOIN PlanGobierno
	ON PlanGobierno.IDPartido = Accion.IDPlan
	INNER JOIN Partido
	ON Partido.IDPartido=PlanGobierno.IDPartido
END
GO

CREATE PROCEDURE spActualizarAccion @IDAccion int,@Descripcion varchar(300)
AS
BEGIN 
	IF(@IDAccion is not null and @Descripcion is not null)
		IF(@IDAccion is not null)
			IF (EXISTS(SELECT Descripcion FROM Accion WHERE IDAccion=@IDAccion))
				BEGIN
					UPDATE Accion SET Descripcion=@Descripcion WHERE IDAccion=@IDAccion
				END
			ELSE RAISERROR ( 'La accion no se encuentra registrada',1,1)
		ELSE RAISERROR ( 'Por favor indique el ID de la accion',1,1)
	ELSE RAISERROR ( 'Parametros nulos',1,1)
END	
GO

CREATE PROCEDURE spEliminarAccion @IDAccion int
AS
BEGIN
	DELETE Accion WHERE IDAccion=@IDAccion
END
GO


------------------------------------------------------------CRUD Canton---------------------------------------------------------------------------------



CREATE PROCEDURE spInsertarCanton @Nombre varchar(25), @IDProvincia int
AS
BEGIN
	IF(@Nombre is not null and @IDProvincia is not null)
		IF (EXISTS(SELECT Nombre FROM Provincia WHERE IDProvincia=@IDProvincia))
			BEGIN
				INSERT INTO Canton(Nombre,IDProvincia)
				VALUES (@Nombre,@IDProvincia)
			END
		ELSE RAISERROR ('No existe una provincia con el ID indicado',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END
GO

CREATE PROCEDURE spLeerCanton
AS
BEGIN
	SELECT Canton.Nombre Canton, Provincia.Nombre Provincia FROM Canton
	INNER JOIN Provincia
	ON Provincia.IDProvincia=Canton.IDProvincia
END
GO

CREATE PROCEDURE spActualizarCanton @IDCanton int, @Nombre varchar(25), @IDProvincia int
AS
BEGIN 
	IF(@Nombre is not null and @IDProvincia is not null and @IDCanton is not null)
		IF(@IDCanton is not null)
			IF (EXISTS(SELECT Nombre FROM Canton WHERE IDCanton=@IDCanton))
				BEGIN
					UPDATE Canton SET Nombre=@Nombre, IDProvincia=@IDProvincia WHERE IDCanton=@IDCanton
				END
			ELSE RAISERROR ( 'La provincia no se encuentra registrada',1,1)
		ELSE RAISERROR ( 'Por favor indique el ID del canton',1,1)
	ELSE RAISERROR ( 'Parametros nulos',1,1)
END	
GO

CREATE PROCEDURE spEliminarCanton @IDCanton int
AS
BEGIN
	DELETE Canton WHERE IDCanton=@IDCanton
END
GO




------------------------------------------------------------CRUD Entregable---------------------------------------------------------------------------------



CREATE PROCEDURE spInsertarEntregable @Descripcion varchar(45),@Fecha date,@ValorKPI int, @EnteKPI varchar(20), @IDCanton int
AS
BEGIN
	IF(@Descripcion is not null and @Fecha is not null and @ValorKPI is not null and @EnteKPI is not null and @IDCanton is not null)
		IF NOT(EXISTS(SELECT Fecha FROM Entregable WHERE Descripcion=@Descripcion))
			BEGIN
				INSERT INTO Entregable(Descripcion,Fecha,ValorKPI,EnteKPI)
				VALUES (@Descripcion,@Fecha,@ValorKPI,@EnteKPI)
			END
		ELSE RAISERROR ('Ya existe un entregable identico',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END
GO

CREATE PROCEDURE spLeerEntregable
AS
BEGIN
	SELECT Descripcion,Fecha,ValorKPI,EnteKPI FROM Entregable
END
GO

CREATE PROCEDURE spActualizarEntregable @IDEntregable int,@Descripcion varchar(45),@Fecha date,@ValorKPI int, @EnteKPI varchar(20)
AS
BEGIN 
	IF(@Descripcion is not null and @Fecha is not null and @ValorKPI is not null and @EnteKPI is not null and @IDCanton is not null)
		IF(@IDEntregable is not null)
			IF (EXISTS(SELECT Descripcion FROM Entregable WHERE IDEntregable=@IDEntregable))
				BEGIN
					UPDATE Entregable SET Descripcion=@Descripcion,Fecha=@Fecha,ValorKPI=@ValorKPI,EnteKPI=@EnteKPI WHERE IDEntregable=@IDEntregable
				END
			ELSE RAISERROR ( 'El entregable no se encuentra registrado',1,1)
		ELSE RAISERROR ( 'Por favor indique el ID del entregable',1,1)
	ELSE RAISERROR ( 'Parametros nulos',1,1)
END	
GO

CREATE PROCEDURE spEliminarEntregable @IDEntregable int
AS
BEGIN
	DELETE Entregable WHERE IDEntregable=@IDEntregable
END
GO


-------------------------------------------------------------------------------------------------------------------------------------------------------





























