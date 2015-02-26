-- limpieza de base archivo 20/02/2015
SET SQL_SAFE_UPDATES=0;
UPDATE actividad_jira
SET c_status = "c"
	where key_ = "BXMPRJ-1296"
	and c_status = "1";

update  actividad_jira
set  assignee = "Alejandra Ivonne González Venancio"
where assignee like "Alejandra Ivonne Gonz%";

update  actividad_jira
set  assignee = "Cesar Guzmán"
where assignee like "Cesar G%";

update  actividad_jira
set  assignee = "Erick Vázquez"
where assignee like "Erick Va%";

update  actividad_jira
set  assignee = "Juan Carlos Fernández"
where assignee like "Juan Carlos Fern%";

update  actividad_jira
set  assignee = "German Gomez"
where assignee like "german g%";

update  h_actividad_jira
set  assignee = "Alejandra Ivonne González Venancio"
where assignee like "Alejandra Ivonne Gonz%";

update  h_actividad_jira
set  assignee = "Cesar Guzmán"
where assignee like "Cesar G%";

update  h_actividad_jira
set  assignee = "Erick Vázquez"
where assignee like "Erick Va%";

update  h_actividad_jira
set  assignee = "Juan Carlos Fernández"
where assignee like "Juan Carlos Fern%";

update  h_actividad_jira
set  assignee = "German Gomez"
where assignee like "german g%";

delete from actividad_jira
where issue_type = "Delivery";

delete from actividad_jira
where assignee = "Unassigned";

delete from h_actividad_jira
where issue_type = "Delivery";

delete from h_actividad_jira
where assignee = "Unassigned";