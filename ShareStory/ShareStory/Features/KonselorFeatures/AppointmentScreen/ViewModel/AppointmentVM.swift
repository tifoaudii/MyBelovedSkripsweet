//
//  AppointmentVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 10/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class AppointmentVM {
    
    var appointment: Appointment
    var patient: User
    
    init(appointment: Appointment, patient: User) {
        self.appointment = appointment
        self.patient = patient
    }
    
    var image: UIImage {
        let image = UIImage(named: patient.gender == .male ? "boy" : "girl")
        return image!
    }
    
    var name: String {
        return patient.name
    }
    
    var gender: String {
        return patient.gender.rawValue
    }
    
    var time: String {
        return appointment.date
    }
    
}
