/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package reportesjasper;

import java.util.ArrayList;
import java.util.HashMap;

//IMPORTS PARA EL CIFRADO EN JAVA
import javax.crypto.*;
import javax.crypto.spec.SecretKeySpec;

// Para leer el archivo xml
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.security.AlgorithmParameters;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.crypto.spec.IvParameterSpec;
import org.apache.commons.codec.binary.Base64;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;
/**
 *
 * @author osantoyo
 */
public class Utileria {
    
    // Funcion constructor
    private String url;
    private String driver;
    private String user;
    private String password;
    private String direccionArchivoConfiguracion;
    
    // Variables para el cifrado y descifrado
    private String llaveSimetrica = "paZamundocruelholamundocruel1212";
    private IvParameterSpec iv = new IvParameterSpec(llaveSimetrica.substring(0, 16).getBytes());
    private SecretKeySpec key = new SecretKeySpec(llaveSimetrica.getBytes(), "AES");
    private Cipher cipher;
    
    public Utileria(){}
    
    public Utileria(String direccionArchivoConfiguracion){
        this.direccionArchivoConfiguracion = direccionArchivoConfiguracion;
        
        //System.out.println("Impreison aca: "+direccionArchivoConfiguracion);
        
        try{
            cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
        } catch (Exception e) {
            e.printStackTrace();
        }
        //Se crea un SAXBuilder para poder parsear el archivo
        SAXBuilder builder = new SAXBuilder();
        File xmlFile = new File( direccionArchivoConfiguracion );

        try
        {
                //Se crea el documento a traves del archivo
                //se obtiene el nodo raiz
                Element rootNode = (Element)builder.build( xmlFile ).getRootElement();
                //se obtienen los parametros necesarios para la conexion
                driver = rootNode.getChild("dataBase").getAttributeValue("driver");
                url    = rootNode.getChild("dataBase").getAttributeValue("url");
                user = rootNode.getChild("dataBase").getChild("security").getAttributeValue("user");
                password  = rootNode.getChild("dataBase").getChild("security").getAttributeValue("password");

                
                //Descifrado 
                url = Descifra(url);
                driver = Descifra(driver);
                user = Descifra(user);
                password = Descifra(password);
                
                //Impresion
                /*
                System.out.println("url: "+url);
                System.out.println("driver: "+driver);
                System.out.println("user: "+user);
                System.out.println("password: "+password);
                */
        }catch ( IOException io ) {
                System.out.println("Error");
                System.out.println( io.getMessage() );
        }catch ( JDOMException jdomex ) {
                System.out.println("Error");
                System.out.println( jdomex.getMessage() );
        }
        System.out.println("Aca: "+direccionArchivoConfiguracion);
            
    }
     
    // Modo de obtener las variables
    public String getDriver(){return driver;}
    public String getUrl(){return url;}
    public String getUser(){return user;}
    public String getPassword(){return password;}
     
    public HashMap ObtieneParametrosDEPRECATED(String cadena){
        ArrayList lista = new ArrayList();
        HashMap parametros = new HashMap();
        String palabra = ""; //Cadena auxiliar
        cadena = cadena + "#"; //Condicion necesaria para el funcionamiento del algoritmo
        
        for(int i = 0; i< cadena.length(); i++){
            if(cadena.charAt(i) != '#'){
                palabra = palabra + cadena.charAt(i);
            }
            else
                 if (!palabra.equals("")){
                  lista.add(new String(palabra));
                  palabra = "";
                 }
        }
        
        /*
         * Verifica que los parametros que se ingresaron sean pares 
         * si no son pares regresa null
        */
        if(lista.size() %2 != 0){
            return null;
        }
        
        for(int i =0 ; i< lista.size(); i++){
            //System.out.println("Valor de i: "+i+ (i+1));
            parametros.put(lista.get(i), lista.get(i+1));
            i++;
        }
        //System.out.println("la lista es: "+ lista);
        //System.out.println("HASHMAP: "+parametros);
        return new HashMap();
    }
    
    
    
