//
//  TabViewController.swift
//  ualSalud
//
//  Created by Alberto Morante on 17/12/16.
//  Copyright © 2016 ualSalud. All rights reserved.
//

import UIKit
import CoreData

class TabViewController: UITabBarController, UITabBarControllerDelegate {
    var paciente:Paciente?
    var historial:Historial?
    
    // MARK: actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        let firstTab = self.viewControllers![0].childViewControllers[0] as! FirstTabController
        let secondTab = self.viewControllers![1].childViewControllers[0] as! SecondTabController
        let thirdTab = self.viewControllers![2].childViewControllers[0] as! ThirdTabController
        //Si hemos pulsado Editar Historial se rellenan los campos del formulario
        if (historial != nil){
            firstTab.nombrehistorialtxt.text = historial?.descripcionHistorial
            firstTab.hipotiroidismosw.on = (historial?.hipotiroidismo?.boolValue)!
            firstTab.tiroxinasw.on = (historial?.tiroxina?.boolValue)!
            //firstTab.tbgsw.on = (historial?.tbg?.boolValue)!
            firstTab.sicksw.on = (historial?.sick?.boolValue)!
            firstTab.referenciasg.selectedSegmentIndex = (historial?.referencia?.integerValue)!
            secondTab.historial=historial
            thirdTab.enfermo = historial?.enfermo?.boolValue
            thirdTab.historial=historial
            thirdTab.medidat3 = historial?.medidat3?.stringValue
            thirdTab.medidafti = historial?.medidafti?.stringValue
            thirdTab.medidatsh = historial?.medidatsh?.stringValue
            thirdTab.medidatt4 = historial?.medidatt4?.stringValue
            thirdTab.tsh = historial?.tsh?.boolValue
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Al cambiar de pestaña se asignaran datos al historial si estamos en la
    //pestaña medidas o enfermo
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let firstTab = self.viewControllers![0].childViewControllers[0] as! FirstTabController
        let secondTab = self.viewControllers![1].childViewControllers[0] as! SecondTabController
        let thirdTab = self.viewControllers![2].childViewControllers[0] as! ThirdTabController
        thirdTab.nombrehistorial = firstTab.nombrehistorialtxt.text
        thirdTab.tiroxina = firstTab.tiroxinasw.on
        thirdTab.hipotiroidismo = firstTab.hipotiroidismosw.on
        //thirdTab.tbg = firstTab.tbgsw.on
        thirdTab.referencia = firstTab.referenciasg.selectedSegmentIndex
        thirdTab.sick = firstTab.sicksw.on
        if (secondTab.t3txt?.text != nil){
            thirdTab.medidat3 = secondTab.t3txt?.text
        }
        if (secondTab.tt4txt?.text != nil){
            thirdTab.medidatt4 = secondTab.tt4txt?.text
        }
        if (secondTab.ftitxt?.text != nil){
            thirdTab.medidafti = secondTab.ftitxt?.text
        }
        if (secondTab.tshtxt?.text != nil){
            thirdTab.medidatsh = secondTab.tshtxt?.text
        }
        if (secondTab.tshsw != nil){
            thirdTab.tsh = secondTab.tshsw?.on
        }
        thirdTab.paciente = paciente
        
        switch firstTab.referenciasg.selectedSegmentIndex
        {
        case 0:
            thirdTab.referencias = "SVHC";
        case 1:
            thirdTab.referencias = "SVI";
        case 2:
            thirdTab.referencias = "STMW";
        case 3:
            thirdTab.referencias = "SVHD";
        case 4:
            thirdTab.referencias = "other";
        default:
            break;
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
