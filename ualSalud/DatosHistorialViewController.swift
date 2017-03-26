//
//  DatosHistorialViewController.swift
//  ualSalud
//
//  Created by equipo on 11/12/16.
//  Copyright © 2016 ualSalud. All rights reserved.
//

import UIKit
import CoreData

class DatosHistorialViewController: UIViewController {

    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var switchEnfermo: UISwitch!
    @IBOutlet weak var descripcionHistorial: UITextField!
    
    var paciente:Paciente?
    var historial:Historial?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Si venimos del segue de edicion, la variable historiales vendra con datos
        if let s = historial
        {
            descripcionHistorial.text = s.descripcionHistorial
            
            if (s.enfermo == 1)
            {
                switchEnfermo.on = true
            }
            else
            {
                switchEnfermo.on = false
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func guardarHistorial(sender: UIBarButtonItem) {
        
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        
        
        if(descripcionHistorial.text!.stringByTrimmingCharactersInSet(whitespaceSet).isEmpty)
        {
            
            let alertController = UIAlertController(title: "Error", message:
                "Descripción obligatoria.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return;
            
        }
        
        
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        if (historial == nil)
        {
            let nuevoHistorial = NSEntityDescription.entityForName("Historial", inManagedObjectContext: context)
            
            historial = Historial(entity: nuevoHistorial!, insertIntoManagedObjectContext: context)
            
            // La fecha de alta solo se inserta, no se modifica
            historial?.fechaAlta =  NSDate()
            
        }
        
        historial?.descripcionHistorial = descripcionHistorial.text
        
        if (switchEnfermo.on)
        {
            historial?.enfermo = 1
        }
        else
        {
            historial?.enfermo = 0
        }
        
        
        // Relacionar historiales con paciente
        historial?.pacientes = paciente
        
        
        
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


}
