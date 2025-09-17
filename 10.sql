-- ========================================
-- 1. CREAR BASE DE DATOS Y TABLAS
-- ========================================
USE master;
GO

CREATE OR ALTER PROCEDURE sp_CrearBaseDeDatosYTablas_Salud
AS
BEGIN
    SET NOCOUNT ON;

    IF DB_ID('PlataformaSalud') IS NOT NULL
        DROP DATABASE PlataformaSalud;

    CREATE DATABASE PlataformaSalud;

    EXEC('
        USE PlataformaSalud;

        -- Tabla Usuarios
        CREATE TABLE Usuarios (
            UsuarioID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(50) NOT NULL
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
            Nombre NVARCHAR(50) NOT NULL
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

-- Ejecutar creación
EXEC sp_CrearBaseDeDatosYTablas_Salud;
GO

-- ========================================
-- 2. INSERTAR DATOS (10 por tabla, abreviados)
-- ========================================
USE PlataformaSalud;
GO

-- Usuarios
INSERT INTO Usuarios (Nombre) VALUES
('U1'),('U2'),('U3'),('U4'),('U5'),
('U6'),('U7'),('U8'),('U9'),('U10');

-- Cursos
INSERT INTO Cursos (Titulo) VALUES
('C1'),('C2'),('C3'),('C4'),('C5'),
('C6'),('C7'),('C8'),('C9'),('C10');

-- Categorías
INSERT INTO Categorias (Nombre) VALUES
('Cat1'),('Cat2'),('Cat3'),('Cat4'),('Cat5'),
('Cat6'),('Cat7'),('Cat8'),('Cat9'),('Cat10');

-- Instructores
INSERT INTO Instructores (Nombre) VALUES
('I1'),('I2'),('I3'),('I4'),('I5'),
('I6'),('I7'),('I8'),('I9'),('I10');

-- Certificados
INSERT INTO Certificados (UsuarioID, CursoID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- Curso-Categoría
INSERT INTO CursoCategoria (CursoID, CategoriaID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- Curso-Usuario (Inscripciones)
INSERT INTO CursoUsuario (CursoID, UsuarioID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- ========================================
-- 3. VISTAS SIMPLES (5 sin joins complicados)
-- ========================================
CREATE OR ALTER VIEW Vista_Usuarios AS
SELECT UsuarioID, Nombre FROM Usuarios;

CREATE OR ALTER VIEW Vista_Cursos AS
SELECT CursoID, Titulo FROM Cursos;

CREATE OR ALTER VIEW Vista_Categorias AS
SELECT CategoriaID, Nombre FROM Categorias;

CREATE OR ALTER VIEW Vista_Instructores AS
SELECT InstructorID, Nombre FROM Instructores;

CREATE OR ALTER VIEW Vista_Certificados AS
SELECT CertificadoID, UsuarioID, CursoID FROM Certificados;
GO

-- ========================================
-- 4. CONSULTAS DE PRUEBA
-- ========================================
SELECT * FROM Vista_Usuarios;
SELECT * FROM Vista_Cursos;
SELECT * FROM Vista_Categorias;
SELECT * FROM Vista_Instructores;
SELECT * FROM Vista_Certificados;
