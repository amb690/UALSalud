//
//  Historial+CoreDataProperties.swift
//  ualSalud
//
//  Created by Alberto Morante on 23/1/17.
//  Copyright © 2017 ualSalud. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Historial {

    @NSManaged var descripcionHistorial: String?
    @NSManaged var enfermo: NSNumber?
    @NSManaged var fechaAlta: NSDate?
    @NSManaged var fechaModificacion: NSDate?
    @NSManaged var hipotiroidismo: NSNumber?
    @NSManaged var medidafti: NSNumber?
    @NSManaged var medidat3: NSNumber?
    @NSManaged var medidatsh: NSNumber?
    @NSManaged var medidatt4: NSNumber?
    @NSManaged var referencia: NSNumber?
    @NSManaged var tbg: NSNumber?
    @NSManaged var tiroxina: NSNumber?
    @NSManaged var tsh: NSNumber?
    @NSManaged var sick: NSNumber?
    @NSManaged var pacientes: Paciente?

}
