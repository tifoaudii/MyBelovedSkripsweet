//
//  ChatKonselorCell.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 22/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class ChatKonselorCell: UITableViewCell {

    @IBOutlet weak var konselorImageView: UIImageView!
    @IBOutlet weak var konselorNameLabel: UILabel!
    @IBOutlet weak var messageLabel: ChatLabel!
    @IBOutlet weak var messageStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(messageVM: KonselorMessageVM) {
        self.konselorNameLabel.text = messageVM.senderName
        self.messageLabel.text = messageVM.content
    }
}
