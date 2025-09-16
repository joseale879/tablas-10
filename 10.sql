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

EXEC sp_CrearBaseDeDatosYTablas_Salud;
GO

-- ========================================
-- 2. INSERTAR DATOS (10 por tabla)
-- ========================================
USE PlataformaSalud;
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
('Anatom�a B�sica','Curso inicial de anatom�a'),
('Anatom�a Avanzada','Anatom�a avanzada'),
('Nutrici�n','Curso de nutrici�n'),
('Enfermer�a B�sica','Curso inicial de enfermer�a'),
('Enfermer�a Avanzada','Curso avanzado de enfermer�a'),
('Fisioterapia','Introducci�n a fisioterapia'),
('Psicolog�a','Curso inicial de psicolog�a'),
('Salud P�blica','Curso de salud comunitaria'),
('Medicina General','Curso de medicina general'),
('Primeros Auxilios','Curso b�sico de primeros auxilios');

-- Categor�as
INSERT INTO Categorias (Nombre) VALUES
('Anatom�a'),
('Nutrici�n'),
('Enfermer�a'),
('Fisioterapia'),
('Psicolog�a'),
('Salud P�blica'),
('Medicina'),
('Primeros Auxilios'),
('Terapias'),
('Bienestar');

-- Instructores
INSERT INTO Instructores (Nombre, Especialidad) VALUES
('Carlos Ruiz','Anatom�a'),
('Laura Medina','Nutrici�n'),
('Jorge Silva','Enfermer�a'),
('Ana Beltr�n','Fisioterapia'),
('Esteban Cruz','Psicolog�a'),
('Paula Ortiz','Salud P�blica'),
('Nicol�s Bravo','Medicina'),
('Sandra Ramos','Primeros Auxilios'),
('Diego Pe�a','Terapias'),
('Mar�a G�mez','Bienestar');

-- Certificados
INSERT INTO Certificados (UsuarioID, CursoID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- Curso-Categor�a
INSERT INTO CursoCategoria (CursoID, CategoriaID) VALUES
(1,1),(2,1),(3,2),(4,3),(5,3),
(6,4),(7,5),(8,6),(9,7),(10,8);

-- Curso-Usuario (Inscripciones)
INSERT INTO CursoUsuario (CursoID, UsuarioID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- ========================================
-- 3. VISTAS SIMPLES (5)
-- ========================================
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

-- ========================================
-- 4. REPORTES SIMPLES (5)
-- ========================================
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
