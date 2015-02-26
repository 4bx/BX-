select c_status, paso, key_, issue_type, status, 
		priority, summary, description, reporter, 
		assignee, e.empresa,
		concat(date_format(current_date(), '%Y/%m/%d '),time_format(current_time(),'%H:%i:%S')) as fecha_del_dia, 
		concat(date_format(fecha_creacion_created, '%Y/%m/%d '),time_format(fecha_creacion_created,'%H:%i:%S'))as fecha_creacion_created, 
		concat(date_format(dias_transcurridos_al_dia, '%Y/%m/%d '),time_format(dias_transcurridos_al_dia,'%H:%i:%S')) as dias_transcurridos_al_dia,
		concat(date_format(fecha_prometida__vs_ns, '%Y/%m/%d '),time_format(fecha_prometida__vs_ns,'%H:%i:%S')) as fecha_prometida__vs_ns, 
		concat(date_format(fecha_prometida__due_date, '%Y/%m/%d '),time_format(fecha_prometida__due_date,'%H:%i:%S')) as fecha_prometida__due_date, 
		dias_ret_vs_f_prom_ns, dias_ret_vs_f_prom_due_date, 
		dias_brecha,
		concat(date_format(fecha_cierre_resolved, '%Y/%m/%d '),time_format(fecha_cierre_resolved,'%H:%i:%S')) as fecha_cierre_resolved, 
		cumplio_ns, cumplio_fp, dias_efectivos, labels, 
		nivel_servicio, 
		concat(date_format(fecha_reincidencia_1, '%Y/%m/%d '),time_format(fecha_reincidencia_1,'%H:%i:%S')) as fecha_reincidencia_1, 
		concat(date_format(fecha_reincidencia_2, '%Y/%m/%d '),time_format(fecha_reincidencia_2,'%H:%i:%S')) as fecha_reincidencia_2, 
		concat(date_format(fecha_reincidencia_3, '%Y/%m/%d '),time_format(fecha_reincidencia_3,'%H:%i:%S')) as fecha_reincidencia_3, 
		concat(date_format(fecha_reincidencia_4, '%Y/%m/%d '),time_format(fecha_reincidencia_4,'%H:%i:%S')) as fecha_reincidencia_4, 
		sow3, 
		concat(date_format(fecha_autorizacion, '%Y/%m/%d '),time_format(fecha_autorizacion,'%H:%i:%S')) as fecha_autorizacion, 
		dias_autorizacion, raiz_wa 
from actividad_jira
inner join usuarios u
on assignee = u.nombre
inner join empresas e
on u.c_empresa = e.c_empresa;

select 	c_status, paso, key_, issue_type, status, 
		priority, summary, description, reporter, 
		assignee, e.empresa,
		concat(date_format(current_date(), '%Y/%m/%d '),time_format(current_time(),'%H:%i:%S')) as fecha_del_dia, 
		concat(date_format(fecha_creacion_created, '%Y/%m/%d '),time_format(fecha_creacion_created,'%H:%i:%S'))as fecha_creacion_created, 
		concat(date_format(dias_transcurridos_al_dia, '%Y/%m/%d '),time_format(dias_transcurridos_al_dia,'%H:%i:%S')) as dias_transcurridos_al_dia,
		concat(date_format(fecha_prometida__vs_ns, '%Y/%m/%d '),time_format(fecha_prometida__vs_ns,'%H:%i:%S')) as fecha_prometida__vs_ns, 
		concat(date_format(fecha_prometida__due_date, '%Y/%m/%d '),time_format(fecha_prometida__due_date,'%H:%i:%S')) as fecha_prometida__due_date, 
		dias_ret_vs_f_prom_ns, dias_ret_vs_f_prom_due_date, 
		dias_brecha,
		concat(date_format(fecha_cierre_resolved, '%Y/%m/%d '),time_format(fecha_cierre_resolved,'%H:%i:%S')) as fecha_cierre_resolved, 
		cumplio_ns, cumplio_fp, dias_efectivos, labels, 
		nivel_servicio, 
		concat(date_format(fecha_reincidencia_1, '%Y/%m/%d '),time_format(fecha_reincidencia_1,'%H:%i:%S')) as fecha_reincidencia_1, 
		concat(date_format(fecha_reincidencia_2, '%Y/%m/%d '),time_format(fecha_reincidencia_2,'%H:%i:%S')) as fecha_reincidencia_2, 
		concat(date_format(fecha_reincidencia_3, '%Y/%m/%d '),time_format(fecha_reincidencia_3,'%H:%i:%S')) as fecha_reincidencia_3, 
		concat(date_format(fecha_reincidencia_4, '%Y/%m/%d '),time_format(fecha_reincidencia_4,'%H:%i:%S')) as fecha_reincidencia_4, 
		sow3, 
		concat(date_format(fecha_autorizacion, '%Y/%m/%d '),time_format(fecha_autorizacion,'%H:%i:%S')) as fecha_autorizacion, 
		dias_autorizacion, raiz_wa 

from h_actividad_jira
inner join usuarios u
on assignee = u.nombre
inner join empresas e
on u.c_empresa = e.c_empresa;