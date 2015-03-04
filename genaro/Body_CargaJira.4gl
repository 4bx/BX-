SCHEMA tecnoparque

FUNCTION  f_ejecutar_carga(ruta)
DEFINE ruta STRING
DEFINE intruccion STRING
DEFINE resultado INTEGER
DEFINE li_count  INTEGER

  IF f_validaCargaAnterior() > 0   THEN
    IF  fn_PreguntaSiNo("¿Eliminar carga anterior?") THEN 
      CALL LimpiatablaCarga() 
    ELSE 
      CALL fn_message("Existe carga, anterior no se puede realizar la carga")
      RETURN
    END IF 
  END IF
  
  LET intruccion = "java -jar C:\\Users\\erodriguez\\Desktop\\proyectos\\BX+\\genaro\\bin\\CargaArchivo\\CargaArchivoDiario.jar "  
  LET ruta = '"'||ruta||'"'
  IF LENGTH(ruta) = 0 THEN
    CALL fn_message("Se necesita la ruta para el archivo a cargar")
    RETURN 
  END IF 
  DISPLAY intruccion || ruta 
    RUN intruccion || ruta RETURNING resultado
  IF resultado = 0 THEN 
    SELECT COUNT(*) 
      INTO li_count
    FROM carga_jira 
    IF li_count > 0THEN 
      CALL fn_message(  "La carga termino correctamente" )
    END IF 
  END IF 
END FUNCTION 

FUNCTION f_jira_nuevo()
  DEFINE r_carga RECORD LIKE carga_jira.*
  DEFINE ar_carga_update DYNAMIC ARRAY OF RECORD LIKE carga_jira.*
  DEFINE ar_carga_new DYNAMIC ARRAY OF RECORD LIKE carga_jira.*
  DEFINE lb_bandera_jira_nuevo SMALLINT
  DEFINE li_count_update INTEGER
  DEFINE li_count_new INTEGER  

  PREPARE p_actividad FROM "SELECT * FROM carga_jira" 
  DECLARE  c_actividad CURSOR FOR p_actividad 
  LET li_count_update = 1
  LET li_count_new = 1
  
  FOREACH c_actividad INTO r_carga.*
    CALL f_validaRegistro(r_carga.key_ ,r_carga.issue_type,r_carga.status_,r_carga.assignee,r_carga.due_date,r_carga.updated) 
      RETURNING lb_bandera_jira_nuevo
      IF lb_bandera_jira_nuevo = -1 THEN
        LET ar_carga_new[li_count_new].* = r_carga.*
        LET li_count_new = li_count_new + 1
       ELSE
         IF lb_bandera_jira_nuevo = 1 THEN
            LET ar_carga_update[li_count_update].* = r_carga.*
            LET li_count_update = li_count_update + 1
         END IF 
    END IF 
  END FOREACH
  
  FREE c_actividad
  
  IF ar_carga_new.getLength() > 0  THEN 
    FOR li_count_new = 1 TO ar_carga_new.getLength()
      IF ar_carga_new[li_count_new].key_ IS NOT NULL THEN 
        CALL f_agregarRegistro(ar_carga_new[li_count_new].*)
      END IF 
    END FOR 
  END IF 
  IF ar_carga_update.getLength() > 0 THEN 
    FOR li_count_update = 1 TO ar_carga_update.getLength()
      IF ar_carga_update[li_count_update].key_ IS NOT NULL THEN 
        DISPLAY "para actualizar "," - ", ar_carga_update[li_count_update].KEY_," - ",ar_carga_update[li_count_update].issue_type," - ", ar_carga_update[li_count_update].status_," - ",ar_carga_update[li_count_update].assignee
        CALL f_modificaRegistro(ar_carga_update[li_count_update].*)
      END IF 
    END FOR 
  END IF 

  IF ar_carga_new.getLength() > 0 OR ar_carga_update.getLength() > 0 THEN 
    CALL fn_message("La carga termino correctamente" )
  ELSE
    CALL fn_messageAlert("La carga NO termino correctamente")
  END IF 
END FUNCTION 

FUNCTION f_cargaRegistroBase (r_carga)
  DEFINE r_carga RECORD LIKE carga_jira.*
  BEGIN WORK
  COMMIT WORK 
END FUNCTION 

