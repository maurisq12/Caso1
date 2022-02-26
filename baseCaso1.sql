CREATE DATABASE Aseni;


CREATE TABLE Tipo(
	IDTipo int IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(20),
	Descripcion varchar(50)
)

CREATE TABLE Provincia(
	IDProvincia int IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(20)
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
	Nombre varchar(50),
	Siglas varchar(5),
	Candidato varchar(50),
	URLBandera varchar(250),
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
	EnteKPI varchar(20),
	IDPartido int,
	CONSTRAINT FK_PartidoE FOREIGN KEY (IDPartido)
    REFERENCES Partido(IDPartido)
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

CREATE PROCEDURE spInsertarProvincia @Nombre varchar(20)
AS
BEGIN
	IF(@Nombre is not null)
		IF NOT(EXISTS(SELECT Nombre FROM Tipo WHERE Nombre=@Nombre))
			BEGIN
				INSERT INTO Provincia(Nombre)
				VALUES (@Nombre)
			END
		ELSE RAISERROR ( 'La provincia ya se encuentra registrada',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END
GO

CREATE PROCEDURE spLeerProvincia
AS
BEGIN
	SELECT Nombre FROM Provincia
END
GO

CREATE PROCEDURE spActualizarProvincia @IDProvincia int, @Nombre varchar(25)
AS
BEGIN 
	IF(@Nombre is not null and @IDProvincia is not null)
		IF (EXISTS(SELECT IDProvincia FROM Provincia WHERE Nombre=@Nombre))
			BEGIN
				UPDATE Provincia set Nombre=@Nombre WHERE IDProvincia=@IDProvincia	
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



CREATE PROCEDURE spInsertarPartido @Nombre varchar(50), @Siglas varchar(5), @Candidato varchar(50), @URLBandera varchar(250)
AS
BEGIN
	IF(@Nombre is not null and @Siglas is not null and @Candidato is not null and @URLBandera is not null )
		IF NOT(EXISTS(SELECT Nombre FROM Partido WHERE Nombre=@Nombre))
			BEGIN
				INSERT INTO Partido(Nombre,Siglas,Candidato,URLBandera,FechaCreacion,Estado)
				VALUES (@Nombre,@Siglas,@Candidato,@URLBandera,GETDATE(),1)
			END
		ELSE RAISERROR ( 'El partido ya se encuentra registrado',1,1)
	ELSE RAISERROR ( 'Por favor no inserte valores nulos',1,1)
END
GO

CREATE PROCEDURE spLeerPartido
AS
BEGIN
	SELECT Nombre,Siglas,Candidato,URLBandera,FechaCreacion FROM Partido
END
GO

CREATE PROCEDURE spActualizarPartido @IDPartido int,@Candidato varchar(50)=NULL,@URLBandera varchar(250)=NULL
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
			IF NOT(EXISTS(SELECT IDPlan FROM PlanGobierno WHERE Titulo=@Titulo))
				BEGIN
					INSERT INTO PlanGobierno(Titulo,Descripcion,IDPartido)
					VALUES (@Titulo,@Descripcion,@IDPartido)
				END
			ELSE RAISERROR ('Ya existe un plan con este titulo',1,1)
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
			IF NOT(EXISTS(SELECT IDAccion FROM Accion WHERE @Descripcion=Descripcion and @IDPlan=IDPlan))
				BEGIN
					DECLARE @IDAUX1 int
					DECLARE @TablaAUX table (IDA int)

					INSERT INTO Accion(Descripcion,IDPlan)
					OUTPUT INSERTED.IDAccion into @TablaAUX
					VALUES (@Descripcion,@IDPlan)
					SELECT @IDAUX1=IDA from @TablaAUX
				
					INSERT INTO AccionesPorPlan(IDAccion,IDPlan)
					VALUES (@IDAUX1,@IDPlan)
				END
			ELSE RAISERROR ('La acción ya existe',1,1)
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
			IF NOT(EXISTS(SELECT IDCanton FROM Canton WHERE Nombre=@Nombre))
				BEGIN
					INSERT INTO Canton(Nombre,IDProvincia)
					VALUES (@Nombre,@IDProvincia)
				END
			ELSE RAISERROR ('El canton ya se encuentra registrado',1,1)
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



CREATE PROCEDURE spInsertarEntregable @Descripcion varchar(45),@Fecha date,@ValorKPI int, @EnteKPI varchar(20), @IDCanton int, @IDAccion int, @IDPartido int
AS
BEGIN
	IF(@Descripcion is not null and @Fecha is not null and @ValorKPI is not null and @EnteKPI is not null and @IDCanton is not null and @IDPartido is not null)
		IF NOT(EXISTS(SELECT Fecha FROM Entregable WHERE Descripcion=@Descripcion))
			IF(EXISTS(SELECT Partido.Nombre FROM Partido WHERE Partido.IDPartido=@IDPartido))
				BEGIN
					DECLARE @IDAUX1 int
					DECLARE @TablaAUX table (IDA int)

					INSERT INTO Entregable(Descripcion,Fecha,ValorKPI,EnteKPI,IDPartido)
					OUTPUT INSERTED.IDEntregable into @TablaAUX
					VALUES (@Descripcion,@Fecha,@ValorKPI,@EnteKPI,@IDPartido)
					SELECT @IDAUX1=IDA from @TablaAUX
					INSERT INTO EntregablesPorAccion(IDAccion,IDEntregable)
					VALUES(@IDAccion,@IDAUX1)
					INSERT INTO EntregablesPorCanton(IDCanton,IDEntregable)
					VALUES(@IDCanton,@IDAUX1)
				END
			ELSE RAISERROR ('El partido no se encuentra registrado',1,1)
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

CREATE PROCEDURE spActualizarEntregable @IDEntregable int,@Descripcion varchar(45),@Fecha date,@ValorKPI int, @EnteKPI varchar(20),  @IDCanton int
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


--------------------------------------------------------Poblacion de la base-----------------------------------------------------------------------------------------------

spInsertarProvincia 'San Jose'
GO
spInsertarProvincia 'Alajuela'
GO
spInsertarProvincia 'Cartago'
GO
spInsertarProvincia 'Heredia'
GO
spInsertarProvincia 'Guanacaste'
GO
spInsertarProvincia 'Puntarenas'
GO
spInsertarProvincia 'Limon'
GO



spInsertarCanton 'Acosta',1
GO
spInsertarCanton 'Escazu',1
GO
spInsertarCanton 'Tibas',1
GO
spInsertarCanton 'Moravia',1
GO
--spInsertarCanton 'Puriscal',1
GO


spInsertarCanton 'Palmares',2
GO
spInsertarCanton 'Sarchi',2
GO
spInsertarCanton 'Zarcero',2
GO
spInsertarCanton 'Grecia',2
GO
--spInsertarCanton 'Naranjo',2
GO

spInsertarCanton 'Oreamuno',3
GO
spInsertarCanton 'Jimenez',3
GO
spInsertarCanton 'Paraiso',3
GO
spInsertarCanton 'Turrialba',3
GO
--spInsertarCanton 'Cartago',3
GO

spInsertarCanton 'Barva',4
GO
spInsertarCanton 'Belen',4
GO
spInsertarCanton 'Flores',4
GO
spInsertarCanton 'San Pablo',4
GO
--spInsertarCanton 'San Rafael',4
GO

spInsertarCanton 'Bagaces',5
GO
spInsertarCanton 'Carrillo',5
GO
spInsertarCanton 'Hojancha',5
GO
spInsertarCanton 'Liberia',5
GO
--spInsertarCanton 'Nicoya',5
GO

spInsertarCanton 'Corredores',6
GO
spInsertarCanton 'Esparza',6
GO
spInsertarCanton 'Golfito',6
GO
spInsertarCanton 'Osa',6
GO
--spInsertarCanton 'Puntarenas',6
GO

spInsertarCanton 'Guacimo',7
GO
spInsertarCanton 'Limon',7
GO
spInsertarCanton 'Matina',7
GO
spInsertarCanton 'Pococi',7
GO
--spInsertarCanton 'Siquirres',7
GO





spInsertarPartido 'Partido Liberacion Nacional','PLN','Jose Maria Figueres','upload.wikimedia.org/wikipedia/commons/a/ad/Bandera_de_Partido_Liberaci%C3%B3n_Nacional.sv'
GO
spInsertarPartido 'Partido Nueva Republica','PNR','Fabricio Alvarado','upload.wikimedia.org/wikipedia/commons/thumb/7/72/Bandera_Partido_Nueva_Rep%C3%BAblica_Costa_Rica.svg/1200px-Bandera_Partido_Nueva_Rep%C3%BAblica_Costa_Rica.svg.png'
GO
spInsertarPartido 'Partido Progreso Social Democratico','PPSD','Rodrigo Chaves','upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Bandera_Partido_Progreso_Social_Democr%C3%A1tico_Costa_Rica.svg/1200px-Bandera_Partido_Progreso_Social_Democr%C3%A1tico_Costa_Rica.svg.png'
GO
spInsertarPartido 'Partido Unidad Social Cristiana','PUSC','Linneth Saborio','upload.wikimedia.org/wikipedia/commons/a/ad/Bandera_del_Partido_Unidad_Social_Cristiana.svg'
GO

spInsertarPlanGobierno 'Gobierno PLN 2022-2026','Planes del gobierno para el proximo gobierno',1
GO
spInsertarPlanGobierno 'Gobierno PNR 2022-2026','Planes del gobierno para el proximo gobierno',2
GO
spInsertarPlanGobierno 'Gobierno PPSD 2022-2026','Planes del gobierno para el proximo gobierno',3
GO
spInsertarPlanGobierno 'Gobierno PUSC 2022-2026','Planes del gobierno para el proximo gobierno',4
GO


spInsertarAccion 'Asfaltado de las calles que llevan a las principales comunidades hacia escuelas y hospitales',1
GO
spInsertarAccion 'Expansion de EBAIS en comunidades',1
GO
spInsertarAccion 'Ampliar el acueducto metropolitano',1
GO

spInsertarAccion 'Bono a PYMES de todo el pais para impulsar sus proyectos',2
GO
spInsertarAccion 'Establecer estructura de fibra optica en todas las regiones',2
GO
spInsertarAccion 'Producir empleos para la poblacion para mejorar la economia',2
GO

spInsertarAccion 'Educacion bilingue en todas las escuelas del pais',3
GO
spInsertarAccion 'Impulsar el uso de la quinta generacion de comunicacion 5G',3
GO
spInsertarAccion 'Fortalecer un cuido infantil asequible',3
GO

spInsertarAccion 'Plan para el desarrollo de poblaciones indigenas',4
GO
spInsertarAccion 'Fortalecimiento de la policia nacional',4
GO
spInsertarAccion 'Impulso del sector turistico con inversion extranjera directa',4
GO




spInsertarEntregable 'Asfaltado Calle Acosta','2023-11-11',11,'kilometros',1,1,1
GO
spInsertarEntregable 'Asfaltado Calle Zarcero','2023-11-11',11,'kilometros',7,1,1
GO
spInsertarEntregable 'Asfaltado Calle Flores','2023-11-11',11,'kilometros',15,1,1
GO
spInsertarEntregable 'Asfaltado Calle Liberia','2023-11-11',11,'kilometros',20,1,1
GO
spInsertarEntregable 'Asfaltado Calle Matina','2023-11-11',11,'kilometros',27,1,1
GO

spInsertarEntregable 'Nuevo Ebais en Palmares','2024-1-18',1,'local',5,2,1
GO
spInsertarEntregable 'Nuevo Ebais en Bagaces','2024-1-18',1,'local',17,2,1
GO
spInsertarEntregable 'Nuevo Ebais en Hojancha','2024-1-18',1,'local',19,2,1
GO
spInsertarEntregable 'Nuevo Ebais en Esparza','2024-1-18',1,'local',22,2,1
GO
spInsertarEntregable 'Nuevo Ebais en Pococi','2024-1-18',1,'local',28,2,1
GO

spInsertarEntregable 'Acueducto moderno Tibas','2024-5-18',2,'ciudades',3,3,1
GO
spInsertarEntregable 'Acueducto moderno Palmares','2024-5-18',2,'ciudades',5,3,1
GO
spInsertarEntregable 'Acueducto moderno Belen','2024-5-18',2,'ciudades',14,3,1
GO
spInsertarEntregable 'Acueducto moderno Liberia','2024-5-18',2,'ciudades',20,3,1
GO
spInsertarEntregable 'Acueducto moderno Esparza','2024-5-18',2,'ciudades',22,3,1
GO

spInsertarEntregable 'Bonos PYMEs Acosta','2022-10-25',10000,'dolares',1,4,2
GO
spInsertarEntregable 'Bonos PYMEs Tibas','2022-10-25',10000,'dolares',3,4,2
GO
spInsertarEntregable 'Bonos PYMEs Belen','2022-10-25',10000,'dolares',14,4,2
GO
spInsertarEntregable 'Bonos PYMEs Carrillo','2022-10-25',10000,'dolares',18,4,2
GO
spInsertarEntregable 'Bonos PYMEs Hojancha','2022-10-25',10000,'dolares',19,4,2
GO

spInsertarEntregable 'Instalacion fibra optica Moravia','2023-5-2',5,'estructuras',4,5,2
GO
spInsertarEntregable 'Instalacion fibra optica Jimenez','2023-5-2',5,'estructuras',10,5,2
GO
spInsertarEntregable 'Instalacion fibra optica Turrialba','2023-5-2',5,'estructuras',12,5,2
GO
spInsertarEntregable 'Instalacion fibra optica Golfito','2023-5-2',5,'estructuras',23,5,2
GO
spInsertarEntregable 'Instalacion fibra optica Pococi','2023-5-2',5,'estructuras',28,5,2
GO

spInsertarEntregable 'Producir empleos Escazu','2022-10-24',100,'empleos',2,6,2
GO
spInsertarEntregable 'Producir empleos Oreamuno','2022-10-24',100,'empleos',9,6,2
GO
spInsertarEntregable 'Producir empleos Paraiso','2022-10-24',100,'empleos',11,6,2
GO
spInsertarEntregable 'Producir empleos San Pablo','2022-10-24',100,'empleos',16,6,2
GO
spInsertarEntregable 'Producir empleos Golfito','2022-10-24',100,'empleos',23,6,2
GO

spInsertarEntregable 'Profesores bilingues Tibas','2022-7-10',5,'profesores',3,7,3
GO
spInsertarEntregable 'Profesores bilingues Turrialba','2022-7-10',5,'profesores',12,7,3
GO
spInsertarEntregable 'Profesores bilingues Flores','2022-7-10',5,'profesores',15,7,3
GO
spInsertarEntregable 'Profesores bilingues Carrillo','2022-7-10',5,'profesores',18,7,3
GO
spInsertarEntregable 'Profesores bilingues Corredores','2022-7-10',5,'profesores',21,7,3
GO

spInsertarEntregable 'Tecnologia 5G Zarcero','2025-10-1',2,'antenas',7,8,3
GO
spInsertarEntregable 'Tecnologia 5G Liberia','2025-10-1',2,'antenas',20,8,3
GO
spInsertarEntregable 'Tecnologia 5G Esparza','2025-10-1',2,'antenas',22,8,3
GO
spInsertarEntregable 'Tecnologia 5G Osa','2025-10-1',2,'antenas',24,8,3
GO
spInsertarEntregable 'Tecnologia 5G Limon','2025-10-1',2,'antenas',26,8,3
GO

spInsertarEntregable 'Cuido infantil Sarchi','2022-11-29',2,'centros',6,9,3
GO
spInsertarEntregable 'Cuido infantil San Pablo','2022-11-29',2,'centros',16,9,3
GO
spInsertarEntregable 'Cuido infantil Liberia','2022-11-29',2,'centros',20,9,3
GO
spInsertarEntregable 'Cuido infantil Limon','2022-11-29',2,'centros',26,9,3
GO
spInsertarEntregable 'Cuido infantil Matina','2022-11-29',2,'centros',27,9,3
GO

spInsertarEntregable 'Bonos a indigenas Turrialba','2022-6-15',10,'familias',12,10,4
GO
spInsertarEntregable 'Bonos a indigenas Hojancha','2022-6-15',10,'familias',19,10,4
GO
spInsertarEntregable 'Bonos a indigenas Osa','2022-6-15',10,'familias',24,10,4
GO
spInsertarEntregable 'Bonos a indigenas Guacimo','2022-6-15',10,'familias',25,10,4
GO
spInsertarEntregable 'Bonos a indigenas Matina','2022-6-15',10,'familias',27,10,4
GO

spInsertarEntregable 'Vehiculos Policia Palmares','2024-4-25',3,'vehiculos',5,11,4
GO
spInsertarEntregable 'Vehiculos Policia Flores','2024-4-25',3,'vehiculos',15,11,4
GO
spInsertarEntregable 'Vehiculos Policia Hojancha','2024-4-25',3,'vehiculos',19,11,4
GO
spInsertarEntregable 'Vehiculos Policia Guacimo','2024-4-25',3,'vehiculos',25,11,4
GO
spInsertarEntregable 'Vehiculos Policia Limon','2024-4-25',3,'vehiculos',26,11,4
GO

spInsertarEntregable 'Inyecccion economica Grecia','2025-8-12',50000,'dolares',8,12,4
GO
spInsertarEntregable 'Inyecccion economica Carrillo','2025-8-12',50000,'dolares',18,12,4
GO
spInsertarEntregable 'Inyecccion economica Liberia','2025-8-12',50000,'dolares',20,12,4
GO
spInsertarEntregable 'Inyecccion economica Limon','2025-8-12',50000,'dolares',26,12,4
GO
spInsertarEntregable 'Inyecccion economica Pococi','2025-8-12',50000,'dolares',28,12,4
GO





---------------------------------------------------------------------Query 1-----------------------------------------------------------------------------------------------


CREATE PROCEDURE spEntregablesPorCanton @CantonSol varchar(30)
AS
BEGIN
	SELECT Partido.IDPartido Partido, Entregable.Descripcion FROM Entregable
	INNER JOIN EntregablesPorCanton
	ON EntregablesPorCanton.IDEntregable=Entregable.IDEntregable
	INNER JOIN Canton
	ON Canton.IDCanton=EntregablesPorCanton.IDCanton
	INNER JOIN Partido
	ON Partido.IDPartido=Entregable.IDPartido
	WHERE Canton.Nombre=@CantonSol
	GROUP by Partido.IDPartido, Entregable.Descripcion

END
GO

spEntregablesPorCanton 'Esparza'

































