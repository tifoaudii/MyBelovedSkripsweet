//
//  ListKonselingCell.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 31/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class ListKonselingCell: UITableViewCell {

    @IBOutlet weak var patientImageView: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientGenderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(konselingVM: KonselingVM) {
        self.patientImageView.image = konselingVM.patientImageView
        self.patientNameLabel.text = konselingVM.patientName
        self.patientGenderLabel.text = konselingVM.patientGender
    }
}