FUNCTION  f_validaRegistro(r_validacion)
  DEFINE ar_registro  RECORD LIKE actividad_jira.*
  DEFINE lb_bandera_jira_nuevo SMALLINT
  DEFINE li_count INTEGER 
  DEFINE r_validacion RECORD 
      KEY_ LIKE carga_jira.key_,
      issue_type LIKE carga_jira.issue_type,
      status_ LIKE carga_jira.status_,
      assignee LIKE carga_jira.assignee,
      due_date LIKE carga_jira.due_date,
      update LIKE carga_jira.updated
    END RECORD 
  DEFINE li_registros SMALLINT

    LET li_registros = 0 
    DECLARE p_nuevo CURSOR FOR SELECT COUNT(*) FROM  actividad_jira WHERE key_ = ?
    EXECUTE p_nuevo USING r_validacion.KEY_ INTO li_registros  
    
    IF li_registros = 0 THEN
      LET lb_bandera_jira_nuevo =  -1
      RETURN lb_bandera_jira_nuevo
    END IF
    
    PREPARE  P_REGISTRO FROM     " SELECT * FROM actividad_jira
                                    left join  usuarios u1
                                      on u1.nombre = assignee
                                    left join usuarios u2
                                      on u2.nombre = ?
                                        WHERE  (c_status = '1' or c_status = 'c')
                                          AND KEY_  =  ?
                                          AND ((issue_type !=  ? and ? != 'Delivery')    
                                            OR  STATUS != ? 
                                            OR (u1.c_empresa != u2.c_empresa or (u1.c_empresa = u2.c_empresa AND u1.c_empresa <>  2))
                                            OR ((fecha_prometida__due_date is null AND ? is not null)
                                            OR (datediff(fecha_prometida__due_date,DATE_FORMAT(?,'%Y-%m-%d %T')) != 0 ))
                                            OR datediff(fecha_inicio,DATE_FORMAT(?,'%Y-%m-%d %T')) )"
                             
    DECLARE C_REGISTRO CURSOR FOR p_registro
    LET lb_bandera_jira_nuevo =  0
    LET li_count = 1 
    FOREACH C_REGISTRO USING r_validacion.assignee, r_validacion.KEY_ ,
                             r_validacion.issue_type,r_validacion.issue_type, 
                             r_validacion.status_ ,r_validacion.due_date,
                             r_validacion.due_date,r_validacion.due_date, r_validacion.update
                           INTO ar_registro.*
                           
        DISPLAY li_registros," - ", ar_registro.KEY_," - ",ar_registro.issue_type," - ", ar_registro.status," - ",ar_registro.assignee," - ",ar_registro.fecha_prometida__due_date
        LET lb_bandera_jira_nuevo =  1
    END FOREACH
    
  FREE C_REGISTRO
RETURN lb_bandera_jira_nuevo
END FUNCTION 

FUNCTION f_usuarioValidacion(assignee)
DEFINE lb_empresa  SMALLINT
DEFINE assignee VARCHAR(45)
  PREPARE p_usuario FROM " SELECT c_empresa "||
                         "   INTO lb_empresa"||
                         "   FROM u.usuarios, e.empresas "||
                         "  WHERE  u.c_empresa = e.c_empresa"||
                         "     AND u.nombre = ? "
                         
  EXECUTE p_usuario USING assignee RETURN lb_empresa
RETURN lb_empresa
END FUNCTION 

FUNCTION f_modificaRegistro(r_carga)
DEFINE r_carga RECORD LIKE carga_jira.*
DEFINE ar_actividad RECORD LIKE actividad_jira.*

  BEGIN WORK
    SELECT *
      INTO ar_actividad.* 
      FROM actividad_jira
    WHERE key_ = r_carga.key_
    AND (c_status = "1" OR c_status = "c") 
    
    IF r_carga.status_ = "Closed" THEN 
      UPDATE actividad_jira
      SET issue_type = r_carga.issue_type,
          status = r_carga.status_,
          assignee = r_carga.assignee,
          fecha_cierre_resolved = r_carga.resolved,
          fecha_prometida__due_date = r_carga.due_date,
          c_status = "c"
        WHERE KEY_ =  r_carga.key_
    ELSE
      --actualizacion de registro activo
      IF ar_actividad.c_status = 1 THEN 
       --HISTORICO
        LET ar_actividad.c_status = " "
        LET ar_actividad.fecha_cierre_resolved = r_carga.updated
        INSERT INTO h_actividad_jira VALUES (ar_actividad.*)
        
       --ACTUALIZACION
        UPDATE actividad_jira
        SET issue_type = r_carga.issue_type,
            STATUS = r_carga.status_,
            assignee = r_carga.assignee,
            fecha_inicio = r_carga.updated,
            fecha_prometida__due_date = r_carga.due_date,
            c_status = 1
          WHERE KEY_ =  r_carga.key_
      ELSE 
        --actualizacion de archivo re-abierto
        --HISTORICO
        LET ar_actividad.c_status = "c"
        
        IF ar_actividad.key_ IS NULL THEN
          COMMIT WORK
          RETURN 
        END IF 
          INSERT INTO h_actividad_jira VALUES (ar_actividad.*)
          --ACTUALIZACION
        CASE
          WHEN  ar_actividad.fecha_reincidencia_1 IS NULL 
            LET ar_actividad.fecha_reincidencia_1 = r_carga.updated
          WHEN  ar_actividad.fecha_reincidencia_2 IS NULL 
            LET ar_actividad.fecha_reincidencia_2 = r_carga.updated
          WHEN  ar_actividad.fecha_reincidencia_3 IS NULL 
            LET ar_actividad.fecha_reincidencia_3 = r_carga.updated
          WHEN  ar_actividad.fecha_reincidencia_4 IS NULL 
            LET ar_actividad.fecha_reincidencia_4 = r_carga.updated
        END CASE
        
        UPDATE actividad_jira
        SET issue_type = r_carga.issue_type,
            status = r_carga.status_,
            assignee = r_carga.assignee,
            fecha_inicio = r_carga.updated,
            fecha_creacion_created = r_carga.updated,
            fecha_prometida__due_date = r_carga.due_date,
            fecha_cierre_resolved = null,
            c_status = "1",
            fecha_reincidencia_1 = ar_actividad.fecha_reincidencia_1,
            fecha_reincidencia_2 = ar_actividad.fecha_reincidencia_2,
            fecha_reincidencia_3 = ar_actividad.fecha_reincidencia_3,
            fecha_reincidencia_4 = ar_actividad.fecha_reincidencia_4
          WHERE KEY_ =  r_carga.key_
      END IF  
    END IF 
  COMMIT WORK 
