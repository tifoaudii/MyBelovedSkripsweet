//
//  PatientKonselorChatCell.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 02/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class PatientKonselorChatCell: UITableViewCell {
    
    @IBOutlet weak var patientImageView: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var messageLabel: ChatLabel!
    @IBOutlet weak var messageStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(messageVM: PatientMessageVM) {
        self.patientImageView.image = messageVM.senderImageView
        self.patientNameLabel.text = messageVM.senderName
        self.messageLabel.text = messageVM.content
    }
}
