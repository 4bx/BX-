FUNCTION  f_recuperar_ruta(extencion)
DEFINE ruta STRING 
DEFINE extencion STRING 
  CALL WINOPENFILE(null,extencion,null,extencion) RETURNING ruta
  DISPLAY ruta 
  RETURN ruta
END FUNCTION 

FUNCTION f_validaCargaAnterior()
DEFINE li_countRegistros INTEGER 
  SELECT count(*)
    INTO li_countRegistros
    FROM carga_jira  
  
  IF li_countRegistros > 0 THEN
    RETURN TRUE 
  ELSE
    RETURN FALSE 
  END IF 
END FUNCTION 

FUNCTION fn_PreguntaSiNo(ls_texto)
DEFINE ls_texto STRING
DEFINE lb_aceptar SMALLINT

  MENU
      ATTRIBUTE (STYLE = "dialog" ,COMMENT = ls_texto, IMAGE = "Question")
    ON ACTION Aceptar
      LET lb_aceptar = TRUE 
      EXIT MENU 
    ON ACTION CANCEL 
      LET lb_aceptar = FALSE
      EXIT MENU
  END MENU 
  RETURN lb_aceptar
END FUNCTION

FUNCTION fn_messageAlert(ls_texto)
DEFINE ls_texto STRING 

  MENU "Alerta"
      ATTRIBUTE (STYLE = "dialog" ,COMMENT = ls_texto, IMAGE = "exclamation")
    ON ACTION Aceptar
      EXIT MENU 
  END MENU 
END FUNCTION


FUNCTION fn_message(ls_texto)
DEFINE ls_texto STRING 

  MENU "Advertencia"
      ATTRIBUTE (STYLE = "dialog" ,COMMENT = ls_texto, IMAGE = "exclamation")
    ON ACTION Aceptar
      EXIT MENU 
  END MENU 
END FUNCTION

FUNCTION LimpiatablaCarga()
   BEGIN WORK
   TRUNCATE TABLE carga_jira
   COMMIT WORK
end FUNCTION  