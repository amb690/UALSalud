//
//  PacienteTableViewCell.swift
//  ualSalud
//
//  Created by equipo on 11/12/16.
//  Copyright © 2016 ualSalud. All rights reserved.
//

import UIKit

class PacienteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellNombrelbl: UILabel!
    
    @IBOutlet weak var cellEdadlbl: UILabel!
    
    @IBOutlet weak var cellSexolbl: UILabel!
    
    @IBOutlet weak var cellImagen: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
