-- ===================== CREAR BASE =====================
USE master;
GO

CREATE OR ALTER PROCEDURE sp_CrearBaseDeDatosYTablas_Negocios
AS
BEGIN
    SET NOCOUNT ON;

    IF DB_ID('PlataformaNegocios') IS NOT NULL
        DROP DATABASE PlataformaNegocios;

    CREATE DATABASE PlataformaNegocios;

    EXEC('
        USE PlataformaNegocios;

        -- Tabla Usuarios
        CREATE TABLE Usuarios (
            UsuarioID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(50) NOT NULL,
            Email NVARCHAR(100) NOT NULL UNIQUE
        );

        -- Tabla Cursos
        CREATE TABLE Cursos (
            CursoID INT PRIMARY KEY IDENTITY,
            Titulo NVARCHAR(50) NOT NULL
        );

        -- Tabla Categorias
        CREATE TABLE Categorias (
            CategoriaID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(50) NOT NULL
        );

        -- Tabla Instructores
        CREATE TABLE Instructores (
            InstructorID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(50) NOT NULL,
            Especialidad NVARCHAR(50) NOT NULL
        );

        -- Tabla Certificados
        CREATE TABLE Certificados (
            CertificadoID INT PRIMARY KEY IDENTITY,
            UsuarioID INT NOT NULL,
            CursoID INT NOT NULL,
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
            PRIMARY KEY (CursoID, UsuarioID),
            FOREIGN KEY (CursoID) REFERENCES Cursos(CursoID),
            FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
        );
    ');
END;
GO

-- Ejecutar el procedimiento
EXEC sp_CrearBaseDeDatosYTablas_Negocios;
GO

USE PlataformaNegocios;
GO

-- ===================== INSERTS =====================

-- Usuarios
INSERT INTO Usuarios (Nombre, Email) VALUES
('U1','u1@mail.com'),('U2','u2@mail.com'),('U3','u3@mail.com'),
('U4','u4@mail.com'),('U5','u5@mail.com'),('U6','u6@mail.com'),
('U7','u7@mail.com'),('U8','u8@mail.com'),('U9','u9@mail.com'),
('U10','u10@mail.com');

-- Cursos
INSERT INTO Cursos (Titulo) VALUES
('C1'),('C2'),('C3'),('C4'),('C5'),
('C6'),('C7'),('C8'),('C9'),('C10');

-- Categorías
INSERT INTO Categorias (Nombre) VALUES
('Cat1'),('Cat2'),('Cat3'),('Cat4'),('Cat5'),
('Cat6'),('Cat7'),('Cat8'),('Cat9'),('Cat10');

-- Instructores
INSERT INTO Instructores (Nombre, Especialidad) VALUES
('I1','E1'),('I2','E2'),('I3','E3'),('I4','E4'),('I5','E5'),
('I6','E6'),('I7','E7'),('I8','E8'),('I9','E9'),('I10','E10');

-- Certificados
INSERT INTO Certificados (UsuarioID, CursoID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- Curso-Categoría
INSERT INTO CursoCategoria (CursoID, CategoriaID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- Curso-Usuario
INSERT INTO CursoUsuario (CursoID, UsuarioID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- ===================== VISTAS =====================

CREATE OR ALTER VIEW Vista_Usuarios AS
SELECT UsuarioID, Nombre, Email FROM Usuarios;

CREATE OR ALTER VIEW Vista_Cursos AS
SELECT CursoID, Titulo FROM Cursos;

CREATE OR ALTER VIEW Vista_Categorias AS
SELECT CategoriaID, Nombre FROM Categorias;

CREATE OR ALTER VIEW Vista_Instructores AS
SELECT InstructorID, Nombre, Especialidad FROM Instructores;

CREATE OR ALTER VIEW Vista_Certificados AS
SELECT CertificadoID, UsuarioID, CursoID FROM Certificados;

-- ===================== CONSULTAS DE PRUEBA =====================

-- Usuarios
SELECT * FROM Vista_Usuarios;

-- Cursos
SELECT * FROM Vista_Cursos;

-- Categorías
SELECT * FROM Vista_Categorias;

-- Instructores
SELECT * FROM Vista_Instructores;

-- Certificados
SELECT * FROM Vista_Certificados;
