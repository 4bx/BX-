SELECT * FROM carga_jira;
select * from actividad_jira;
select * from h_actividad_jira;

truncate table h_actividad_jira;
truncate table actividad_jira;
truncate table carga_jira;

select * from usuarios
where nombre ="Margarita Arellano"
OR nombre ="Agustin Gutierrez";


SELECT * FROM carga_jira;

SELECT * FROM actividad_jira
where key_ = "BXMPRJ-1004"
;

select count(*) 
-- delete 
from actividad_jira
where c_status != "1" AND c_status != "c";

select count(*) 
-- delete 
from h_actividad_jira
where c_status = "";

select count(*) 
-- delete 
from h_actividad_jira
where c_status = "1" or c_status = "c";

SELECT * FROM actividad_jira
;

select * from empresas;

select * from actividad_jira
where c_status = "1";

select count(*) from actividad_jira
where c_status = "1";


select distinct c_status from actividad_jira;


update actividad_jira
set c_status = "c"
where status = "Closed";

SELECT * FROM usuarios
WHERE nombre = "Unassigned";
insert into usuarios values("Unassigned",0);

select * from empresas;
insert into empresas values(0,"Unassigned");
