MAIN
DEFINE ls_ruta STRING

CONNECT TO "tecnoparque"

OPTIONS INPUT WRAP
 
CLOSE WINDOW SCREEN 
OPEN WINDOW w1 WITH FORM "f_carga_jira" 
  INPUT ls_ruta
  WITHOUT DEFAULTS
     FROM
      ruta
  ATTRIBUTES (ACCEPT = FALSE ,CANCEL =FALSE)
    ON ACTION bt_ruta
      CALL f_recuperar_ruta() RETURNING ls_ruta
      DISPLAY ls_ruta TO ruta
      CALL ui.Interface.refresh()
    ON ACTION Cargar
        CALL f_ejecutar_carga(ls_ruta)
    ON ACTION reporte
      CALL reporte()
      
    ON ACTION validacion 
      CALL f_jira_nuevo()
      CALL LimpiatablaCarga()
      
    ON ACTION Salir 
        EXIT INPUT 
    END INPUT
CLOSE WINDOW w1
END MAIN  
