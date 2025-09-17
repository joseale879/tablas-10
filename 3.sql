
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
('Luis Pérez','luis@gmail.com'),
('María López','maria@gmail.com'),
('Juan Ríos','juanr@gmail.com'),
('Carmen Díaz','carmen@gmail.com'),
('Pedro Muñoz','pedro@gmail.com'),
('Lucía Fernández','lucia@gmail.com'),
('Hugo Ortega','hugo@gmail.com'),
('Sofía Romero','sofia@gmail.com'),
('Diego Vargas','diego@gmail.com');

-- Cursos
INSERT INTO Cursos (Titulo, Descripcion) VALUES
('Inglés Básico','Curso de inglés inicial'),
('Inglés Intermedio','Curso de inglés intermedio'),
('Inglés Avanzado','Curso de inglés avanzado'),
('Francés Básico','Curso de francés inicial'),
('Francés Intermedio','Curso de francés intermedio'),
('Francés Avanzado','Curso de francés avanzado'),
('Alemán Básico','Curso de alemán inicial'),
('Alemán Intermedio','Curso de alemán intermedio'),
('Alemán Avanzado','Curso de alemán avanzado'),
('Italiano Básico','Curso de italiano inicial');

-- Categorías
INSERT INTO Categorias (Nombre) VALUES
('Inglés'),
('Francés'),
('Alemán'),
('Italiano'),
('Español'),
('Mandarín'),
('Japonés'),
('Portugués'),
('Ruso'),
('Coreano');

-- Instructores
INSERT INTO Instructores (Nombre, Especialidad) VALUES
('Carlos Ruiz','Inglés'),
('Laura Medina','Francés'),
('Jorge Silva','Alemán'),
('Ana Beltrán','Italiano'),
('Esteban Cruz','Español'),
('Paula Ortiz','Mandarín'),
('Nicolás Bravo','Japonés'),
('Sandra Ramos','Portugués'),
('Diego Peña','Ruso'),
('María Gómez','Coreano');

-- Certificados
INSERT INTO Certificados (UsuarioID, CursoID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- Curso-Categoría
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



CREATE OR ALTER VIEW Reporte_Instructores AS
SELECT id_instructor, nombre
FROM Instructores;
GO

CREATE OR ALTER VIEW Reporte_Certificados AS
SELECT id_certificado, id_usuario, id_curso
FROM Certificados;
GO

CREATE OR ALTER VIEW Reporte_CursoUsuario AS
SELECT id_curso, id_usuario
FROM CursoUsuario;
GO

CREATE OR ALTER VIEW Reporte_CursoCategoria AS
SELECT id_curso, id_categoria
FROM CursoCategoria;
GO

CREATE OR ALTER VIEW Reporte_Usuarios AS
SELECT id_usuario, nombre
FROM Usuarios;
GO

SELECT * FROM Reporte_Instructores;
SELECT * FROM Reporte_Certificados;
SELECT * FROM Reporte_CursoUsuario;
SELECT * FROM Reporte_CursoCategoria;
SELECT * FROM Reporte_Usuarios;
