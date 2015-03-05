select c_status, paso, key_, issue_type, status, 
		priority, summary, description, reporter, 
		assignee, e.empresa,
		concat(date_format(current_date(), '%d/%m/%Y '),time_format(current_time(),'%H:%i:%S')) as fecha_del_dia, 		
		concat(date_format(fecha_creacion_created, '%d/%m/%Y '),time_format(fecha_creacion_created,'%H:%i:%S'))as fecha_creacion_created, 
		concat(date_format(fecha_inicio, '%d/%m/%Y '),time_format(fecha_inicio,'%H:%i:%S'))as fecha_inicio, 
	DATEDIFF(current_date(),fecha_inicio) as dias_transcurridos_al_dia,
		-- concat(date_format(dias_transcurridos_al_dia, '%d/%m/%Y '),time_format(dias_transcurridos_al_dia,'%H:%i:%S')) as dias_transcurridos_al_dia,

	concat(date_format(date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day ) , '%d/%m/%Y '),time_format(date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day ),'%H:%i:%S')) as fecha_prometida__vs_ns, 
		-- concat(date_format(fecha_prometida__vs_ns, '%d/%m/%Y '),time_format(fecha_prometida__vs_ns,'%H:%i:%S')) as fecha_prometida__vs_ns, 
		concat(date_format(fecha_prometida__due_date, '%d/%m/%Y '),time_format(fecha_prometida__due_date,'%H:%i:%S')) as fecha_prometida__due_date, 
	-- dias_ret_vs_f_prom_ns, 
	CASE WHEN fecha_cierre_resolved is null THEN datediff(current_date(), date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) ELSE datediff(fecha_cierre_resolved,date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) END  as dias_ret_vs_f_prom_ns,
	-- dias_ret_vs_f_prom_due_date, 
	CASE WHEN fecha_prometida__due_date IS NULL
				THEN "Sin Fecha"
				ELSE CASE WHEN fecha_cierre_resolved IS NULL
						  THEN datediff(current_date(), fecha_prometida__due_date)
						  ELSE datediff(fecha_cierre_resolved,date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day )) 
					 END
	END as dias_ret_vs_f_prom_due_date,
   DATEDIFF(current_date(),fecha_creacion_created) as dias_brecha,
		-- dias_brecha,
		concat(date_format(fecha_cierre_resolved, '%d/%m/%Y '),time_format(fecha_cierre_resolved,'%H:%i:%S')) as fecha_cierre_resolved,
	-- cumplio_ns, 
	case when fecha_cierre_resolved is not null AND CASE WHEN fecha_cierre_resolved is null THEN datediff(current_date(), date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) ELSE datediff(fecha_cierre_resolved,date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) END  <= 0 then "Cumplió" else "No Cumplió" end as cumplio_ns,
	-- cumplio_fp, 
	case when fecha_cierre_resolved is not null AND (CASE WHEN fecha_cierre_resolved is null THEN datediff(current_date(), date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) ELSE datediff(fecha_cierre_resolved,date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) END  <= 0) then "Cumplió" else case when datediff(fecha_cierre_resolved,date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) is null then "Sin Fecha" else "No Cumplió" end end  as cumplio_fp ,
	-- dias_efectivos,
	case when fecha_cierre_resolved is null then datediff(current_date(),fecha_creacion_created) else datediff(fecha_cierre_resolved,fecha_creacion_created) end as dias_efectivos,
		labels, 
	-- nivel_servicio, 
	case when nivel_servicio = "Enhancement" then 5 else 1 end as nivel_servicio ,
		concat(date_format(fecha_reincidencia_1, '%d/%m/%Y '),time_format(fecha_reincidencia_1,'%H:%i:%S')) as fecha_reincidencia_1, 
		concat(date_format(fecha_reincidencia_2, '%d/%m/%Y '),time_format(fecha_reincidencia_2,'%H:%i:%S')) as fecha_reincidencia_2, 
		concat(date_format(fecha_reincidencia_3, '%d/%m/%Y '),time_format(fecha_reincidencia_3,'%H:%i:%S')) as fecha_reincidencia_3, 
		concat(date_format(fecha_reincidencia_4, '%d/%m/%Y '),time_format(fecha_reincidencia_4,'%H:%i:%S')) as fecha_reincidencia_4, 
		sow3, 
		concat(date_format(fecha_autorizacion, '%d/%m/%Y '),time_format(fecha_autorizacion,'%H:%i:%S')) as fecha_autorizacion, 
		dias_autorizacion, raiz_wa 
from actividad_jira
inner join usuarios u
on assignee = u.nombre
inner join empresas e
on u.c_empresa = e.c_empresa

union all 


