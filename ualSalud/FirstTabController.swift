//
//  FirstTabController.swift
//  ualSalud
//
//  Created by Alberto Morante on 18/12/16.
//  Copyright © 2016 ualSalud. All rights reserved.
//

import UIKit

class FirstTabController: UIViewController {
    //MARK: properties
    @IBOutlet weak var nombrehistorialtxt: UITextField!
    @IBOutlet weak var tiroxinasw: UISwitch!
    @IBOutlet weak var hipotiroidismosw: UISwitch!
    @IBOutlet weak var tbgsw: UISwitch!
    @IBOutlet weak var referenciasg: UISegmentedControl!
    @IBOutlet weak var sicksw: UISwitch!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelar(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
