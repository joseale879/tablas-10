-- ===================== CREAR BASE =====================
USE master;
GO

CREATE OR ALTER PROCEDURE CrearBase_DeDatosYTablas_Arte_Simplificado
AS
BEGIN
    SET NOCOUNT ON;

    IF DB_ID('PlataformaArte') IS NOT NULL
        DROP DATABASE PlataformaArte;

    CREATE DATABASE PlataformaArte;

    EXEC('
        USE PlataformaArte;

        -- ===================== TABLAS =====================
        CREATE TABLE Usuarios (
            UsuarioID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(50) NOT NULL,
            Email NVARCHAR(100) NOT NULL
        );

        CREATE TABLE Cursos (
            CursoID INT PRIMARY KEY IDENTITY,
            Titulo NVARCHAR(50) NOT NULL
        );

        CREATE TABLE Categorias (
            CategoriaID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(50) NOT NULL
        );

        CREATE TABLE Instructores (
            InstructorID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(50) NOT NULL,
            Especialidad NVARCHAR(50)
        );

        CREATE TABLE Certificados (
            CertificadoID INT PRIMARY KEY IDENTITY,
            UsuarioID INT,
            CursoID INT
        );

        CREATE TABLE CursoCategoria (
            CursoID INT,
            CategoriaID INT
        );

        CREATE TABLE CursoUsuario (
            CursoID INT,
            UsuarioID INT
        );

        -- ===================== INSERTS (abreviados) =====================
        -- Usuarios
        INSERT INTO Usuarios (Nombre, Email) VALUES
        (''U1'',''u1@mail.com''),(''U2'',''u2@mail.com''),(''U3'',''u3@mail.com''),(''U4'',''u4@mail.com''),(''U5'',''u5@mail.com''),
        (''U6'',''u6@mail.com''),(''U7'',''u7@mail.com''),(''U8'',''u8@mail.com''),(''U9'',''u9@mail.com''),(''U10'',''u10@mail.com'');

        -- Cursos
        INSERT INTO Cursos (Titulo) VALUES
        (''C1''),(''C2''),(''C3''),(''C4''),(''C5''),(''C6''),(''C7''),(''C8''),(''C9''),(''C10'');

        -- Categorías
        INSERT INTO Categorias (Nombre) VALUES
        (''Cat1''),(''Cat2''),(''Cat3''),(''Cat4''),(''Cat5''),(''Cat6''),(''Cat7''),(''Cat8''),(''Cat9''),(''Cat10'');

        -- Instructores
        INSERT INTO Instructores (Nombre, Especialidad) VALUES
        (''I1'',''E1''),(''I2'',''E2''),(''I3'',''E3''),(''I4'',''E4''),(''I5'',''E5''),
        (''I6'',''E6''),(''I7'',''E7''),(''I8'',''E8''),(''I9'',''E9''),(''I10'',''E10'');

        -- Certificados
        INSERT INTO Certificados (UsuarioID, CursoID) VALUES
        (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);

        -- Curso-Categoría
        INSERT INTO CursoCategoria VALUES
        (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);

        -- Curso-Usuario
        INSERT INTO CursoUsuario VALUES
        (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);
    ');
END;
GO

-- ===================== EJECUTAR =====================
EXEC CrearBase_DeDatosYTablas_Arte_Simplificado;
GO

USE PlataformaArte;
GO

-- ===================== VISTAS (SIN JOINS) =====================
CREATE OR ALTER VIEW Vista_Usuarios AS
SELECT UsuarioID, Nombre FROM Usuarios;
GO

CREATE OR ALTER VIEW Vista_Cursos AS
SELECT CursoID, Titulo FROM Cursos;
GO

CREATE OR ALTER VIEW Vista_Categorias AS
SELECT CategoriaID, Nombre FROM Categorias;
GO

CREATE OR ALTER VIEW Vista_Instructores AS
SELECT InstructorID, Nombre, Especialidad FROM Instructores;
GO

CREATE OR ALTER VIEW Vista_Certificados AS
SELECT CertificadoID, UsuarioID, CursoID FROM Certificados;
GO

-- ===================== CONSULTAS DE PRUEBA =====================
SELECT * FROM Usuarios;
SELECT * FROM Cursos;
SELECT * FROM Categorias;
SELECT * FROM Instructores;
SELECT * FROM Certificados;
SELECT * FROM CursoCategoria;
SELECT * FROM CursoUsuario;
