//
//  SecondTabController.swift
//  ualSalud
//
//  Created by Alberto Morante on 18/12/16.
//  Copyright © 2016 ualSalud. All rights reserved.
//

import UIKit

var popModuleSharedView = popModuleSingleton.sharedPopModule

class SecondTabController: UIViewController {
    //-------------------------------------------------------
    //MARK: properties
    //Los campos han de tener dos acciones asociadas en este controlador.
    //accion 1: EditingChanged------DisableEditingTextField
    //accion 2: TouchDown-----------shPopModuleTF1
    @IBOutlet weak var tshtxt: UITextField!
    @IBOutlet weak var t3txt: UITextField!
    @IBOutlet weak var tt4txt: UITextField!
    @IBOutlet weak var ftitxt: UITextField!
    //-------------------------------------------------------
    @IBOutlet weak var tshsw: UISwitch!
    
    @IBAction func tshClicked(sender: UISwitch) {
        if (sender.on){
            tshtxt.userInteractionEnabled=true
            tshtxt.enabled = true
        }else{
            tshtxt.userInteractionEnabled=false
            tshtxt.enabled = false
            tshtxt.text = "0"
            
        }
    }
    var historial: Historial?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tshtxt.becomeFirstResponder()
    }
    
    //MARK: funcion para llamar la ventana popup y pasar los datos en las variables compartidas
    //funcion touchDown
    @IBAction func shPopModuleTF1(sender: UITextField) {
        
        desactivarCampos()
        
        //se instancia el controlador hijo
        let popModuleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("popModule") as! PopModuleViewController
        
        //asignamos el identificador del campo que llama el modulo para luego devolver el dato al mismo campo
        popModuleSharedView.nombre = sender.accessibilityIdentifier!
        popModuleSharedView.textoIntroducido = sender.text!
        
        //agregamos el controlador hijo del modulo
        self.addChildViewController(popModuleVC)
        popModuleVC.view.frame = self.view.frame
        self.view.addSubview(popModuleVC.view)
        popModuleVC.didMoveToParentViewController(self)
        
        
    }
    
    //MARK: desactiva la edicion manual de texto.
    //si se pulsa un boton se recupera el ultimo valor introducido.
    //llamado por medio de editingChanged
    @IBAction func disableEditingTextfield(sender: UITextField) {
        
        if(sender == tshtxt){
            tshtxt.text = popModuleSharedView.tsh
        }else if(sender == t3txt){
            t3txt.text = popModuleSharedView.t3
        }else if(sender == tt4txt){
            tt4txt.text = popModuleSharedView.tt4
        }else if(sender == ftitxt){
            ftitxt.text = popModuleSharedView.fti
        }
        
    }
    
    //MARK: acciones a realizar al cargarse la vista
    override func viewDidAppear(animated: Bool) {
        //Si venimos de Editar Historial, AQUÍ ESTA EL FALLO POR EL QUE EL CAMPO MEDIDA NO SE CONSERVA...
        if (historial != nil){
            
            //numero de posiciones decimales : 3
            if (tshtxt.text==""){
                //let tsh:String = String(format:"%.3f", (historial?.medidatsh!.doubleValue)!)
                let tsh:String = String(format:"%g", (historial?.medidatsh!.floatValue)!)
                tshtxt?.text = tsh
                tshsw?.on = (historial?.tsh?.boolValue)!
            }
            
            //numero de posiciones decimales : 2
            if (t3txt.text==""){
                //let t3:String = String(format:"%.2f", (historial?.medidat3!.doubleValue)!)
                let t3:String = String(format:"%g", (historial?.medidat3!.floatValue)!)
                t3txt.text = t3
            }
            
            
            //numero de posiciones decimales : 0
            if (tt4txt.text==""){
                //let tt4:String = String(format:"%.0f", (historial?.medidatt4!.floatValue)!)
                let tt4:String = String(format:"%g", (historial?.medidatt4!.floatValue)!)
                tt4txt?.text = tt4
            }
            
            if (ftitxt.text==""){
                //let fti:String = String(format:"%.0f", (historial?.medidafti!.floatValue)!)
                let fti:String = String(format:"%g", (historial?.medidafti!.floatValue)!)
                ftitxt?.text = fti
            }
            
        }else{
            //relleno los demas campos de medición por defecto si el historial es vacio
            if (tshtxt.text==""){
                tshtxt.text="0"
            }
            if (t3txt.text==""){
                t3txt.text="0"
            }
            if (tt4txt.text==""){
                tt4txt.text="2"
            }
            if (ftitxt.text==""){
                ftitxt.text="2"
            }
        }
        
        //Si el switch tsh esta inactivo se deshabilita la interacción con el usuario
        //se pone al despues de asignacion del valor del switch
        if (tshsw.on){
            tshtxt.userInteractionEnabled=true
            tshtxt.enabled = true
            
        }else{
            tshtxt.userInteractionEnabled=false
            tshtxt.enabled = false
            
        }
        
        //asignamos el valor obtenido de la base de datos
        popModuleSharedView.tsh = tshtxt.text!
        popModuleSharedView.t3 = t3txt.text!
        popModuleSharedView.tt4 = tt4txt.text!
        popModuleSharedView.fti = ftitxt.text!
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: actions
    @IBAction func cancelar(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: actualiza los campos de la vista actual tras la devolucion de datos por el popup
    func updateFields(){
        
        if(popModuleSharedView.nombre == "tsh"){
            popModuleSharedView.tsh = popModuleSharedView.textoIntroducido
            self.tshtxt.text = popModuleSharedView.textoIntroducido
        }
        else if(popModuleSharedView.nombre == "t3"){
            popModuleSharedView.t3 = popModuleSharedView.textoIntroducido
            self.t3txt.text = popModuleSharedView.textoIntroducido
        }
        else if(popModuleSharedView.nombre == "tt4"){
            popModuleSharedView.tt4 = popModuleSharedView.textoIntroducido
            self.tt4txt.text = popModuleSharedView.textoIntroducido
        }
        else if(popModuleSharedView.nombre == "fti"){
            popModuleSharedView.fti = popModuleSharedView.textoIntroducido
            self.ftitxt.text = popModuleSharedView.textoIntroducido
        }
        else{
            //print("campo desconocido");
        }
        
    }
    
    //MARK:activa los campos de la vista actual para que sean editables
    func activarCampos(){
        
        self.tshtxt.enabled = true;
        self.t3txt.enabled = true;
        self.tt4txt.enabled = true;
        self.ftitxt.enabled = true;
        
        if(popModuleSharedView.nombre == "tsh"){
            tshtxt.becomeFirstResponder()
        }
        else if(popModuleSharedView.nombre == "t3"){
            t3txt.becomeFirstResponder()
        }
        else if(popModuleSharedView.nombre == "tt4"){
            tt4txt.becomeFirstResponder()
        }
        else if(popModuleSharedView.nombre == "fti"){
            ftitxt.becomeFirstResponder()
        }
        else{
            //print("campo desconocido");
        }
        
        
    }
    
    //MARK: desactiva los campos para que un campo de la vista hija pueda realizar la accion becomeFirstResponder
    func desactivarCampos(){
        
        self.tshtxt.enabled = false;
        self.t3txt.enabled = false;
        self.tt4txt.enabled = false;
        self.ftitxt.enabled = false;
        
    }
    
}

