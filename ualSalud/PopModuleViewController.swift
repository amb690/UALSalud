        //
        //  PopModuleViewController.swift
        //  popoverModule2
        //
        //  Created by Viktor Sobolyev on 18/12/16.
        //  Copyright © 2016 UAL. All rights reserved.
        //
        
        import UIKit
        
        //se instancia la variable estatica para su acceso local
        let popModuleSharedPop = popModuleSingleton.sharedPopModule
        
        class PopModuleViewController: UIViewController, UITextFieldDelegate {
            
            @IBOutlet weak var tituloLbl: UILabel!
            
            //todos los campos de texto estan referenciados mediante la accion
            //editingChanged con el metodo disableEditingTextField
            @IBOutlet weak var intTxt: UITextField! //parte entera del numero
            var intMin:Float = 0; //minimo por defecto para intTxtSlider
            var intMax:Float = 50;//maximo por defecto para intTxtSlider
            @IBOutlet weak var d1Txt: UITextField!  //digito 1 de la parte decimal
            @IBOutlet weak var d2Txt: UITextField!  //digito 2 de la parte decimal
            @IBOutlet weak var d3Txt: UITextField!  //digito 3 de la parte decimal
            @IBOutlet weak var fondoStepper: UIView!//fondo para la seccion que contiene el stepper
            @IBOutlet weak var stepper: UIStepper! //elemento uistepper
            
            
            
            //todos los campos se guardan en un array para aplicarles un borde de forma programatica
            
            @IBOutlet weak var slider: UISlider!    //slider que configura los digitos
            @IBOutlet weak var sliderMin: UILabel!
            @IBOutlet weak var sliderMax: UILabel!
            var campoSeleccionado  = 0;             //campos son los digitos de la pantalla
            
            
            //configuraciones de los campos
            //Formato [nCampos, min, max]
            var porDefecto: [String] = ["3","0","50"]
            var tsh:        [String] = ["3", "0","530"]
            var  t3:        [String] = ["2", "0","12"]
            var tt4:        [String] = ["0", "2","430"]
            var fti:        [String] = ["0", "2","395"]
            
            
            //MARK: muestra del valor de la rueda en el campo corerspondiente y actualiza el stepper
            @IBAction func sliderValueChanged(sender: UISlider) {
                let currentValue = Int(sender.value)
                self.stepper.value = Double(currentValue)
                
                switch campoSeleccionado{
                case 0:
                    intTxt.text = "\(currentValue)"
                case 1:
                    d1Txt.text = "\(currentValue)"
                case 2:
                    d2Txt.text = "\(currentValue)"
                case 3:
                    d3Txt.text = "\(currentValue)"
                default:
                    print("algo esta fallando en el metodo sliderValueChanged")
                }
                
                backupValue()
                //guardamos copia de ultimo valor en el singleton
                
            }
            
            //MARK: muestra del valor del stepper en el campo corerspondiente y actualiza el slider
            @IBAction func stepperValueChanged(sender: UIStepper) {
                
                let currentValue = Int(stepper.value)
                self.slider.value = Float(stepper.value)
                
                switch campoSeleccionado{
                case 0:
                    intTxt.text = "\(currentValue)"
                case 1:
                    d1Txt.text = "\(currentValue)"
                case 2:
                    d2Txt.text = "\(currentValue)"
                case 3:
                    d3Txt.text = "\(currentValue)"
                default:
                    print("algo esta fallando en el metodo sliderValueChanged")
                }
                
                backupValue()
                //guardamos copia de ultimo valor en el singleton
            }
            
            //---------------------------------------------------------------------
            //acciones de los campos
            //alternativamente podría resolverse con una sola funcion y un switch
            //basandose en el identificador del campo,
            //pero debido a un numero controlable de campos se ha optado por
            //utilizar 4 funciones
            
            @IBAction func intTxtAction(sender: UITextField) {
                campoSeleccionado = 0;
                cargarSlider(campoSeleccionado)
                bordeCampo(campoSeleccionado)
            }
            @IBAction func d1TxtAction(sender: UITextField) {
                campoSeleccionado = 1;
                cargarSlider(campoSeleccionado)
                bordeCampo(campoSeleccionado)
            }
            @IBAction func d2TxtAction(sender: UITextField) {
                campoSeleccionado = 2;
                cargarSlider(campoSeleccionado)
                bordeCampo(campoSeleccionado)
            }
            @IBAction func d3Txt(sender: UITextField) {
                campoSeleccionado = 3	;
                cargarSlider(campoSeleccionado)
                bordeCampo(campoSeleccionado)
            }
            
            //---------------------------------------------------------------------
            
            override func viewDidLoad() {
                super.viewDidLoad()
                
                //se asigna un fondo transparente
                self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
                
                //se activa la animacion
                self.showAnimate()
                
                //self.celdaFondoTVC
                self.fondoStepper!.layer.cornerRadius=10 //set corner radius here
                self.fondoStepper!.layer.borderColor = UIColor.lightGrayColor().CGColor  // set cell border color here
                self.fondoStepper!.layer.borderWidth = 2 // set border width here
                
                intTxt.becomeFirstResponder()
                intTxt.delegate = self
            }
            
            override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
            }
            
            //MARK: accion boton cancelar
            @IBAction func CancelarBtn(sender: UIButton) {
                //no hacemos nada, quitamos la animacion y ya esta
                self.removeAnimate()
                
            }
            
            //MARK: desactiva la edicion manual de texto.
            //si se pulsa un boton se recupera el ultimo valor introducido.
            @IBAction func disableEditingTextfield(sender: UITextField) {
                if(tituloLbl.text == "tsh"){
                    cargarDato(popModuleSharedView.tshM)
                    //print("no se puede escribir con el teclado en el campo")
                }else if(tituloLbl.text == "t3"){
                    cargarDato(popModuleSharedView.t3M)
                    //print("no se puede escribir con el teclado en el campo")
                }else if(tituloLbl.text == "tt4"){
                    cargarDato(popModuleSharedView.tt4M)
                    //print("no se puede escribir con el teclado en el campo")
                }else if(tituloLbl.text == "fti"){
                    cargarDato(popModuleSharedView.ftiM)
                    //print("no se puede escribir con el teclado en el campo")
                }
            }
            
            //MARK: hace una copia del valor original para el caso de
            //cancelar la edicion una vaz modificado el valor original
            func backupValue(){
                //print(buildNumber()!) //depuracion
                if(tituloLbl.text == "tsh"){
                    popModuleSharedView.tshM = buildNumber()!
                }else if(tituloLbl.text == "t3"){
                    popModuleSharedView.t3M = buildNumber()!
                }else if(tituloLbl.text == "tt4"){
                    popModuleSharedView.tt4M = buildNumber()!
                }else if(tituloLbl.text == "fti"){
                    popModuleSharedView.ftiM = buildNumber()!
                }
            }
            
            //MARK: accion de boton guardar
            @IBAction func GuardarBtn(sender: UIButton) {
                //retirar animacion
                self.removeAnimate()
                
                //construir el numero
                let text = buildNumber()
                
                //se asigna el texto formateado
                popModuleSharedPop.textoIntroducido = String(format: "%g", Float(text!)!)
                
                //creamos variable con controlador padre y llamamos al metodo de actualizacion del campo
                if let myParent = self.parentViewController as? SecondTabController{
                    myParent.updateFields()
                }
            }
            
            //MARK: construir valor de retorno
            func buildNumber() -> String? {
                let campos: [UITextField] = [intTxt, d1Txt, d2Txt, d3Txt]
                var txt: String = "";
                
                for i in 0 ..< campos.count
                {
                    if(i <= Int(porDefecto[0])){
                        let trimmedString = campos[i].text!.stringByTrimmingCharactersInSet(
                            NSCharacterSet.whitespaceAndNewlineCharacterSet()
                        )
                        if(trimmedString != ""){
                            if(i == 0){
                                txt+=trimmedString
                                if(Int(porDefecto[0])>0){
                                    txt+="."
                                }
                            }else{
                                txt+=trimmedString
                            }
                        }
                        
                    }
                }
                
                return txt
            }
            
            //MARK: funcion se dedica a cargar los campos
            func cargarSliderInicial(){
                //asignar nombre del campo
                self.tituloLbl.text = popModuleSharedPop.nombre
                
                //CARGAMOS LA CONFIGURACION ACTUAL DE LOS CAMPOS
                
                //configuracion por defecto
                porDefecto = ["0","0","50"]
                
                //si el campo llamado es conocido entonces asignamos los rangos
                //que le corresponden, si no se queda el que se asigna por defecto.
                if(popModuleSharedPop.nombre == "tsh")
                {
                    porDefecto = tsh
                }else if(popModuleSharedPop.nombre == "t3")
                {
                    porDefecto = t3
                }else if(popModuleSharedPop.nombre == "tt4")
                {
                    porDefecto = tt4
                }else if(popModuleSharedPop.nombre == "fti")
                {
                    porDefecto = fti
                }
                
                //longitud de nuestro numero (numero de decimales=
                let n:Int? = Int(porDefecto[0])
                var campos: [UITextField] = [intTxt, d1Txt, d2Txt, d3Txt]
                
                //recorrer desde el final del array de campos aquellos que no son activados
                for i in 1..<campos.count-n!{
                    campos[campos.count-i].enabled = false
                    campos[campos.count-i].backgroundColor = UIColor.lightGrayColor()
                }
                
                //el campo que esta selecionado por defecto tendrá un borde rodeandolo
                //para indicar tal opcion
                bordeCampo(0)
                
                //cargar el dato en la pantalla actual
                cargarDato(popModuleSharedPop.textoIntroducido)
                
                //ahora toca guardar el valor inicial como copia para recuperar en caso de introduccion de texto
                //por teclado
                backupValue()
                
                //minimos y maximos del entero
                intMin = Float(porDefecto[1])!
                intMax = Float(porDefecto[2])!
                cargarSlider(campoSeleccionado)
                
            }
            
            
            //MARK: carga el valor previamente guardado en su "casilla/campo" correspondiente
            //se carga el dato que se obtuvo de la bbdd o el que fue introducido por ultima vez
            //si no habia dato previamente, se carga valor 0
            func cargarDato(valueIn: String){
                var value = valueIn
                
                //formateamos el numero a la longitud adecuada
                if(valueIn != ""){
                    switch porDefecto[0] {
                    case "1":
                        value = String(format:"%.1f", (Float(value))!)
                    case "2":
                        value = String(format:"%.2f", (Float(value))!)
                    case "3":
                        value = String(format:"%.3f", (Float(value))!)
                    default: break
                        //no hacer nada
                    }
                }
                
                //valor cargado previamente
                let dato = Float(value)
                //campos de texto para representar el numero
                var campos: [UITextField] = [intTxt, d1Txt, d2Txt, d3Txt]
                //valor spliteado
                var values = value.componentsSeparatedByString(".")
                //si tenemos datos introducidos, entonces insertar los digitos en sus posiciones correspondientes
                if (values.count > 0){
                    if(values.count >= 1){//tenemos al menos parte entera
                        //print(values[0])
                        campos[0].text = values[0]
                    }
                    //si tenemos la parte decimal
                    if(values.count > 1){//tenemos parte decimal
                        var a = 1
                        for i in values[1].characters{
                            if(a <= Int(porDefecto[0])){
                                campos[a].text = String(i)
                                a += 1
                            }
                        }
                    }
                }
                
                //machacamos un posible espacio (un espacio al hacer split ocupa 1 posicion
                //por tanto rellenamos todo de ceros)
                if(dato == nil){
                    for i in 0 ..< campos.count
                    {
                        if(i <= Int(porDefecto[0])){
                            campos[i].text = "0"
                            if(i == 0){
                                campos[i].text = porDefecto[1]
                            }
                        }
                    }
                }
                
            }
            
            //MARK: carga el slider al cargarse la ventana popup
            func cargarSlider(n : Int){
                
                var campos: [UITextField] = [intTxt, d1Txt, d2Txt, d3Txt]
                
                var min: Float = intMin
                var max: Float = intMax
                
                if(n != 0){
                    min = 0
                    max = 9
                }
                
                self.sliderMin.text = String(Int(min))
                self.sliderMax.text = String(Int(max))
                
                self.slider.minimumValue = min
                self.slider.maximumValue = max
                
                self.stepper.minimumValue = Double(min)
                self.stepper.maximumValue = Double(max)
                
                //tambien ubicamos la rueda en la posicion del valor actual del campo ya que tenemos
                //un array de valores
                let val = Float(campos[campoSeleccionado].text!)
                if( val != nil){
                    self.slider.value = val!
                    self.stepper.value = Double(val!)
                }else{
                    self.slider.value = min
                    self.stepper.minimumValue = Double(min)
                }
            }
            
            
            //MARK: borde campo sirve para rodear con un borde
            //el campo actualmente seleccionado
            func bordeCampo(n: Int){
                var campos: [UITextField] = [intTxt, d1Txt, d2Txt, d3Txt]
                
                for i in 0 ..< campos.count 
                {
                    if( i == n ){
                        campos[i].layer.borderColor = UIColor.orangeColor().CGColor
                        campos[i].layer.borderWidth = 2.0
                        campos[i].layer.cornerRadius = 8.0
                    }else {
                        campos[i].layer.borderColor = UIColor.whiteColor().CGColor
                    }
                }
            }
            //MARK: funcion de la animacion
            func showAnimate()
            {
                cargarSliderInicial()
                
                self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
                self.view.alpha = 0.0;
                
                UIView.animateWithDuration(0.25, animations: {
                    self.view.alpha = 1.0
                    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                });
                
                self.view.layer.cornerRadius = 10
            }
            
            //MARK: funcion de la retirada de la animacion
            func removeAnimate()
            {
                //creamos variable con controlador padre y llamamos al metodo de actualizacion del campo
                if let myParent = self.parentViewController as? SecondTabController {
                    myParent.activarCampos()
                }
                
                UIView.animateWithDuration(0.25, animations: {
                    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
                    self.view.alpha = 0.0;
                    }, completion:{(finished : Bool)  in
                        if (finished)
                        {
                            self.view.removeFromSuperview()
                        }
                });
            }
            
        }
