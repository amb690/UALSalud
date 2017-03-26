//
//  ThirdTabController.swift
//  ualSalud
//
//  Created by Alberto Morante on 18/12/16.
//  Copyright © 2016 ualSalud. All rights reserved.
//

import UIKit
import CoreData

class ThirdTabController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: properties
    var nombrehistorial : String?
    var tiroxina : Bool?
    var hipotiroidismo: Bool?
    var tbg: Bool?
    var tsh: Bool?
    var sick: Bool?
    var referencia: Int?
    var referencias : String?
    var medidat3: String?
    var medidatt4: String?
    var medidafti: String?
    var medidatsh: String?
    var bgImage: UIImageView?
    var ip: String?
    
    @IBOutlet weak var btnGuardar: UIBarButtonItem!
    
    //variable enfermo e imagenes
    var enfermo: Bool?
    @IBOutlet weak var caritafelizimg: UIImageView!
    @IBOutlet weak var caritatristeimg: UIImageView!
    
    //Declara variable Historial para asignar datos
    var historial:Historial?
    var paciente:Paciente?
    
    //Declara delegado para CoreData
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //Declara alert conexion servidor
    var conexionServidor = UIAlertController(title: nil, message:
        "Estableciendo conexión con el servidor..", preferredStyle: UIAlertControllerStyle.Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool)
    {
        #if LPS2
       
            let camposVacios = alertaVacios()
            
            if (!camposVacios)
            {
                
                funcionSimpleLogistic()
            }
        #endif
        #if LPS3
            
            let camposVacios = alertaVacios()
            if (!camposVacios)
            {
                self.presentViewController(conexionServidor, animated: false, completion: nil)
                leerDatos()
            }
        #endif
    }
    override func viewWillAppear(animated: Bool)
    {
        #if LPS1
            if (historial != nil){
                if (historial?.enfermo == true){
                    caritatristeimg.layer.borderWidth = 2
                    caritafelizimg.layer.borderWidth = 0
                }else{
                    caritafelizimg.layer.borderWidth = 2
                    caritatristeimg.layer.borderWidth = 0
                }
                
            }
            caritafelizimg.hidden = false
            caritatristeimg.hidden = false
        #endif

    }
    
    
    #if LPS2
    
    func funcionSimpleLogistic()
    {
        // Evalua clase 0 (No enfermo)
        var resultadoClass0: Double
        resultadoClass0 = -0.64
        
        if (paciente?.sexo  == 0)    { resultadoClass0 += 1 * -0.1 }
        if (tiroxina        == true) { resultadoClass0 += 1 * 0.26 }
        if (sick            == true) { resultadoClass0 += 1 * -0.38 }
        if (hipotiroidismo  == true) { resultadoClass0 += 1 * -0.45 }
            
        resultadoClass0 += Double(medidatsh!)! * 0.02
        resultadoClass0 += Double(medidat3!)! * 2.28
        resultadoClass0 += Double(medidatt4!)! * -0
        resultadoClass0 += Double(medidafti!)! * -0.01
        
        switch referencia!
        {
            case 0:
                resultadoClass0 += 1 * -0.28
            case 1:
                resultadoClass0 += 1 * -0.58
            case 2:
                resultadoClass0 += 1 * 1.75
            case 3:
                resultadoClass0 += 1 * -0.53
            case 4:
                resultadoClass0 += 1 * 0.12
            default:
                break
        }
        
        // Evalua clase 1 (Enfermo)
        var resultadoClass1: Double
        resultadoClass1 = 0.64
        
        if (paciente?.sexo  == 0)    { resultadoClass1 += 1 * 0.1 }
        if (tiroxina        == true) { resultadoClass1 += 1 * -0.26 }
        if (sick            == true) { resultadoClass1 += 1 * 0.38 }
        if (hipotiroidismo  == true) { resultadoClass1 += 1 * 0.45 }
            
        resultadoClass1 += Double(medidatsh!)! * -0.02
        resultadoClass1 += Double(medidat3!)! * -2.28
        resultadoClass1 += Double(medidatt4!)! * 0
        resultadoClass1 += Double(medidafti!)! * 0.01
        
        switch referencia!
        {
            case 0:
                resultadoClass1 += 1 * 0.28
            case 1:
                resultadoClass1 += 1 * 0.58
            case 2:
                resultadoClass1 += 1 * -1.75
            case 3:
                resultadoClass1 += 1 * 0.53
            case 4:
                resultadoClass1 += 1 * -0.12
            default:
                break
        }
        
        //Aquí se controla que la imagen se muestre centrada
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        var image: UIImage
        
        if (bgImage != nil){
            bgImage!.removeFromSuperview()
        }
        // Enfermo
        if (resultadoClass0 < resultadoClass1)
        {
            image = UIImage(named: "caritaTriste")!
            bgImage = UIImageView(image: image)
            bgImage!.frame = CGRectMake(screenWidth/2-100,screenHeight/2-50,200,200)
            //bgImage!.frame = CGRectMake(screenWidth/2-50,screenHeight/2-20,100,100)
            self.view.addSubview(bgImage!)
            enfermo = true
        }
        
        // NO Enfermo
        if (resultadoClass0 > resultadoClass1)
        {
            image = UIImage(named: "caritaFeliz")!
            bgImage = nil;
            bgImage = UIImageView(image: image)
            bgImage!.frame = CGRectMake(screenWidth/2-100,screenHeight/2-50,200,200)
            //bgImage!.frame = CGRectMake(screenWidth/2-50,screenHeight/2-20,100,100)
            self.view.addSubview(bgImage!)
            enfermo = false
        }
    
    }
    #endif
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: actions
    @IBAction func cancelar(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func alertaVacios() -> Bool
    {
        var alerta: String? = ""
        /*  if(nombrehistorial == "" || medidat3 == "" || medidatt4 == "" || medidafti == "" || medidatsh == "" || medidatsh == nil ||
         medidat3 == nil || medidat3 == nil || medidatt4 == nil || medidafti == nil || enfermo == nil || tsh == nil || sick == nil)
         {*/
        if (nombrehistorial==""){
            alerta?+="- Introduzca el nombre del historial" + "\n"
        }
        if (nombrehistorial?.characters.count >= 25){
            alerta?+="- Nombre de historial demasiado largo (Max. 24)" + "\n"
        }
        if (medidat3 == "" || medidat3 == nil){
            alerta?+="- Introduzca la medida t3" + "\n"
        }
        if (medidatt4 == "" || medidatt4 == nil){
            alerta?+="- Introduzca la medida tt4" + "\n"
        }
        if (medidafti == "" || medidafti == nil){
            alerta?+="- Introduzca la medida fti" + "\n"
        }
        if (medidatsh == "" || medidatsh == nil){
            alerta?+="- Introduzca la medida tsh" + "\n"
        }
        if (tsh==nil){
            alerta?+="- Seleccione si hay medida tsh" + "\n"
        }
        
        #if LPS1
            if (enfermo==nil){
                alerta?+="- Seleccione si el paciente está enfermo" + "\n";
            }
        #endif
        
        if (alerta != "")
        {
            let alertController = UIAlertController(title: "Aviso", message:
                alerta, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: false, completion: nil)
            
            
            return true // devuelve true si campos vacios
        }
        // }
        return false // devuelve false si campos NO vacios
    }
    
    func leerDatos()
    {
        
        /*  http://192.168.118.210:8080/WekaWrapper/sick;attr1=3;attr2=F;attr3=t;attr4=f;attr5=t;attr6=t;attr7=67;attr8=1;attr9=45;attr10=334;attr11=f;attr12=SVI
         La clase devuelve sick
         
         http://192.168.118.210:8080/WekaWrapper/sick;attr1=3;attr2=F;attr3=f;attr4=f;attr5=f;attr6=f;attr7=3;attr8=3;attr9=3;attr10=3;attr11=f;attr12=SVI La
         
         clase devuelve negative */
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let calcAge = calendar.components(.Year, fromDate: paciente!.fechaNacimiento!, toDate: NSDate(), options: [])
        
        var sexob,tiroxb,sickb,hipotir,tshb,tbgb : String?
        
        if (paciente?.sexo == true) {
            sexob = "F"
        }else{
            sexob = "M"
        }
        
        if (tiroxina == true) {
            tiroxb = "t"
        }else{
            tiroxb = "f"
        }
        
        if (sick == true) {
            sickb = "t"
        }else{
            sickb = "f"
        }
        
        if (hipotiroidismo == true) {
            hipotir = "t"
        }else{
            hipotir = "f"
        }
        
        if (tsh == true) {
            tshb = "t"
        }else{
            tshb = "f"
        }
        
        tbgb = "f"
        
        var urlst : String = "http://192.168.118.210:8080/WekaWrapper/sick;attr1=\(String(calcAge.year));attr2=\(sexob!);attr3=\(tiroxb!);attr4=\(sickb!);attr5=\(hipotir!);attr6=\(tshb!);attr7=\(medidatsh!);attr8=\(medidat3!);attr9=\(medidatt4!);attr10=\(medidafti!);attr11=\(tbgb!);attr12=\(referencias!)"
        
    
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
                self.conexionServidor.dismissViewControllerAnimated(false, completion: nil)
                if (data != nil)
                {
                    
                    //Aquí se controla que la imagen se muestre centrada
                    let screenSize: CGRect = UIScreen.mainScreen().bounds
                    let screenWidth = screenSize.width
                    let screenHeight = screenSize.height
                    var image: UIImage
                    
                    if (self.bgImage != nil){
                        self.bgImage!.removeFromSuperview()
                    }
                    // Enfermo
                    if (self.ip == "sick")
                    {
                        image = UIImage(named: "caritaTriste")!
                        self.bgImage = UIImageView(image: image)
                        self.bgImage!.frame = CGRectMake(screenWidth/2-100,screenHeight/2-50,200,200)
                        self.view.addSubview(self.bgImage!)
                        self.enfermo = true
                    }
                    
                    // NO Enfermo
                    if (self.ip == "negative")
                    {
                        image = UIImage(named: "caritaFeliz")!
                        self.bgImage = nil;
                        self.bgImage = UIImageView(image: image)
                        self.bgImage!.frame = CGRectMake(screenWidth/2-100,screenHeight/2-50,200,200)
                        self.view.addSubview(self.bgImage!)
                        self.enfermo = false
                    }
                }
                else
                {
                    self.btnGuardar.enabled = false
                    let alertController = UIAlertController(title: "Aviso", message:
                        "La conexión con el servidor ha fallado.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: false, completion: nil)
                }
                            
            })
            
            }.resume()
        
    }
    
    
    @IBAction func guardarHistorial(sender: UIBarButtonItem) {
        
        var camposVacios = alertaVacios()
        
        if (camposVacios) { return }
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        // Si no viene de segue EDITAR, se crea un historial nuevo
        if (historial == nil)
        {
            let nuevoHistorial = NSEntityDescription.entityForName("Historial", inManagedObjectContext: context)
            
            historial = Historial(entity: nuevoHistorial!, insertIntoManagedObjectContext: context)
            historial?.fechaAlta = NSDate()
            historial?.fechaModificacion = NSDate()
            
        }
        
        // Asignacion de text de pantalla a variable historial
        
        historial?.descripcionHistorial = nombrehistorial
        /*let dateFormatter = NSDateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         let date = dateFormatter.stringFromDate(NSDate())*/
        historial?.tiroxina = tiroxina
        historial?.hipotiroidismo = hipotiroidismo
        historial?.tbg = tbg
        historial?.tsh = tsh
        historial?.sick = sick
        historial?.referencia = referencia
        historial?.medidat3 = Double(medidat3!)
        historial?.medidatt4 = Double(medidatt4!)
        historial?.medidafti = Double(medidafti!)
        historial?.medidatsh = Double(medidatsh!)
        historial?.enfermo = enfermo
        historial?.pacientes = paciente
        
        // Guardado de datos
        do
        {
            try context.save()
            
            // Cerrar ventana (volver atras)
            dismissViewControllerAnimated(true, completion: nil)
            
        }
        catch
        {
            print("No se pudo guardar")
            
        }
    }
    
    @IBAction func seleccionarCaritaFeliz(sender: UITapGestureRecognizer) {
        caritatristeimg.layer.borderWidth = 2
        caritafelizimg.layer.borderWidth = 0
        enfermo = true
    }
    
    @IBAction func seleccionarCaritaTriste(sender: UITapGestureRecognizer) {
        caritafelizimg.layer.borderWidth = 2
        caritatristeimg.layer.borderWidth = 0
        enfermo = false
    }
    
}
