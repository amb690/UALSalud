//
//  Paciente+CoreDataProperties.swift
//  ualSalud
//
//  Created by equipo on 10/12/16.
//  Copyright © 2016 ualSalud. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Paciente {

    @NSManaged var apellido1: String?
    @NSManaged var apellido2: String?
    @NSManaged var fechaNacimiento: NSDate?
    @NSManaged var imagen: NSData?
    @NSManaged var nombre: String?
    @NSManaged var sexo: NSNumber?
    @NSManaged var historiales: NSSet?

}
