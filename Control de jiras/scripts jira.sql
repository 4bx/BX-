SELECT * FROM carga_jira;
select * from actividad_jira;
select * from h_actividad_jira;

truncate table h_actividad_jira;
truncate table actividad_jira;
truncate table carga_jira;

select * from usuarios
where nombre ="Margarita Arellano"
OR nombre ="Agustin Gutierrez";

SELECT * FROM actividad_jira
where key_ = "BXMPRJ-31"
;

select count(*) 
-- delete 
from actividad_jira
where c_status != "1" AND c_status != "c";

select count(*) 
-- delete 
from h_actividad_jira
where c_status = "";

SELECT count(*) FROM h_actividad_jira
;

SELECT count(*) FROM actividad_jira
;

select count(*) 
-- delete 
from h_actividad_jira
where c_status = "1" or c_status = "c";

SELECT * FROM carga_jira
;

select * from empresas;

select count(*) from actividad_jira;
select count(*) from h_actividad_jira;


select distinct c_status from actividad_jira;