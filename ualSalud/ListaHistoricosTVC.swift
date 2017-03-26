//
//  ListaHistoricosTVC.swift
//  ualSalud
//
//  Created by equipo on 11/12/16.
//  Copyright © 2016 ualSalud. All rights reserved.
//

import UIKit
import CoreData

class ListaHistoricosTVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate //UITableViewController
{

    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var searchActive : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nombreTxt: UILabel!
    @IBOutlet weak var edadTxt: UILabel!
    @IBOutlet weak var sexoTxt: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var paciente:Paciente?
    
    var historiales = [Historial]()
    var historialesFiltrados = [Historial]()

    override func viewDidAppear(animated: Bool)
    {
        
        self.setearDatosPaciente()
        self.leerHistoriales()
       /* if (searchBar.text == "")
        {
            self.leerHistoriales()
        }
        else
        {
            searchBar(searchBar,textDidChange: searchBar.text!)
        }*/
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
        searchBar.delegate = self
        
        self.setearDatosPaciente()
        self.leerHistoriales()
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
        leerHistoriales()
        
      /*  if (searchText != "" )
        {
            self.historialesFiltrados = self.historiales.filter({(historial: Historial) -> Bool in
            
            
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let fecha = dateFormatter.stringFromDate(historial.fechaAlta!)
                let stringMatch = fecha.rangeOfString(searchText)
                let stringMatch2 = historial.descripcionHistorial?.rangeOfString(searchText)
            
                return  (stringMatch != nil || stringMatch2 != nil)
            })
        historiales = historialesFiltrados
        }
        self.tableView.reloadData()*/
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
    func leerHistoriales()
    {
        //historiales.removeAll()
        
        historiales.removeAll()
        if let historiales_de_p = paciente!.historiales
        {
            for historial in historiales_de_p
            {
                let h = historial as! Historial
                historiales.insert(h, atIndex: 0)
            }
        }
        
        if (searchBar.text != "" )
        {
            self.historialesFiltrados = self.historiales.filter({(historial: Historial) -> Bool in
                
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let fecha = dateFormatter.stringFromDate(historial.fechaAlta!)
                let stringMatch = fecha.rangeOfString(searchBar.text!)
                let stringMatch2 = historial.descripcionHistorial?.lowercaseString.rangeOfString(searchBar.text!.lowercaseString)
                
                return  (stringMatch != nil || stringMatch2 != nil)
            })
            historiales = historialesFiltrados
        }
    /*   else
        {
            historiales.removeAll()
            if let historiales_de_p = paciente!.historiales
            {
                for historial in historiales_de_p
                {
                    let h = historial as! Historial
                    historiales.insert(h, atIndex: 0)
                }
            }
        }*/
        
        ordenar()
        //historialesAUX = historiales
        self.tableView.reloadData()
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if (self.historiales.count > 0)
        {
            
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Sin datos disponibles."
            noDataLabel.textAlignment = NSTextAlignment.Center
            noDataLabel.textColor = UIColor.blackColor()
            self.tableView.backgroundView  = noDataLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
        }
        return numOfSections
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(tableView == self.searchDisplayController?.searchResultsTableView) {
            return self.historialesFiltrados.count
        }
        else {
            return historiales.count
        }
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Eliminar" //Customizar boton rojo tabla delete
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete
        {

            let avisoBorrar = UIAlertController(title: "Aviso", message: "¿Está seguro de eliminar el registro?", preferredStyle: .Alert)
            let accionSi = UIAlertAction(title: "Si", style: .Destructive)
            { (alert: UIAlertAction!) -> Void in
                
                let context: NSManagedObjectContext = self.appDel.managedObjectContext
                
                context.deleteObject(self.historiales[indexPath.row])
                self.historiales.removeAtIndex(indexPath.row)
                
                do
                {
                    try context.save()
                    //self.historiales.removeAll()
                    
                    // Recargar tabla
                    self.leerHistoriales()
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
     
        
        } 
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellHistorial", forIndexPath: indexPath)
        
        let historial: Historial
        
        if(tableView == self.searchDisplayController?.searchResultsTableView) {
            historial = self.historialesFiltrados[indexPath.row]
        }
        else {
            historial = self.historiales[indexPath.row]
        }
        
        cell.textLabel?.text = historial.descripcionHistorial
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        cell.detailTextLabel?.text  = "Fecha de Alta:  \(dateFormatter.stringFromDate(historial.fechaAlta!))"
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        
        // Mostrar la ficha de un historico concreto
        if segue.identifier == "mostrarFichaHistorico"
        {
            // Utiliza el mismo ViewController que el de añadir paciente
            let v = segue.destinationViewController as! FichaHistoricoViewController
            let indexpath = self.tableView.indexPathForSelectedRow
            let row = indexpath?.row
            
            // Variable declarada en DatosHistorialViewController para pasar datos de paciente
            v.paciente = paciente
            v.historial = historiales[row!]
        }
        
        // Editar perfil de un paciente
        if segue.identifier == "editarPerfil"
        {
            // Utiliza el mismo ViewController que el de añadir paciente
            let v = segue.destinationViewController as! ViewController
            let indexpath = self.tableView.indexPathForSelectedRow
            
            // Variable declarada en DatosHistorialViewController para pasar datos de paciente
            v.paciente = paciente
        }
        
        /*
        // Edita un historial de un paciente
        if segue.identifier == "editarHistorial"
        {
            // Llamada al controlador de datos de historial
            let v = segue.destinationViewController as! DatosHistorialViewController
            let indexpath = self.tableView.indexPathForSelectedRow
            let row = indexpath?.row
            
            // Variable declarada en DatosHistorialViewController
            v.historial = historiales[row!]
            v.paciente = paciente
        }*/
        
        // Añade un nuevo historial
        if segue.identifier == "addHistorial"
        {
            // Llamada al controlador de datos de historial
            let v = segue.destinationViewController as! TabViewController
            let indexpath = self.tableView.indexPathForSelectedRow
            let row = indexpath?.row
            
            // Variable declarada en DatosHistorialViewController
            v.paciente = paciente
        }
        
    }
    
    //MARK: -Search
    
    func filterContentForSearchText(searchText: String, scope: String = "Title") {
        self.historialesFiltrados = self.historiales.filter({(historial: Historial) -> Bool in
            
            let categoryMatch = (scope == "Title")
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let fecha = dateFormatter.stringFromDate(historial.fechaAlta!)
            let stringMatch = fecha.rangeOfString(searchText)
            let stringMatch2 = historial.descripcionHistorial?.rangeOfString(searchText)
            
            return categoryMatch && (stringMatch != nil || stringMatch2 != nil)
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
        historiales.sortInPlace({ $0.fechaAlta!.compare($1.fechaAlta!) == .OrderedDescending})
    }


}
