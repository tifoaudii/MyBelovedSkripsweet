//
//  MessageVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 03/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class MessageVM {
    
    private var message: Message
    private var patient: User
    
    init(message: Message, patient: User) {
        self.message = message
        self.patient = patient
    }
    
    var senderImageView: UIImage {
        let image = UIImage(named: (patient.gender == .male) ? "boy":"girl")
        return image!
    }
    
    var senderName: String {
        return patient.name
    }
    
    var content: String {
        return message.content
    }
}
