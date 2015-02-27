/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package reportesjasper;

import java.io.FileWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.view.JasperViewer;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;

/**
 *
 * @author osantoyo
 */
public class ReportesJasper {
    
    
    //Conexion
    private Connection conn = null; //Conexion
    private String url = null; // url de la conexion de la base de datos
    private String driver = null; // nombre del driver a utilizar
    private String usuario = null; // usuario de la base de datos
    private String pass = null; // password de la base de datos
    
    //direcciones de funcionamiento (Se sugiere que se obtengan de un archivo xml)
    //final static String direccionArchivoConfiguracion = System.getenv("EXECUTIONCONTEXT")+"/config/configJ.xml";
    //final static String directorioPrincial = "C:/Desarrollo/Schlumberger/"; //System.getenv("EXECUTIONCONTEXT");
    
    private String directorioPrincial; 
    private String direccionArchivoConfiguracion;
    private String directorioJasper = null; // directorio de los jasper
    private String directorioReportes = null; // directorio donde se generaran los reportes
    
    //Parametros de java
    private String nombreJasper = null; //
    private String nombreArchivoSalida = null;
    private String tipoSalida = null; 
    private String parametros = null; //Parametros para el reporte
            
    //Variables necesarias para el funcionamiento 
    static Utileria utileria;// = new Utileria(direccionArchivoConfiguracion); //Objeto de utileria
    

    /**
     * @param args the command line arguments
     */
  public static void main(String[] args)   {
      
    ReportesJasper objetoMain = new ReportesJasper();
    objetoMain.GeneraReporte(args);
     

  }
public String obtieneVariableAmbiente(String variable){
    return System.getenv(variable);
}
  public void GeneraReporte(String [] args){
    directorioPrincial = obtieneVariableAmbiente("EXECUTIONCONTEXT");
    //directorioPrincial = "C:/Desarrollo/Schlumberger/";
    
    direccionArchivoConfiguracion = directorioPrincial+"/config/configJ.xml";
    
    System.out.println("directorio principal: "+directorioPrincial);
    
    if (directorioPrincial == null){
        System.out.println("Error: No se econtró la variable $EXECUTIONCONTEXT necesaria para la ejecución.");
        System.exit(-1);
    }
    
    utileria = new Utileria(direccionArchivoConfiguracion);
    
    if (args.length == 1){
        if (args[0].equals("DB")){
            //Utileria utileria = new Utileria(direccionArchivoConfiguracion);
            utileria.ConfiguraDB();
            
        }
        else
            System.out.println("Error: La cantidad de parámetros recibida es incorrecta, se recibieron: "+args.length+"; se esperaban 3.");
    }else{      
        /*
        * Valida que tenga los parametros minimos que son 3
        * El 4to argmento contiene los parametros, si no se recibe se da por hecho
        * que el reporte no requiere parametros
        */
        if(args.length < 3 ){ 
            System.out.println("Error: La cantidad de parámetros recibida es incorrecta, se recibieron: "+args.length+"; se esperaban 3.");
            System.exit(1);
        }

        
        //System.out.println("Cadena aqui!!");
        //System.out.println(directorioPrincial);

        this.nombreJasper = args[0];  // 0 Nombre del jasper a buscar
        this.nombreArchivoSalida = args[1]; // 1 Nombre que tendra el archivo de salida
        this.tipoSalida = args[2]; // 2 tipo de salida, las posibles son PDF, XLSX
        this.parametros = args[3]; // 3 Un String con todos los parametros que se requieran

        /* Configuracion de la base de datos */
        this.driver = utileria.getDriver();
        this.url =  utileria.getUrl();
        this.usuario =  utileria.getUser();
        this.pass =  utileria.getPassword();


        /*-----------------------------------------------------------------*/
        /* Esta informacion es temporal configuracion del reporte */
        this.directorioJasper = directorioPrincial+"/reportes/Jasper/";
        this.directorioReportes = directorioPrincial+"/reportes/Salida/";
        /*-----------------------------------------------------------------*/
        try {
        Class.forName(driver);
        }
        catch (ClassNotFoundException e) {
            utileria.Error("JDBC Driver not found.");
        //System.out.println();
        System.exit(1);
        }
        //Para iniciar el Logger.
        //inicializaLogger();
        try {
        conn = DriverManager.getConnection(url,usuario, pass); // Se inicializa la conexion para poder transmitirla al reporte
        conn.setAutoCommit(false);
        }
        catch (SQLException e) {
        System.out.println("Error de conexión: " + e.getMessage());
        System.exit(-1);
        }

        try {
        Map parameters = null; // mapeo para los parametros
        /*
        * Si se recibieron parametros entonces se realiza el mapeo
        */
        if (args.length >= 4) 
            parameters = utileria.ObtieneParametros(parametros);
        else
            utileria.Advertencia("No recibieron parametros para el reporte");

        // Se mezclan las variables para un mejor manejo
        this.nombreJasper = directorioJasper + nombreJasper;
        this.nombreArchivoSalida = directorioReportes + nombreArchivoSalida;

        System.out.println("Buscando JASPER en: "+nombreJasper);
        System.out.println("Guardando en: "+nombreArchivoSalida);
        // Se deben tener los jasper precompilados.
        JasperPrint print = JasperFillManager.fillReport(nombreJasper, parameters, conn);

        // Export the report to xlsx varias sheets
            //ArrayList<JasperPrint> jasperPrints = new ArrayList<JasperPrint>();
            //jasperPrints.add(print);
            //JRPdfExporter exp = new JRPdfExporter();
        //reportExporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);

        System.out.println("Jasper: "+nombreJasper);
        System.out.println("Parametros: "+parameters);
        System.out.println("Contexion: "+conn);

        if(tipoSalida.equals("PDF")){ // configuracion para salida PDF
            JasperExportManager.exportReportToPdfFile(print,nombreArchivoSalida+".pdf");
        }
        if(tipoSalida.equals("XLSX")){ //Configuracion para salida XLSX
            JRXlsxExporter exporter = new JRXlsxExporter();
            exporter.setParameter(JRXlsExporterParameter.JASPER_PRINT, print);
            exporter.setParameter(JRXlsExporterParameter.OUTPUT_FILE_NAME, nombreArchivoSalida+".xlsx");
            exporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
            exporter.setParameter(JRXlsExporterParameter.IS_DETECT_CELL_TYPE, Boolean.TRUE);
            exporter.exportReport();
        }

        //Para visualizar el pdf directamente desde java
        //JasperViewer.viewReport(print, false);
        }
        catch (Exception e) {
            System.out.println("Error");
            //System.exit(-1);
            e.printStackTrace();
        }
        finally {
        /*
        * Cleanup antes de salir
        */
        try {
            if (conn != null) {
            conn.rollback();
            //System.out.println("ROLLBACK EJECUTADO");
            conn.close();
            }
        }
        catch (Exception e) {
            System.out.println("Error");
            e.printStackTrace();
        }
        System.out.println("Ejecucion finalizada");
        }
    }
    /**
    *  Puedes descomentar esto si quieres instanciar  el loger. Necesitas la libreia log4j y el siguiente import
    *  import org.apache.log4j.*;
    *  Debes llamarlo desde el main.
    */
    /*
    static void inicializaLogger()
    {
                    PatternLayout pat = new PatternLayout(
                                    "[%-5p][%t] (%F:%L) : %m%n");
                    Logger.getRootLogger().addAppender(new ConsoleAppender(pat));
        Logger.getRootLogger().setLevel(Level.DEBUG);

    }
    */
    }
} // END MAIN
