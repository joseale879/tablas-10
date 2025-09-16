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

        -- Tabla de categor�as
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

        -- Tabla pivote: curso-categor�a
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
('Luis P�rez', 'luis@gmail.com'),
('Mar�a L�pez', 'maria@gmail.com'),
('Juan R�os', 'juanr@gmail.com'),
('Carmen D�az', 'carmen@gmail.com'),
('Pedro Mu�oz', 'pedro@gmail.com'),
('Luc�a Fern�ndez', 'lucia@gmail.com'),
('Hugo Ortega', 'hugo@gmail.com'),
('Sof�a Romero', 'sofia@gmail.com'),
('Diego Vargas', 'diego@gmail.com');

-- Cursos
INSERT INTO Cursos (Titulo, Descripcion) VALUES
('Curso HTML', 'Introducci�n al HTML'),
('Curso CSS', 'Estilos con CSS'),
('Curso JS', 'JavaScript B�sico'),
('Curso SQL', 'Bases de datos con SQL'),
('Curso Python', 'Python desde cero'),
('Curso Excel', 'Excel avanzado'),
('Curso Marketing', 'Marketing digital'),
('Curso UX', 'Dise�o UX/UI'),
('Curso Power BI', 'Visualizaci�n de datos'),
('Curso WordPress', 'Sitios con WordPress');

-- Categor�as
INSERT INTO Categorias (Nombre) VALUES
('Programaci�n'),
('Dise�o'),
('Marketing'),
('Ofim�tica'),
('Datos'),
('Bases de Datos'),
('Web'),
('Negocios'),
('Educaci�n'),
('Tecnolog�a');

-- Instructores
INSERT INTO Instructores (Nombre, Especialidad) VALUES
('Carlos Ruiz', 'Programaci�n Web'),
('Laura Medina', 'Dise�o UX/UI'),
('Jorge Silva', 'Marketing'),
('Ana Beltr�n', 'Educaci�n Digital'),
('Esteban Cruz', 'An�lisis de Datos'),
('Paula Ortiz', 'Bases de Datos'),
('Nicol�s Bravo', 'Negocios Online'),
('Sandra Ramos', 'Visualizaci�n de Datos'),
('Diego Pe�a', 'Tecnolog�as Web'),
('Mar�a G�mez', 'Productividad y Ofim�tica');

-- Certificados
INSERT INTO Certificados (UsuarioID, CursoID) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Curso-Categor�a
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

-- Vista: Cursos con sus categor�as
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

-- Vista: N�mero de usuarios inscritos por curso
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

-- Reporte 2: Cursos con m�s de un inscrito
SELECT 
    Cursos.Titulo AS NombreCurso,
    COUNT(*) AS CantidadInscritos
FROM CursoUsuario
JOIN Cursos ON CursoUsuario.CursoID = Cursos.CursoID
GROUP BY Cursos.Titulo
HAVING COUNT(*) > 1;

-- Reporte 3: Cursos sin ning�n inscrito
SELECT Titulo AS NombreCurso
FROM Cursos
WHERE CursoID NOT IN (
    SELECT CursoID FROM CursoUsuario
);

-- Reporte 4: Categor�as ordenadas por cantidad de cursos
SELECT 
    Categorias.Nombre AS NombreCategoria,
    COUNT(*) AS TotalCursos
FROM CursoCategoria
JOIN Categorias ON CursoCategoria.CategoriaID = Categorias.CategoriaID
GROUP BY Categorias.Nombre
ORDER BY TotalCursos DESC;

-- Reporte 5: Usuarios inscritos en m�s de un curso
SELECT 
    Usuarios.Nombre AS NombreUsuario,
    COUNT(*) AS CursosInscritos
FROM CursoUsuario
JOIN Usuarios ON CursoUsuario.UsuarioID = Usuarios.UsuarioID
GROUP BY Usuarios.Nombre
HAVING COUNT(*) > 1;