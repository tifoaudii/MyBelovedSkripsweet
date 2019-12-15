//
//  HistoryCell.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 14/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class KonselorHistoryCell: UITableViewCell {

    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(patientName: String, time: String) {
        self.patientName.text = patientName
        self.timeLabel.text = time
    }

}
