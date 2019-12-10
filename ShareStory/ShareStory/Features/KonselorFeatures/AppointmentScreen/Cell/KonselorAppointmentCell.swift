//
//  KonselorAppointmentCell.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 10/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class KonselorAppointmentCell: UITableViewCell {

    @IBOutlet weak var appointmentImage: UIImageView!
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(appointment: AppointmentVM) {
        self.appointmentImage.image = appointment.image
        self.patientName.text = appointment.name
        self.date.text = appointment.time
        self.gender.text = appointment.gender
    }
}
