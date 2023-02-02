create database ${NEW_DB_NAME};

CREATE LOGIN ${NEW_USER_NAME} WITH PASSWORD = ${NEW_PASSWORD} [ WITH DEFAULT_DATABASE = ${NEW_DB_NAME}];

CREATE PROCEDURE [dbo].[spGetCategoryList] 
AS
SELECT num, [description]
FROM category
ORDER BY num
go;