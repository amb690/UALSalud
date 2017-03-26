//
//  ListaPacientesTVC.swift
//  ualSalud
//
//  Created by equipo on 10/12/16.
//  Copyright © 2016 ualSalud. All rights reserved.
//

import UIKit
import CoreData

class ListaPacientesTVC: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var searchActive : Bool = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pacientes = [Paciente]()
    var pacientesFiltrados = [Paciente]()
    
    override func viewDidAppear(animated: Bool)
    {
        self.leerDatos()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leerDatos()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        leerDatos()
    }
    
    // Funcion que lee los datos de la entidad Paciente para cargarlos en la tabla
    func leerDatos()
    {
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Paciente")
        
        do{
            try pacientes = context.executeFetchRequest(request) as! [Paciente]
            
            if (searchBar.text != "" )
            {
                self.pacientesFiltrados = self.pacientes.filter({(paciente: Paciente) -> Bool in
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let fecha = dateFormatter.stringFromDate(paciente.fechaNacimiento!)
                    let stringMatch = fecha.rangeOfString(searchBar.text!)
                    let stringMatch2 = paciente.apellido1!.lowercaseString.rangeOfString(searchBar.text!.lowercaseString)
                    let stringMatch3 = paciente.apellido2!.lowercaseString.rangeOfString(searchBar.text!.lowercaseString)
                    let stringMatch4 = paciente.nombre!.lowercaseString.rangeOfString(searchBar.text!.lowercaseString)
                    
                    return (stringMatch != nil || stringMatch2 != nil || stringMatch3 != nil || stringMatch4 != nil)
                })
            pacientes = pacientesFiltrados
            }
            ordenar()
            self.tableView.reloadData()
            
        }
        catch
        {
            print("No se pudo ejecutar la consulta")
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var numOfSections: Int = 0
        if (self.pacientes.count > 0)
        {
            
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Sin datos disponibles."
            noDataLabel.textAlignment = NSTextAlignment.Center
            noDataLabel.textColor = UIColor.blackColor()//UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            self.tableView.backgroundView  = noDataLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
        }
        return numOfSections
        
        
        
        //return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(tableView == self.searchDisplayController?.searchResultsTableView) {
            return self.pacientesFiltrados.count
        }
        else {
            return pacientes.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PacienteTableViewCell
        
        // Configure the cell...
        
        let paciente: Paciente
        
        if(tableView == self.searchDisplayController?.searchResultsTableView) {
            paciente = self.pacientesFiltrados[indexPath.row]
        }
        else {
            paciente = self.pacientes[indexPath.row]
        }
        
        // Carga IMAGEN
        cell.cellImagen.image  =  UIImage(data: paciente.imagen!)
        cell.cellImagen.layer.cornerRadius = 21.0
        cell.cellImagen.layer.masksToBounds = true
        cell.cellImagen.layer.borderColor = UIColor.blackColor().CGColor
        cell.cellImagen.layer.borderWidth = 3
        
        // Carga NOMBRE
        cell.cellNombrelbl.text = paciente.nombre! + " " + paciente.apellido1! + " " + paciente.apellido2!
        // "\(paciente.nombre) \(paciente.apellido1)"
        
        
        // Calcular EDAD
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let calcAge = calendar.components(.Year, fromDate: paciente.fechaNacimiento!, toDate: NSDate(), options: [])
        cell.cellEdadlbl.text = "\(calcAge.year) Años"
        
        
        // Carga SEXO
        
        if (paciente.sexo == 0)
        {
            cell.cellSexolbl.text = "Hombre"
        }
        else
        {
            cell.cellSexolbl.text = "Mujer"
        }
        
        return cell

    }
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Eliminar" //Customizar boton rojo tabla delete
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            
            let avisoBorrar = UIAlertController(title: "Aviso", message: "¿Está seguro de eliminar el registro?", preferredStyle: .Alert)
            let accionSi = UIAlertAction(title: "Si", style: .Destructive)
            { (alert: UIAlertAction!) -> Void in
              
                let context: NSManagedObjectContext = self.appDel.managedObjectContext
                
                context.deleteObject(self.pacientes[indexPath.row])
                
                do
                {
                    
                    try context.save()
                    //self.pacientes.removeAll()
                    
                    // Recargar tabla
                    self.leerDatos()
                    
                }
                catch
                {
                    print("No se pudo guardar")
                }

            }
            let accionNo = UIAlertAction(title: "No", style: .Default) { (avisoBorrar: UIAlertAction!) -> Void in
                return
            }
            
            avisoBorrar.addAction(accionSi)
            avisoBorrar.addAction(accionNo)
            
            presentViewController(avisoBorrar, animated: true, completion:nil)

            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Segue para mostrar los historiales de cada paciente, al pinchar en el nombre del paciente.
        if segue.identifier == "mostrarHistoriales"
        {
            
            let v = segue.destinationViewController as! ListaHistoricosTVC
            let indexpath = self.tableView.indexPathForSelectedRow
            let row = indexpath?.row
            
            // variable declarada en ViewController
            v.paciente = pacientes[row!]
            
        }
    }
    
    //MARK: -Search
    
    func filterContentForSearchText(searchText: String, scope: String = "Title") {
        self.pacientesFiltrados = self.pacientes.filter({(paciente: Paciente) -> Bool in
            
            let categoryMatch = (scope == "Title")
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let fecha = dateFormatter.stringFromDate(paciente.fechaNacimiento!)
            let stringMatch = fecha.rangeOfString(searchText)
            let stringMatch2 = paciente.apellido1!.rangeOfString(searchText)
            let stringMatch3 = paciente.apellido2!.rangeOfString(searchText)
            let stringMatch4 = paciente.nombre!.rangeOfString(searchText)
            
            return categoryMatch && (stringMatch != nil || stringMatch2 != nil || stringMatch3 != nil || stringMatch4 != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        
        self.filterContentForSearchText(searchString!, scope: "Title")
        
        return true
        
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!, scope: "Title")
        
        return true
    }
    
    func ordenar() {
       let ordenada = pacientes.sort { (paciente1, paciente2) -> Bool in
            if paciente1.apellido1 != paciente2.apellido1 {
                return paciente1.apellido1! < paciente2.apellido1!
            }
            else if paciente1.apellido1! == paciente2.apellido1! && paciente1.apellido2! != paciente2.apellido2! {
                return paciente1.apellido2! < paciente2.apellido2!
            }
        return paciente1.nombre! < paciente2.nombre!
        }
        pacientes = ordenada


    }
}
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
