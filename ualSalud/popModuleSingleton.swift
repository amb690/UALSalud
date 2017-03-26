//
//  popModuleSingleton.swift
//  popoverModule2
//
//  Created by user on 18/12/16.
//  Copyright © 2016 UAL. All rights reserved.
//

import Foundation

class popModuleSingleton{

    static let sharedPopModule = popModuleSingleton()
    
    var nombre = ""
    var textoIntroducido: String = ""
    var valor = 0.0
    
    //campos con valores correspondientes a los campos del menu
    var tsh: String = ""
    var t3: String = ""
    var tt4: String = ""
    var fti: String = ""
    
    //campos con valores correspondientes a los campos del modulo
    //son necesarios para almacenar el valor introducido por el slider y en caso de introduccion de texto por teclado, sera recuperado desde aqui.
    var tshM: String = ""
    var t3M: String = ""
    var tt4M: String = ""
    var ftiM: String = ""

}