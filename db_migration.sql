create database transport5;

CREATE LOGIN testuser5 WITH PASSWORD = 12345678 [ WITH DEFAULT_DATABASE = transport5];

CREATE PROCEDURE [dbo].[spGetCategoryList] 
AS
SELECT num, [description]
FROM category
ORDER BY num
go;