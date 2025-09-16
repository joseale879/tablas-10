
USE master;
GO

CREATE OR ALTER PROCEDURE sp_CrearBaseDeDatosYTablas_Musica
AS
BEGIN
    SET NOCOUNT ON;

    IF DB_ID('PlataformaMusica') IS NOT NULL
        DROP DATABASE PlataformaMusica;

    CREATE DATABASE PlataformaMusica;

    EXEC('
        USE PlataformaMusica;

        -- Tabla Usuarios
        CREATE TABLE Usuarios (
            UsuarioID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(100) NOT NULL,
            Email NVARCHAR(100) NOT NULL UNIQUE,
            FechaRegistro DATE NOT NULL DEFAULT GETDATE()
        );

        -- Tabla Cursos
        CREATE TABLE Cursos (
            CursoID INT PRIMARY KEY IDENTITY,
            Titulo NVARCHAR(100) NOT NULL,
            Descripcion NVARCHAR(255),
            FechaCreacion DATE NOT NULL DEFAULT GETDATE()
        );

        -- Tabla Categorias
        CREATE TABLE Categorias (
            CategoriaID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(50) NOT NULL UNIQUE
        );

        -- Tabla Instructores
        CREATE TABLE Instructores (
            InstructorID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(100) NOT NULL,
            Especialidad NVARCHAR(100),
            CONSTRAINT CK_Especialidad CHECK (LEN(Especialidad) > 3)
        );

        -- Tabla Certificados
        CREATE TABLE Certificados (
            CertificadoID INT PRIMARY KEY IDENTITY,
            UsuarioID INT NOT NULL,
            CursoID INT NOT NULL,
            FechaEntrega DATE NOT NULL DEFAULT GETDATE(),
            FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
            FOREIGN KEY (CursoID) REFERENCES Cursos(CursoID)
        );

        -- Tabla pivote CursoCategoria
        CREATE TABLE CursoCategoria (
            CursoID INT NOT NULL,
            CategoriaID INT NOT NULL,
            PRIMARY KEY (CursoID, CategoriaID),
            FOREIGN KEY (CursoID) REFERENCES Cursos(CursoID),
            FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
        );

        -- Tabla pivote CursoUsuario
        CREATE TABLE CursoUsuario (
            CursoID INT NOT NULL,
            UsuarioID INT NOT NULL,
            FechaInscripcion DATE NOT NULL DEFAULT GETDATE(),
            PRIMARY KEY (CursoID, UsuarioID),
            FOREIGN KEY (CursoID) REFERENCES Cursos(CursoID),
            FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
        );
    ');
END;
GO

EXEC sp_CrearBaseDeDatosYTablas_Musica;
GO

USE PlataformaMusica;
GO

-- Usuarios
INSERT INTO Usuarios (Nombre, Email) VALUES
('Ana Torres','ana@gmail.com'),
('Luis P�rez','luis@gmail.com'),
('Mar�a L�pez','maria@gmail.com'),
('Juan R�os','juanr@gmail.com'),
('Carmen D�az','carmen@gmail.com'),
('Pedro Mu�oz','pedro@gmail.com'),
('Luc�a Fern�ndez','lucia@gmail.com'),
('Hugo Ortega','hugo@gmail.com'),
('Sof�a Romero','sofia@gmail.com'),
('Diego Vargas','diego@gmail.com');

-- Cursos
INSERT INTO Cursos (Titulo, Descripcion) VALUES
('Guitarra B�sica','Aprender guitarra desde cero'),
('Guitarra Intermedia','T�cnicas intermedias de guitarra'),
('Piano B�sico','Aprender piano desde cero'),
('Piano Intermedio','T�cnicas intermedias de piano'),
('Canto Inicial','T�cnicas b�sicas de canto'),
('Canto Avanzado','T�cnicas avanzadas de canto'),
('Bater�a B�sica','Aprender bater�a desde cero'),
('Bater�a Intermedia','T�cnicas intermedias de bater�a'),
('Viol�n B�sico','Aprender viol�n desde cero'),
('Viol�n Avanzado','T�cnicas avanzadas de viol�n');

-- Categor�as
INSERT INTO Categorias (Nombre) VALUES
('Guitarra'),
('Piano'),
('Canto'),
('Bater�a'),
('Viol�n'),
('Bajo'),
('Saxof�n'),
('Flauta'),
('Producci�n'),
('Teor�a');

-- Instructores
INSERT INTO Instructores (Nombre, Especialidad) VALUES
('Carlos Ruiz','Guitarra'),
('Laura Medina','Piano'),
('Jorge Silva','Canto'),
('Ana Beltr�n','Bater�a'),
('Esteban Cruz','Viol�n'),
('Paula Ortiz','Bajo'),
('Nicol�s Bravo','Saxof�n'),
('Sandra Ramos','Flauta'),
('Diego Pe�a','Producci�n'),
('Mar�a G�mez','Teor�a');

-- Certificados
INSERT INTO Certificados (UsuarioID, CursoID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- Curso-Categor�a
INSERT INTO CursoCategoria (CursoID, CategoriaID) VALUES
(1,1),(2,1),(3,2),(4,2),(5,3),
(6,3),(7,4),(8,4),(9,5),(10,5);

-- Curso-Usuario (Inscripciones)
INSERT INTO CursoUsuario (CursoID, UsuarioID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

CREATE OR ALTER VIEW Vista_UsuariosCursos AS
SELECT u.Nombre AS Usuario, c.Titulo AS Curso
FROM CursoUsuario cu
JOIN Usuarios u ON cu.UsuarioID = u.UsuarioID
JOIN Cursos c ON cu.CursoID = c.CursoID;

CREATE OR ALTER VIEW Vista_CursosCategorias AS
SELECT c.Titulo AS Curso, cat.Nombre AS Categoria
FROM CursoCategoria cc
JOIN Cursos c ON cc.CursoID = c.CursoID
JOIN Categorias cat ON cc.CategoriaID = cat.CategoriaID;

CREATE OR ALTER VIEW Vista_Instructores AS
SELECT Nombre AS Instructor, Especialidad
FROM Instructores;

CREATE OR ALTER VIEW Vista_Certificados AS
SELECT u.Nombre AS Usuario, c.Titulo AS Curso
FROM Certificados ce
JOIN Usuarios u ON ce.UsuarioID = u.UsuarioID
JOIN Cursos c ON ce.CursoID = c.CursoID;

CREATE OR ALTER VIEW Vista_UsuariosPorCurso AS
SELECT c.Titulo AS Curso, COUNT(*) AS TotalUsuarios
FROM CursoUsuario cu
JOIN Cursos c ON cu.CursoID = c.CursoID
GROUP BY c.Titulo;

-- 1) Usuarios sin certificados
SELECT Nombre AS Usuario
FROM Usuarios
WHERE UsuarioID NOT IN (SELECT UsuarioID FROM Certificados);

-- 2) Cursos sin usuarios inscritos
SELECT Titulo AS Curso
FROM Cursos
WHERE CursoID NOT IN (SELECT CursoID FROM CursoUsuario);

-- 3) Cursos con m�s de un inscrito
SELECT c.Titulo AS Curso, COUNT(*) AS Inscritos
FROM CursoUsuario cu
JOIN Cursos c ON cu.CursoID = c.CursoID
GROUP BY c.Titulo
HAVING COUNT(*) > 1;

-- 4) Cantidad de cursos por categor�a
SELECT cat.Nombre AS Categoria, COUNT(*) AS TotalCursos
FROM CursoCategoria cc
JOIN Categorias cat ON cc.CategoriaID = cat.CategoriaID
GROUP BY cat.Nombre;

-- 5) Usuarios inscritos en m�s de un curso
SELECT u.Nombre AS Usuario, COUNT(*) AS Cursos
FROM CursoUsuario cu
JOIN Usuarios u ON cu.UsuarioID = u.UsuarioID
GROUP BY u.Nombre
HAVING COUNT(*) > 1;
