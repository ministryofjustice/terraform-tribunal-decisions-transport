create table dbo.CATEGORY
(
	num tinyint identity
		constraint category_pk
			primary key,
	description varchar(100) not null
);
go

CREATE PROCEDURE [dbo].[spGetCategoryList] 
AS
SELECT num, [description]
FROM category
ORDER BY num
;
go



CREATE PROCEDURE [dbo].[spGetDecision] 

@DecisionId  int

AS

select j.*, s.[description] as subcategory, s.[id] as subcatid, c.[description] as category, c.num as catid,
	s2.[description] as secsubcategory, s2.[id] as secsubcatid, c2.[description] as seccategory, c2.num as seccatid 
from judgment j
inner join subcategory s on j.main_subcategory_id = s.id
inner join category c on s.parent_num = c.num
left join subcategory s2 on j.sec_subcategory_id = s2.id
left join category c2 on s2.parent_num = c2.num
where j.[id] = @DecisionId
;
go