     public HashMap ObtieneParametros(String cadena){
        ArrayList lista = new ArrayList();
        HashMap parametros = new HashMap();
        
        //Si la cadena es vacia se regresas un HashMap vacio
        if (cadena.length() == 0)
            return parametros;
        
        String palabra = ""; //Cadena auxiliar
        
        String auxLlave = "";
        String auxValor = "";
        String mapeo [];
        //String cadenas[] = cadena.split("\\(.\\) ");
        String cadenas[] = cadena.split("(?>=\\{)|(?<=\\})");
        //System.out.println(cadenas.length);
        for ( int i = 0; i<cadenas.length; i++){
            palabra = null;
            mapeo = null;
            palabra = cadenas[i].substring(1,cadenas[i].length()-1);
            mapeo = palabra.split("#");
            parametros.put(mapeo[0], mapeo[1]);
        }
        //System.out.println("Parametros: "+ parametros);
        return parametros;
    }
    /*
    * Inprime advertencias 
    */
    public void Advertencia(String cadena){
        System.out.println("Advertencia: "+cadena);
    }
    
    /*
    * Inprime advertencias 
    */
    public void Error(String cadena){
        System.out.println("Error: "+cadena);
    }
    
  public String Cifra(String cadena) {
    try {
        cipher.init(Cipher.ENCRYPT_MODE, key,iv);
        byte[] encrypted = cipher.doFinal(cadena.getBytes());
        //System.out.println("encrypted string:" + Base64.encodeBase64String(encrypted));
        return Base64.encodeBase64String(encrypted);
    } catch (Exception ex) {
        ex.printStackTrace();
    }
    return null;
}

    public String Descifra( String cadena) {
        try {
            cipher.init(Cipher.DECRYPT_MODE, key,iv);
            byte[] original = cipher.doFinal(Base64.decodeBase64(cadena));

            return new String(original);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    } 
                    
    public void ConfiguraDB( ) {
        ConfiguraDB configuracion = new ConfiguraDB();
        configuracion.IniciaConfiguraDB(url,driver,user,password,this);
    } 
    
    public void ModificaParametrosBaseDeDatos(String url, String driver, String user, String password){
        //Se crea un SAXBuilder para poder parsear el archivo
        SAXBuilder builder = new SAXBuilder();
        File xmlFile = new File( direccionArchivoConfiguracion );
        try
        {
            //Cifrado 
            url = Cifra(url);
            driver = Cifra(driver);
            user = Cifra(user);
            password = Cifra(password);

            //Impresion
            /*
            System.out.println("url: "+url);
            System.out.println("driver: "+driver);
            System.out.println("user: "+user);
            System.out.println("password: "+password);
            */

            //Se crea el documento a traves del archivo
            Document document = (Document)builder.build( xmlFile );
            //se obtiene el nodo raiz
            Element rootNode = document.getRootElement();

            // Se escriben los parametros modificados
            rootNode.getChild("dataBase").setAttribute("driver", driver);
            rootNode.getChild("dataBase").setAttribute("url", url);
            rootNode.getChild("dataBase").getChild("security").setAttribute("user", user);
            rootNode.getChild("dataBase").getChild("security").setAttribute("password", password);
            // Obtiene el texto que se escribira    
            String des = new XMLOutputter().outputString(document);
            // Escribe el archivo fisicamente 
            FileWriter filewriter = new FileWriter(xmlFile);
            filewriter.write(des);
            filewriter.close();
                
        }catch ( IOException io ) {
                System.out.println( io.getMessage() );
        }catch ( JDOMException jdomex ) {
                System.out.println( jdomex.getMessage() );
        }
    }
  
    
    public String PruebaConexion(String url2, String driver2,String usuario,String pass){
        Connection conn = null;//new Connection();
        String message="OK";
        try {
        Class.forName(driver2);
        }
        catch (ClassNotFoundException e) {
            message = e.getMessage();
        System.out.println(e.getMessage());
        //System.exit(1);
        }
        //Para iniciar el Logger.
        //inicializaLogger();
        try {
        conn = DriverManager.getConnection(url2,usuario, pass); // Se inicializa la conexion para poder transmitirla al reporte
        conn.setAutoCommit(false);
        }
        catch (SQLException e) {
           
            message = e.getMessage();
            System.out.println("Error de conexión: " + e.getMessage());
        }
        
        finally{
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
        return message;
        }
        
    
}




 