RETURN 
END FUNCTION   

FUNCTION f_agregarRegistro(r_carga)
DEFINE r_carga RECORD LIKE carga_jira.*
DEFINE ar_actividad RECORD LIKE actividad_jira.*

  BEGIN WORK
  IF r_carga.status_  = "Closed" THEN
    LET ar_actividad.c_status     = "c"
    LET ar_actividad.fecha_cierre_resolved     = r_carga.resolved
  ELSE 
    LET ar_actividad.c_status     = "1"
  END IF 
  
  LET ar_actividad.paso         = "new"
  LET ar_actividad.key_         = r_carga.key_
  LET ar_actividad.issue_type   = r_carga.issue_type
  LET ar_actividad.status       = r_carga.status_
  LET ar_actividad.priority     = r_carga.priority
  LET ar_actividad.summary      = r_carga.summary
  LET ar_actividad.description  = r_carga.description
  LET ar_actividad.reporter     = r_carga.reporter
  LET ar_actividad.assignee     = r_carga.assignee
  
  LET ar_actividad.fecha_prometida__due_date = r_carga.due_date
  LET ar_actividad.fecha_creacion_created = r_carga.created
  LET ar_actividad.fecha_inicio = r_carga.created
  LET ar_actividad.labels = r_carga.labels
  
  INSERT INTO actividad_jira VALUES (ar_actividad.*)
  COMMIT WORK 
END FUNCTION 

FUNCTION reporte()    
DEFINE HANDLER om.SaxDocumentHandler -- report handler
DEFINE li_count INTEGER 
define ar_registros DYNAMIC ARRAY OF RECORD LIKE actividad_jira.*
--call the mandatory functions that configure the report

PREPARE  p_registros FROM "select * from actividad_jira where c_status = 'c'"
DECLARE c_registros CURSOR FOR p_registros
CALL ar_registros.clear()
LET li_count = li_count + 1
FOREACH c_registros INTO ar_registros[li_count].*
  LET li_count = li_count + 1 
END FOREACH
  
INITIALIZE HANDLER TO NULL 

IF fgl_report_loadCurrentSettings("reporte_activos.4rp") THEN
    --CALL fgl_report_selectDevice("PDF")
    --CALL fgl_report_configureXLSDevice(1, 1, 0,0, 0, 0,0)
    --CALL fgl_report_setOutputFileName("activos")
    --CALL fgl_report_selectPreview(TRUE)
    CALL fgl_report_selectDevice("SVG")
    CALL fgl_report_selectPreview(TRUE)
    LET HANDLER = fgl_report_commitCurrentSettings()      -- commit the file settings
--ELSE
    --EXIT PROGRAM
END IF



START REPORT jiras_completo TO XML HANDLER HANDLER
    FOR li_count = 1 TO ar_registros.getLength() 
        OUTPUT TO REPORT jiras_completo(ar_registros[li_count].*)
    END FOR 
FINISH REPORT jiras_completo

END FUNCTION

REPORT jiras_completo(ar_registros)
define ar_registros RECORD LIKE actividad_jira.*

FORMAT
   FIRST PAGE HEADER
     ON EVERY ROW
       PRINTX ar_registros.*
END REPORT