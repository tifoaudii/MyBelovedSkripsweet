//
//  AppointmentCell.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 01/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import Kingfisher

class AppointmentCell: UITableViewCell {
    
    @IBOutlet weak var konselorImageView: UIImageView!
    @IBOutlet weak var konselorNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.konselorImageView.layer.cornerRadius = self.konselorImageView.frame.width / 2
    }
    
    func setupCell(appointment: Appointment) {
        self.konselorImageView.kf.setImage(with: URL(string: appointment.konselorPhotoUrl))
        self.konselorNameLabel.text = appointment.konselorName
        self.timeLabel.text = appointment.date
    }
}
