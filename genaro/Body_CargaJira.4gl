SCHEMA tecnoparque 

FUNCTION  f_recuperar_ruta()
DEFINE ruta STRING 
  CALL WINOPENFILE(null,"xls","xls","xls") RETURNING ruta
  DISPLAY ruta 
  RETURN ruta
END FUNCTION 

FUNCTION  f_ejecutar_carga(ruta)
DEFINE ruta STRING
DEFINE intruccion STRING
DEFINE resultado INTEGER
LET intruccion = "java -jar C:\\Users\\erodriguez\\Desktop\\proyectos\\BX+\\genaro\\bin\\CargaArchivo\\CargaArchivoDiario.jar "  
LET ruta = '"'||ruta||'"'
DISPLAY intruccion || ruta 
  RUN intruccion || ruta RETURNING resultado
IF resultado = 0 THEN 
  CALL FGL_WINMESSAGE( "Information", "La carga termino correctamente", "exclamation" )
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
    CALL f_validaRegistro(r_carga.key_ ,r_carga.issue_type,r_carga.status_,r_carga.assignee) 
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
  
  --CALL ar_carga_update.deleteElement(ar_carga_update.getLength())
  --CALL ar_carga_new.deleteElement(ar_carga_new.getLength())
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
    CALL FGL_WINMESSAGE( "Information", "La carga termino correctamente", "exclamation" )
  ELSE
    CALL FGL_WINMESSAGE( "Alert", "La carga NO termino correctamente", "alert" )
  END IF 
END FUNCTION 

FUNCTION f_cargaRegistro (r_carga)
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
    assignee LIKE carga_jira.assignee
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
                                          AND (issue_type !=  ?  OR  STATUS != ? 
                                            or (u1.c_empresa != u2.c_empresa or (u1.c_empresa = u2.c_empresa AND u1.c_empresa <>  2))) "
                             
    DECLARE C_REGISTRO CURSOR FOR p_registro
    LET lb_bandera_jira_nuevo =  0
    LET li_count = 1 
    FOREACH C_REGISTRO USING r_validacion.assignee, r_validacion.KEY_ , r_validacion.issue_type 
                            ,r_validacion.status_ 
                           INTO ar_registro.*
                           
        DISPLAY li_registros," - ", ar_registro.KEY_," - ",ar_registro.issue_type," - ", ar_registro.status," - ",ar_registro.assignee
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
      LET ar_actividad.fecha_cierre_resolved = r_carga.resolved
      LET ar_actividad.c_status = "c"

      UPDATE actividad_jira
      SET issue_type = r_carga.issue_type,
          status = r_carga.status_,
          assignee = r_carga.assignee
        WHERE KEY_ =  r_carga.key_
    ELSE
      --actualizacion de registro activo
      IF ar_actividad.c_status = 1 THEN 
       --HISTORICO
        LET ar_actividad.c_status = " "
        LET ar_actividad.fecha_cierre_resolved = r_carga.updated
        INSERT INTO h_actividad_jira VALUES (ar_actividad.*)
        
       --ACTUALIZACION
        LET ar_actividad.c_status = "1"
        UPDATE actividad_jira
        SET issue_type = r_carga.issue_type,
            STATUS = r_carga.status_,
            assignee = r_carga.assignee,
            fecha_inicio = r_carga.updated
          WHERE KEY_ =  r_carga.key_
      ELSE 
        --actualizacion de archivo re-abierto
        --HISTORICO
        LET ar_actividad.c_status = "c"
        LET ar_actividad.fecha_cierre_resolved = r_carga.updated
        IF ar_actividad.key_ IS NULL THEN
          COMMIT WORK
          RETURN 
        END IF 
          INSERT INTO h_actividad_jira VALUES (ar_actividad.*)
          --ACTUALIZACION
        CASE
          WHEN  ar_actividad.fecha_reincidencia_1 IS NULL 
            LET ar_actividad.fecha_reincidencia_1 = ar_actividad.fecha_cierre_resolved
          WHEN  ar_actividad.fecha_reincidencia_2 IS NULL 
            LET ar_actividad.fecha_reincidencia_2 = ar_actividad.fecha_cierre_resolved  
          WHEN  ar_actividad.fecha_reincidencia_3 IS NULL 
            LET ar_actividad.fecha_reincidencia_3 = ar_actividad.fecha_cierre_resolved  
          WHEN  ar_actividad.fecha_reincidencia_4 IS NULL 
            LET ar_actividad.fecha_reincidencia_4 = ar_actividad.fecha_cierre_resolved    
        END CASE 
        LET ar_actividad.fecha_creacion_created = r_carga.updated
        LET ar_actividad.c_status = "1"
        UPDATE actividad_jira
        SET issue_type = r_carga.issue_type,
            status = r_carga.status_,
            assignee = r_carga.assignee,
            fecha_inicio = r_carga.updated
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
  
  LET ar_actividad.c_status     = "1"
  LET ar_actividad.paso         = "new"
  LET ar_actividad.key_         = r_carga.key_
  LET ar_actividad.issue_type   = r_carga.issue_type
  LET ar_actividad.status       = r_carga.status_
  LET ar_actividad.priority     = r_carga.priority
  LET ar_actividad.summary      = r_carga.summary
  LET ar_actividad.description  = r_carga.description
  LET ar_actividad.reporter     = r_carga.reporter
  LET ar_actividad.assignee     = r_carga.assignee

  LET ar_actividad.assignee     = r_carga.assignee
  LET ar_actividad.fecha_creacion_created = r_carga.created
  LET ar_actividad.fecha_inicio = r_carga.created
  LET ar_actividad.labels = r_carga.labels
  
  INSERT INTO actividad_jira VALUES (ar_actividad.*)
  COMMIT WORK 
END FUNCTION 


FUNCTION reporte()    
DEFINE hd om.SaxDocumentHandler -- report handler
DEFINE li_count INTEGER 
define ar_registros DYNAMIC ARRAY OF RECORD LIKE actividad_jira.*
--call the mandatory functions that configure the report

PREPARE  p_registros FROM "select * from actividad_jira where c_status = 1"
DECLARE c_registros CURSOR FOR p_registros
CALL ar_registros.clear()
LET li_count = li_count + 1
FOREACH c_registros INTO ar_registros[li_count].*
  LET li_count = li_count + 1 
END FOREACH
  
INITIALIZE hd TO null 
IF fgl_report_loadCurrentSettings("carga_jira.4rp") THEN
    CALL fgl_report_selectDevice("XLS")
    CALL fgl_report_configureXLSDevice(1, 1, 0,0, 0, 0,0)
    CALL fgl_report_setOutputFileName("prueba.xls")
    CALL fgl_report_selectPreview(TRUE)
    LET hd = fgl_report_commitCurrentSettings()      -- commit the file settings
ELSE
    EXIT PROGRAM
END IF

START REPORT jiras_completo TO XML HANDLER hd
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