select c_status, paso, key_, issue_type, status, 
		priority, summary, description, reporter, 
		assignee, e.empresa,
		concat(date_format(current_date(), '%d/%m/%Y '),time_format(current_time(),'%H:%i:%S')) as fecha_del_dia, 		
		concat(date_format(fecha_creacion_created, '%d/%m/%Y '),time_format(fecha_creacion_created,'%H:%i:%S'))as fecha_creacion_created, 
		concat(date_format(fecha_inicio, '%d/%m/%Y '),time_format(fecha_inicio,'%H:%i:%S'))as fecha_inicio, 
	DATEDIFF(current_date(),fecha_inicio) as dias_transcurridos_al_dia,
		-- concat(date_format(dias_transcurridos_al_dia, '%d/%m/%Y '),time_format(dias_transcurridos_al_dia,'%H:%i:%S')) as dias_transcurridos_al_dia,

	concat(date_format(date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day ) , '%d/%m/%Y '),time_format(date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day ),'%H:%i:%S')) as fecha_prometida__vs_ns, 
		-- concat(date_format(fecha_prometida__vs_ns, '%d/%m/%Y '),time_format(fecha_prometida__vs_ns,'%H:%i:%S')) as fecha_prometida__vs_ns, 
		concat(date_format(fecha_prometida__due_date, '%d/%m/%Y '),time_format(fecha_prometida__due_date,'%H:%i:%S')) as fecha_prometida__due_date, 
	-- dias_ret_vs_f_prom_ns, 
	CASE WHEN fecha_cierre_resolved is null THEN datediff(current_date(), date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) ELSE datediff(fecha_cierre_resolved,date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) END  as dias_ret_vs_f_prom_ns,
	-- dias_ret_vs_f_prom_due_date, 
	CASE WHEN fecha_prometida__due_date IS NULL
				THEN "Sin Fecha"
				ELSE CASE WHEN fecha_cierre_resolved IS NULL
						  THEN datediff(current_date(), fecha_prometida__due_date)
						  ELSE datediff(fecha_cierre_resolved,date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day )) 
					 END
	END as dias_ret_vs_f_prom_due_date,
   DATEDIFF(current_date(),fecha_creacion_created) as dias_brecha,
		-- dias_brecha,
		concat(date_format(fecha_cierre_resolved, '%d/%m/%Y '),time_format(fecha_cierre_resolved,'%H:%i:%S')) as fecha_cierre_resolved,
	-- cumplio_ns, 
	case when fecha_cierre_resolved is not null AND CASE WHEN fecha_cierre_resolved is null THEN datediff(current_date(), date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) ELSE datediff(fecha_cierre_resolved,date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) END  <= 0 then "Cumplió" else "No Cumplió" end as cumplio_ns,
	-- cumplio_fp, 
	case when fecha_cierre_resolved is not null AND (CASE WHEN fecha_cierre_resolved is null THEN datediff(current_date(), date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) ELSE datediff(fecha_cierre_resolved,date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) END  <= 0) then "Cumplió" else case when datediff(fecha_cierre_resolved,date_add(fecha_inicio ,interval case when nivel_servicio = "Enhancement" then 5 else 1 end day)) is null then "Sin Fecha" else "No Cumplió" end end  as cumplio_fp ,
	-- dias_efectivos,
	case when fecha_cierre_resolved is null then datediff(current_date(),fecha_creacion_created) else datediff(fecha_cierre_resolved,fecha_creacion_created) end as dias_efectivos,
		labels, 
	-- nivel_servicio, 
	case when nivel_servicio = "Enhancement" then 5 else 1 end as nivel_servicio ,
		concat(date_format(fecha_reincidencia_1, '%d/%m/%Y '),time_format(fecha_reincidencia_1,'%H:%i:%S')) as fecha_reincidencia_1, 
		concat(date_format(fecha_reincidencia_2, '%d/%m/%Y '),time_format(fecha_reincidencia_2,'%H:%i:%S')) as fecha_reincidencia_2, 
		concat(date_format(fecha_reincidencia_3, '%d/%m/%Y '),time_format(fecha_reincidencia_3,'%H:%i:%S')) as fecha_reincidencia_3, 
		concat(date_format(fecha_reincidencia_4, '%d/%m/%Y '),time_format(fecha_reincidencia_4,'%H:%i:%S')) as fecha_reincidencia_4, 
		sow3, 
		concat(date_format(fecha_autorizacion, '%d/%m/%Y '),time_format(fecha_autorizacion,'%H:%i:%S')) as fecha_autorizacion, 
		dias_autorizacion, raiz_wa 
from h_actividad_jira
inner join usuarios u
on assignee = u.nombre
inner join empresas e
on u.c_empresa = e.c_empresa;
