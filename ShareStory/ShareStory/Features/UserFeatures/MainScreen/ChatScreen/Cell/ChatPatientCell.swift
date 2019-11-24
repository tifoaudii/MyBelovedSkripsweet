//
//  ChatPatientCell.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 22/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class ChatPatientCell: UITableViewCell {

    @IBOutlet weak var messageLabel: ChatLabel!
    @IBOutlet weak var messageStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(message: String) {
        self.messageLabel.text = message
    }

}
