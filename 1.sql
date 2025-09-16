USE master;
GO

CREATE OR ALTER PROCEDURE sp_CrearBaseDeDatosYTablas
AS
BEGIN
    SET NOCOUNT ON;

    -- Si la base ya existe, eliminarla
    IF DB_ID('PlataformaCursos') IS NOT NULL
        DROP DATABASE PlataformaCursos;

    -- Crear la base de datos
    CREATE DATABASE PlataformaCursos;

    -- Crear tablas dentro de la base de datos
    EXEC('
        USE PlataformaCursos;

        -- Tabla de usuarios
        CREATE TABLE Usuarios (
            UsuarioID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(100) NOT NULL,
            Email NVARCHAR(100) NOT NULL UNIQUE,
            FechaRegistro DATE NOT NULL DEFAULT GETDATE()
        );

        -- Tabla de cursos
        CREATE TABLE Cursos (
            CursoID INT PRIMARY KEY IDENTITY,
            Titulo NVARCHAR(100) NOT NULL,
            Descripcion NVARCHAR(255),
            FechaCreacion DATE NOT NULL DEFAULT GETDATE()
        );

        -- Tabla de categorías
        CREATE TABLE Categorias (
            CategoriaID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(50) NOT NULL UNIQUE
        );

        -- Tabla de instructores
        CREATE TABLE Instructores (
            InstructorID INT PRIMARY KEY IDENTITY,
            Nombre NVARCHAR(100) NOT NULL,
            Especialidad NVARCHAR(100),
            CONSTRAINT CK_Especialidad CHECK (LEN(Especialidad) > 3)
        );

        -- Tabla de certificados
        CREATE TABLE Certificados (
            CertificadoID INT PRIMARY KEY IDENTITY,
            UsuarioID INT NOT NULL,
            CursoID INT NOT NULL,
            FechaEntrega DATE NOT NULL DEFAULT GETDATE(),
            FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
            FOREIGN KEY (CursoID) REFERENCES Cursos(CursoID)
        );

        -- Tabla pivote: curso-categoría
        CREATE TABLE CursoCategoria (
            CursoID INT NOT NULL,
            CategoriaID INT NOT NULL,
            PRIMARY KEY (CursoID, CategoriaID),
            FOREIGN KEY (CursoID) REFERENCES Cursos(CursoID),
            FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
        );

        -- Tabla pivote: curso-usuario (inscripciones)
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

EXEC sp_CrearBaseDeDatosYTablas;
GO

USE PlataformaCursos;
GO

-- Usuarios
INSERT INTO Usuarios (Nombre, Email) VALUES
('Ana Torres', 'ana@gmail.com'),
('Luis Pérez', 'luis@gmail.com'),
('María López', 'maria@gmail.com'),
('Juan Ríos', 'juanr@gmail.com'),
('Carmen Díaz', 'carmen@gmail.com'),
('Pedro Muñoz', 'pedro@gmail.com'),
('Lucía Fernández', 'lucia@gmail.com'),
('Hugo Ortega', 'hugo@gmail.com'),
('Sofía Romero', 'sofia@gmail.com'),
('Diego Vargas', 'diego@gmail.com');

-- Cursos
INSERT INTO Cursos (Titulo, Descripcion) VALUES
('Curso HTML', 'Introducción al HTML'),
('Curso CSS', 'Estilos con CSS'),
('Curso JS', 'JavaScript Básico'),
('Curso SQL', 'Bases de datos con SQL'),
('Curso Python', 'Python desde cero'),
('Curso Excel', 'Excel avanzado'),
('Curso Marketing', 'Marketing digital'),
('Curso UX', 'Diseño UX/UI'),
('Curso Power BI', 'Visualización de datos'),
('Curso WordPress', 'Sitios con WordPress');

-- Categorías
INSERT INTO Categorias (Nombre) VALUES
('Programación'),
('Diseño'),
('Marketing'),
('Ofimática'),
('Datos'),
('Bases de Datos'),
('Web'),
('Negocios'),
('Educación'),
('Tecnología');

-- Instructores
INSERT INTO Instructores (Nombre, Especialidad) VALUES
('Carlos Ruiz', 'Programación Web'),
('Laura Medina', 'Diseño UX/UI'),
('Jorge Silva', 'Marketing'),
('Ana Beltrán', 'Educación Digital'),
('Esteban Cruz', 'Análisis de Datos'),
('Paula Ortiz', 'Bases de Datos'),
('Nicolás Bravo', 'Negocios Online'),
('Sandra Ramos', 'Visualización de Datos'),
('Diego Peña', 'Tecnologías Web'),
('María Gómez', 'Productividad y Ofimática');

-- Certificados
INSERT INTO Certificados (UsuarioID, CursoID) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Curso-Categoría
INSERT INTO CursoCategoria (CursoID, CategoriaID) VALUES
(1, 1), (2, 1), (3, 1), (4, 6), (5, 1),
(6, 4), (7, 3), (8, 2), (9, 5), (10, 7);

-- Curso-Usuario (Inscripciones)
INSERT INTO CursoUsuario (CursoID, UsuarioID) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);


