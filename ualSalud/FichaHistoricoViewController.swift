//
//  FichaHistoricoViewController.swift
//  ualSalud
//
//  Created by equipo on 12/12/16.
//  Copyright © 2016 ualSalud. All rights reserved.
//

import UIKit
import CoreData

class FichaHistoricoViewController: UIViewController {
    
    // Paciente
    @IBOutlet weak var nombreTxt: UILabel!
    @IBOutlet weak var edadTxt: UILabel!
    @IBOutlet weak var sexoTxt: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    // Historial
    @IBOutlet weak var fechaConsulta: UILabel!
    @IBOutlet weak var fechaRevision: UILabel!
    @IBOutlet weak var resultadoEnfermedad: UILabel!
    @IBOutlet weak var editar: UIButton!
    @IBOutlet weak var recalcular: UIButton!
    
    var paciente:Paciente?
    var historial:Historial?
    var referencias:String?
    var ip:String?
    
    //Declara alert conexion servidor
    var conexionServidor = UIAlertController(title: nil, message:
        "Estableciendo conexión con el servidor..", preferredStyle: UIAlertControllerStyle.Alert)
    
    //Declara delegado para CoreData
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setearDatosPaciente()
        self.setearDatosHistorial()
    }
    
    override func viewDidAppear(animated: Bool)
    {
/*
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
 */
        self.setearDatosPaciente()
        self.setearDatosHistorial()


        
    }
    override func viewWillAppear(animated: Bool)
    {
        #if LPS1
            recalcular.hidden=true
        #endif
        #if LPS2
            recalcular.hidden=true
        #endif
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recalcularResultado(sender: UIButton) {
        self.presentViewController(conexionServidor, animated: false, completion: nil)
        guardarDatos()
        
    }
    
    
    func setearDatosPaciente()
    {
        // Imagenes redondas
        imgView.layer.cornerRadius = 21.0
        imgView.layer.masksToBounds = true
        imgView.layer.borderColor = UIColor.blackColor().CGColor
        imgView.layer.borderWidth = 3
        
        imgView.image =  UIImage(data: paciente!.imagen!)
        
        // Setear Nombre
        nombreTxt.text = paciente!.nombre! + " " + paciente!.apellido1! + " " + paciente!.apellido2!
        
        
        // Setear EDAD
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let calcAge = calendar.components(.Year, fromDate: paciente!.fechaNacimiento!, toDate: NSDate(), options: [])
        edadTxt.text = "\(calcAge.year) Años"
        
        
        // Setear SEXO
        
        if (paciente!.sexo == 0)
        {
            sexoTxt.text = "Hombre"
        }
        else
        {
            sexoTxt.text = "Mujer"
        }
    }
    
    func setearDatosHistorial()
    {
        if (historial?.enfermo == 1)
        {
            resultadoEnfermedad.text = "POSITIVO"
        }
        else
        {
            resultadoEnfermedad.text = "NEGATIVO"
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        fechaConsulta.text = (dateFormatter.stringFromDate(historial!.fechaAlta!))
        
        fechaRevision.text = (dateFormatter.stringFromDate(historial!.fechaAlta!))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        // Edita un historial de un paciente
        if segue.identifier == "editarHistorial"
        {
            // Llamada al controlador de datos de historial
            let v = segue.destinationViewController as! TabViewController
            
            // Variable declarada en DatosHistorialViewController
            v.historial = historial
            v.paciente = paciente
        }
        
    }
    
    func guardarDatos()
    {
        
        /*  http://192.168.118.210:8080/WekaWrapper/sick;attr1=3;attr2=F;attr3=t;attr4=f;attr5=t;attr6=t;attr7=67;attr8=1;attr9=45;attr10=334;attr11=f;attr12=SVI
         La clase devuelve sick
         
         http://192.168.118.210:8080/WekaWrapper/sick;attr1=3;attr2=F;attr3=f;attr4=f;attr5=f;attr6=f;attr7=3;attr8=3;attr9=3;attr10=3;attr11=f;attr12=SVI La
         
         clase devuelve negative */
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let calcAge = calendar.components(.Year, fromDate: paciente!.fechaNacimiento!, toDate: NSDate(), options: [])
        
        var sexob,tiroxb,sickb,hipotir,tshb,tbgb : String?
        
        if (paciente!.sexo!.boolValue == true) {
            sexob = "F"
        }else{
            sexob = "M"
        }
        
        if (historial!.tiroxina!.boolValue == true) {
            tiroxb = "t"
        }else{
            tiroxb = "f"
        }
        
        if (historial!.sick!.boolValue == true) {
            sickb = "t"
        }else{
            sickb = "f"
        }
        
        if (historial!.hipotiroidismo!.boolValue == true) {
            hipotir = "t"
        }else{
            hipotir = "f"
        }
        
        if (historial!.tsh!.boolValue == true) {
            tshb = "t"
        }else{
            tshb = "f"
        }
        
        tbgb = "f"
        
        switch historial!.referencia!.integerValue
        {
        case 0:
            referencias = "SVHC";
        case 1:
            referencias = "SVI";
        case 2:
            referencias = "STMW";
        case 3:
            referencias = "SVHD";
        case 4:
            referencias = "other";
        default:
            break;
        }
        
        var urlst : String = "http://192.168.118.210:8080/WekaWrapper/sick;attr1=\(String(calcAge.year));attr2=\(sexob!);attr3=\(tiroxb!);attr4=\(sickb!);attr5=\(hipotir!);attr6=\(tshb!);attr7=\(historial!.medidatsh!);attr8=\(historial!.medidat3!);attr9=\(historial!.medidatt4!);attr10=\(historial!.medidafti!);attr11=\(tbgb!);attr12=\(referencias!)"
        
        
        let url = NSURL (string: urlst)
        
        NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (data, reponse, error) in

            do
            {
                if (data != nil)
                {
                    if let ipString = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                        // Print what we got from the call
                        self.ip = ipString as String
                    }
                }
            }
            catch let jsonError
            {
                print (jsonError)
            }
            
            // Llamada asincrona, ya que hay un retardo entre que consulta la web, y nos llega la informacion
            dispatch_async(dispatch_get_main_queue(),
                {
                    //self.conexionServidor.dismissViewControllerAnimated(false, completion: nil)
                    
                    if (data != nil)
                        {
                        
                        //Aquí iría código que se ejecuta después de que se haya calculado el resultado de la llamada a REST, el guardar datos
                        let context: NSManagedObjectContext = self.appDel.managedObjectContext
                        // Si no viene de segue EDITAR, se crea un historial nuevo
                        
                        // Asignacion de text de pantalla a variable historial
                        self.historial?.fechaModificacion = NSDate()
                        if (self.ip == "sick")
                        {
                            self.historial!.enfermo = true
                        }
                        
                        // NO Enfermo
                        if (self.ip == "negative")
                        {
                            self.historial!.enfermo = false
                        }
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
                        /*print("Fecha de Alta:  \(dateFormatter.stringFromDate(self.historial!.fechaAlta!))")
                        print("Fecha de Alta:  \(dateFormatter.stringFromDate(self.historial!.fechaModificacion!))")*/
                        
                            // Guardado de datos
                            do
                            {
                                try context.save()
                                
                                self.conexionServidor.dismissViewControllerAnimated(true, completion:
                                    {
                                        let alertController = UIAlertController(title: "Aviso", message:
                                            "El resultado se ha recalculado correctamente", preferredStyle: UIAlertControllerStyle.Alert)
                                        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
                                        self.presentViewController(alertController, animated: false, completion: nil)
                                })
                                
                            }
                            catch
                            {
                                print("No se pudo guardar")
                                
                            }
                    }
                    else
                    {
                        self.conexionServidor.dismissViewControllerAnimated(true, completion:
                            {
                                let alertController = UIAlertController(title: "Aviso", message:
                                    "La conexión con el servidor ha fallado.", preferredStyle: UIAlertControllerStyle.Alert)
                                alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
                                self.presentViewController(alertController, animated: false, completion: nil)
                        })
                        
                        
                        
                    }
                            
                    /*//version nueva
                             
                             // Guardado de datos
                             do
                             {
                             try context.save()
                             
                             self.conexionServidor.dismissViewControllerAnimated(true, completion:
                             {
                             let alertController = UIAlertController(title: "Aviso", message:
                             "El resultado se ha recalculado correctamente", preferredStyle: UIAlertControllerStyle.Alert)
                             alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
                             self.presentViewController(alertController, animated: false, completion: nil)
                             })
                             
                             }
                             catch
                             {
                             print("No se pudo guardar")
                             
                             }
                             
                    */
                            
                            
                            
                    
                    
                    
                    /*else //version nueva
                    {
                        
                        let alertController = UIAlertController(title: "Aviso", message:
                            "La conexión con el servidor ha fallado.", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: false, completion: nil)
                    }*/
                    
                    /*
                    else  //version nueva
                    {
                        
                        
                        // Delay the dismissal by 5 seconds
                        let delay = 1.0 * Double(NSEC_PER_SEC)
                        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), {
                            let alertController = UIAlertController(title: "Aviso", message:
                                "La conexión con el servidor ha fallado.", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
                            self.presentViewController(alertController, animated: false, completion: nil)
                        })
                        
                        
                    }
                    */
                    
                            
            })
            
            }.resume()
        
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}