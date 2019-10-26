//
//  ListKonselorCell.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 13/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import Kingfisher

class ListKonselorCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var konselorNameLabel: UILabel!
    @IBOutlet weak var konselorImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellView.layer.cornerRadius = 10
        self.cellView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.konselorImageView.layer.cornerRadius = self.konselorImageView.frame.width / 2
    }
    
    func configureCell(konselor: Konselor) {
        self.konselorNameLabel.text = konselor.name
        self.distanceLabel.text = "\(konselor.distance) km"
    }
}