-- Vista: Usuarios con sus cursos inscritos
CREATE OR ALTER VIEW Vista_UsuariosConCursos AS
SELECT 
    Usuarios.Nombre AS NombreUsuario,
    Cursos.Titulo AS NombreCurso,
    CursoUsuario.FechaInscripcion
FROM CursoUsuario
JOIN Usuarios ON CursoUsuario.UsuarioID = Usuarios.UsuarioID
JOIN Cursos ON CursoUsuario.CursoID = Cursos.CursoID;

-- Vista: Cursos con sus categorías
CREATE OR ALTER VIEW Vista_CursosCategorias AS
SELECT 
    Cursos.Titulo AS NombreCurso,
    Categorias.Nombre AS NombreCategoria
FROM CursoCategoria
JOIN Cursos ON CursoCategoria.CursoID = Cursos.CursoID
JOIN Categorias ON CursoCategoria.CategoriaID = Categorias.CategoriaID;

-- Vista: Certificados emitidos con nombre del curso y usuario
CREATE OR ALTER VIEW Vista_Certificados AS
SELECT 
    Usuarios.Nombre AS NombreUsuario,
    Cursos.Titulo AS NombreCurso,
    Certificados.FechaEntrega
FROM Certificados
JOIN Usuarios ON Certificados.UsuarioID = Usuarios.UsuarioID
JOIN Cursos ON Certificados.CursoID = Cursos.CursoID;

-- Vista: Número de usuarios inscritos por curso
CREATE OR ALTER VIEW Vista_UsuariosPorCurso AS
SELECT 
    Cursos.Titulo AS NombreCurso,
    COUNT(*) AS TotalInscritos
FROM CursoUsuario
JOIN Cursos ON CursoUsuario.CursoID = Cursos.CursoID
GROUP BY Cursos.Titulo;

-- Vista: Instructores con su especialidad
CREATE OR ALTER VIEW Vista_Instructores AS
SELECT 
    InstructorID,
    Nombre AS NombreInstructor,
    Especialidad
FROM Instructores;

-- Reporte 1: Usuarios que no tienen certificados
SELECT Nombre AS NombreUsuario
FROM Usuarios
WHERE UsuarioID NOT IN (
    SELECT UsuarioID FROM Certificados
);

-- Reporte 2: Cursos con más de un inscrito
SELECT 
    Cursos.Titulo AS NombreCurso,
    COUNT(*) AS CantidadInscritos
FROM CursoUsuario
JOIN Cursos ON CursoUsuario.CursoID = Cursos.CursoID
GROUP BY Cursos.Titulo
HAVING COUNT(*) > 1;

-- Reporte 3: Cursos sin ningún inscrito
SELECT Titulo AS NombreCurso
FROM Cursos
WHERE CursoID NOT IN (
    SELECT CursoID FROM CursoUsuario
);

-- Reporte 4: Categorías ordenadas por cantidad de cursos
SELECT 
    Categorias.Nombre AS NombreCategoria,
    COUNT(*) AS TotalCursos
FROM CursoCategoria
JOIN Categorias ON CursoCategoria.CategoriaID = Categorias.CategoriaID
GROUP BY Categorias.Nombre
ORDER BY TotalCursos DESC;

-- Reporte 5: Usuarios inscritos en más de un curso
SELECT 
    Usuarios.Nombre AS NombreUsuario,
    COUNT(*) AS CursosInscritos
FROM CursoUsuario
JOIN Usuarios ON CursoUsuario.UsuarioID = Usuarios.UsuarioID
GROUP BY Usuarios.Nombre
HAVING COUNT(*) > 1;