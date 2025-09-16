
USE master;
GO

CREATE OR ALTER PROCEDURE sp_CrearBaseDeDatosYTablas_Idiomas
AS
BEGIN
    SET NOCOUNT ON;

    IF DB_ID('PlataformaIdiomas') IS NOT NULL
        DROP DATABASE PlataformaIdiomas;

    CREATE DATABASE PlataformaIdiomas;

    EXEC('
        USE PlataformaIdiomas;

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

EXEC sp_CrearBaseDeDatosYTablas_Idiomas;
GO

USE PlataformaIdiomas;
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
('Ingl�s B�sico','Curso de ingl�s inicial'),
('Ingl�s Intermedio','Curso de ingl�s intermedio'),
('Ingl�s Avanzado','Curso de ingl�s avanzado'),
('Franc�s B�sico','Curso de franc�s inicial'),
('Franc�s Intermedio','Curso de franc�s intermedio'),
('Franc�s Avanzado','Curso de franc�s avanzado'),
('Alem�n B�sico','Curso de alem�n inicial'),
('Alem�n Intermedio','Curso de alem�n intermedio'),
('Alem�n Avanzado','Curso de alem�n avanzado'),
('Italiano B�sico','Curso de italiano inicial');

-- Categor�as
INSERT INTO Categorias (Nombre) VALUES
('Ingl�s'),
('Franc�s'),
('Alem�n'),
('Italiano'),
('Espa�ol'),
('Mandar�n'),
('Japon�s'),
('Portugu�s'),
('Ruso'),
('Coreano');

-- Instructores
INSERT INTO Instructores (Nombre, Especialidad) VALUES
('Carlos Ruiz','Ingl�s'),
('Laura Medina','Franc�s'),
('Jorge Silva','Alem�n'),
('Ana Beltr�n','Italiano'),
('Esteban Cruz','Espa�ol'),
('Paula Ortiz','Mandar�n'),
('Nicol�s Bravo','Japon�s'),
('Sandra Ramos','Portugu�s'),
('Diego Pe�a','Ruso'),
('Mar�a G�mez','Coreano');

-- Certificados
INSERT INTO Certificados (UsuarioID, CursoID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- Curso-Categor�a
INSERT INTO CursoCategoria (CursoID, CategoriaID) VALUES
(1,1),(2,1),(3,1),(4,2),(5,2),
(6,2),(7,3),(8,3),(9,3),(10,4);

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
