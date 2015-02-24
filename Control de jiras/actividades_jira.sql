CREATE TABLE `actividad_jira` (
  `c_status` varchar(1) NOT NULL,
  `paso` varchar(5) DEFAULT NULL,
  `key_` varchar(45) NOT NULL DEFAULT '',
  `issue_type` varchar(45) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `priority` varchar(45) DEFAULT NULL,
  `summary` varchar(300) DEFAULT NULL,
  `description` varchar(3000) DEFAULT NULL,
  `reporter` varchar(45) DEFAULT NULL,
  `assignee` varchar(45) DEFAULT NULL,
  `fecha_del_dia` datetime DEFAULT NULL,
  `fecha_creacion_created` datetime DEFAULT NULL,
  `fecha_inicio` datetime DEFAULT NULL,
  `dias_transcurridos_al_dia` int(11) DEFAULT NULL,
  `fecha_prometida__vs_ns` datetime DEFAULT NULL,
  `fecha_prometida__due_date` datetime DEFAULT NULL,
  `dias_ret_vs_f_prom_ns` int(11) DEFAULT NULL,
  `dias_ret_vs_f_prom_due_date` int(11) DEFAULT NULL,
  `dias_brecha` int(11) DEFAULT NULL,
  `fecha_cierre_resolved` datetime DEFAULT NULL,
  `cumplio_ns` smallint(6) DEFAULT NULL,
  `cumplio_fp` smallint(6) DEFAULT NULL,
  `dias_efectivos` int(11) DEFAULT NULL,
  `labels` varchar(45) DEFAULT NULL,
  `nivel_servicio` smallint(6) DEFAULT NULL,
  `fecha_reincidencia_1` datetime DEFAULT NULL,
  `fecha_reincidencia_2` datetime DEFAULT NULL,
  `fecha_reincidencia_3` datetime DEFAULT NULL,
  `fecha_reincidencia_4` datetime DEFAULT NULL,
  `sow3` smallint(6) DEFAULT NULL,
  `fecha_autorizacion` datetime DEFAULT NULL,
  `dias_autorizacion` smallint(6) DEFAULT NULL,
  `raiz_wa` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`key_`));