-- ===================== CREAR BASE =====================
CREATE DATABASE Musica;
GO
USE Musica;
GO

-- ===================== PROCEDIMIENTO =====================
CREATE OR ALTER PROCEDURE CrearTablasMusica
AS
BEGIN
    -- Eliminar si existen
    IF OBJECT_ID('CursoUsuario','U') IS NOT NULL DROP TABLE CursoUsuario;
    IF OBJECT_ID('CursoCategoria','U') IS NOT NULL DROP TABLE CursoCategoria;
    IF OBJECT_ID('Certificados','U') IS NOT NULL DROP TABLE Certificados;
    IF OBJECT_ID('Instructores','U') IS NOT NULL DROP TABLE Instructores;
    IF OBJECT_ID('Categorias','U') IS NOT NULL DROP TABLE Categorias;
    IF OBJECT_ID('Cursos','U') IS NOT NULL DROP TABLE Cursos;
    IF OBJECT_ID('Usuarios','U') IS NOT NULL DROP TABLE Usuarios;

    -- Usuarios
    CREATE TABLE Usuarios(
        id_usuario INT PRIMARY KEY IDENTITY,
        nombre VARCHAR(50) NOT NULL
    );

    -- Cursos
    CREATE TABLE Cursos(
        id_curso INT PRIMARY KEY IDENTITY,
        titulo VARCHAR(50) NOT NULL
    );

    -- Categorías
    CREATE TABLE Categorias(
        id_categoria INT PRIMARY KEY IDENTITY,
        nombre VARCHAR(50) NOT NULL
    );

    -- Instructores
    CREATE TABLE Instructores(
        id_instructor INT PRIMARY KEY IDENTITY,
        nombre VARCHAR(50) NOT NULL
    );

    -- Certificados
    CREATE TABLE Certificados(
        id_certificado INT PRIMARY KEY IDENTITY,
        id_usuario INT FOREIGN KEY REFERENCES Usuarios(id_usuario),
        id_curso INT FOREIGN KEY REFERENCES Cursos(id_curso)
    );

    -- Pivote: Curso–Categoría
    CREATE TABLE CursoCategoria(
        id_curso INT FOREIGN KEY REFERENCES Cursos(id_curso),
        id_categoria INT FOREIGN KEY REFERENCES Categorias(id_categoria),
        PRIMARY KEY(id_curso,id_categoria)
    );

    -- Pivote: Curso–Usuario
    CREATE TABLE CursoUsuario(
        id_curso INT FOREIGN KEY REFERENCES Cursos(id_curso),
        id_usuario INT FOREIGN KEY REFERENCES Usuarios(id_usuario),
        PRIMARY KEY(id_curso,id_usuario)
    );

    -- ===================== INSERTS =====================
    -- Usuarios
    INSERT INTO Usuarios(nombre) VALUES
    ('U1'),('U2'),('U3'),('U4'),('U5'),
    ('U6'),('U7'),('U8'),('U9'),('U10');

    -- Cursos
    INSERT INTO Cursos(titulo) VALUES
    ('C1'),('C2'),('C3'),('C4'),('C5'),
    ('C6'),('C7'),('C8'),('C9'),('C10');

    -- Categorías
    INSERT INTO Categorias(nombre) VALUES
    ('Cat1'),('Cat2'),('Cat3'),('Cat4'),('Cat5'),
    ('Cat6'),('Cat7'),('Cat8'),('Cat9'),('Cat10');

    -- Instructores
    INSERT INTO Instructores(nombre) VALUES
    ('I1'),('I2'),('I3'),('I4'),('I5'),
    ('I6'),('I7'),('I8'),('I9'),('I10');

    -- Certificados
    INSERT INTO Certificados(id_usuario,id_curso) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);

    -- Curso–Categoría
    INSERT INTO CursoCategoria VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);

    -- Curso–Usuario
    INSERT INTO CursoUsuario VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
GO

-- ===================== EJECUTAR =====================
EXEC CrearTablasMusica;
GO

-- ===================== VISTAS (SIN JOINS) =====================
CREATE OR ALTER VIEW Reporte_Usuarios AS
SELECT id_usuario, nombre FROM Usuarios;
GO

CREATE OR ALTER VIEW Reporte_Cursos AS
SELECT id_curso, titulo FROM Cursos;
GO

CREATE OR ALTER VIEW Reporte_Categorias AS
SELECT id_categoria, nombre FROM Categorias;
GO

CREATE OR ALTER VIEW Reporte_Instructores AS
SELECT id_instructor, nombre FROM Instructores;
GO

CREATE OR ALTER VIEW Reporte_Certificados AS
SELECT id_certificado, id_usuario, id_curso FROM Certificados;
GO

-- ===================== CONSULTAS DE PRUEBA =====================
SELECT * FROM Reporte_Usuarios;
SELECT * FROM Reporte_Cursos;
SELECT * FROM Reporte_Categorias;
SELECT * FROM Reporte_Instructores;
SELECT * FROM Reporte_Certificados;
