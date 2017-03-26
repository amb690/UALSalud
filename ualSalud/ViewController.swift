//
//  ViewController.swift
//  ualSalud
//
//  Created by equipo on 29/11/16.
//  Copyright © 2016 ualSalud. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Engancha interfaz con variables
    @IBOutlet weak var nombretxt: UITextField!
    @IBOutlet weak var apellido1txt: UITextField!
    @IBOutlet weak var apellido2txt: UITextField!
    @IBOutlet weak var sexoBool: UISegmentedControl!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Declara variable del paciente para asignar datos
    var paciente:Paciente?
    
    // Declara delegado para CoreData
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Si venimos del segue de edicion, la variable pacientes vendra con datos
        if let pacienteIn = paciente
        {
            nombretxt.text = pacienteIn.nombre
            apellido1txt.text = pacienteIn.apellido1
            apellido2txt.text = pacienteIn.apellido2
            sexoBool.selectedSegmentIndex = Int(pacienteIn.sexo!)
            datePicker.date = pacienteIn.fechaNacimiento!
            imgView.image =  UIImage(data: pacienteIn.imagen!)
        }
        
        
        // Setear fecha maxima al datepicker
        datePicker.maximumDate = NSDate()
        
        // Setear imagen redonda
        imgView.layer.cornerRadius = 21.0
        imgView.layer.masksToBounds = true
        imgView.layer.borderColor = UIColor.blackColor().CGColor
        imgView.layer.borderWidth = 3
        

    }
    
    @IBAction func guardarDatos(sender: UIBarButtonItem)
    {
        // Comprobar si todos los campos tienen datos
        
        if(nombretxt.text == "" || apellido1txt.text == "" )
        {
            var alerta: String? = "";
            if (nombretxt.text == ""){
                alerta?+="- Introduzca el nombre del paciente" + "\n";
            }
            if (apellido1txt.text == ""){
                alerta?+="- Introduzca el primer apellido del paciente" + "\n";
            }

            let alertController = UIAlertController(title: "Error", message:
                alerta, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return;
        }
        if(nombretxt.text!.characters.count >= 21 || apellido1txt.text!.characters.count >= 21 || (apellido2txt.text != "" && apellido2txt.text!.characters.count >= 21) )
        {
            var alerta: String? = "";
            if (nombretxt.text!.characters.count >= 21){
                alerta?+="- Nombre del paciente demasiado largo (Max. 20)" + "\n";
            }
            if (apellido1txt.text!.characters.count >= 21){
                alerta?+="- Primer apellido del paciente demasiado largo (Max. 20)" + "\n";
            }
            if (apellido2txt.text!.characters.count >= 21){
                alerta?+="- Segundo apellido del paciente demasiado largo (Max. 20)" + "\n";
            }
            
            let alertController = UIAlertController(title: "Error", message:
                alerta, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return;
        }
        
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        // Si no viene de segue EDITAR, se crea un paciente nuevo
        if (paciente == nil)
        {
            let nuevoPaciente = NSEntityDescription.entityForName("Paciente", inManagedObjectContext: context)
            
            paciente = Paciente(entity: nuevoPaciente!, insertIntoManagedObjectContext: context)
            
        }
        
        // Asignacion de text de pantalla a variable paciente
        
        paciente?.nombre = String(nombretxt.text!).capitalizedString
        paciente?.apellido1 = String(apellido1txt.text!).capitalizedString
        paciente?.apellido2 = String(apellido2txt.text!).capitalizedString
        paciente?.sexo = sexoBool.selectedSegmentIndex
        
        let imgData = UIImageJPEGRepresentation(imgView.image!,1)
        paciente?.imagen = imgData
        
        paciente?.fechaNacimiento = datePicker.date
        
        
        // Guardado de datos
        do
        {
            try context.save()

            // Cerrar ventana (volver atras)
            self.navigationController?.popViewControllerAnimated(true)

        }
        catch
        {
            print("No se pudo guardar")
         
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    
    @IBAction func seleccionarImagen(sender: UITapGestureRecognizer)
    {
        // Codigo que muestra el "popup" para seleccionar la imagen de la galeria o de la camara.
        
        let imagePickerCtrl = UIImagePickerController()
        
        
        let alert:UIAlertController=UIAlertController(title: "Elige opción", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let camaraAction = UIAlertAction(title: "Cámara", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            
            #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
                let alert = UIAlertView(title: "No disponible",
                                        message: "¡La cámara no está disponible en el simulador!",
                                        delegate: nil,
                                        cancelButtonTitle: "Ok")
                alert.show()
                
            #else
                imagePickerCtrl.sourceType = .Camera
                imagePickerCtrl.delegate = self
                self.presentViewController(imagePickerCtrl, animated: true, completion: nil)
            #endif
            
            
            
        }
        let galeriaAction = UIAlertAction(title: "Galeria de fotos", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            imagePickerCtrl.sourceType = .PhotoLibrary
            imagePickerCtrl.delegate = self
            self.presentViewController(imagePickerCtrl, animated: true, completion: nil)
        }
        
        let fotosGuardadasAction = UIAlertAction(title: "Fotos guardadas", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            imagePickerCtrl.sourceType = .SavedPhotosAlbum
            imagePickerCtrl.delegate = self
            self.presentViewController(imagePickerCtrl, animated: true, completion: nil)
        }
        
        let cancelarAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
            
        }
        
        // Add the actions
        imagePickerCtrl.delegate = self
        alert.addAction(camaraAction)
        alert.addAction(galeriaAction)
        alert.addAction(fotosGuardadasAction)
        alert.addAction(cancelarAction)
        
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) { dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }


}

