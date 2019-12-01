//
//  HistoryCell.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 30/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import Kingfisher

class HistoryCell: UITableViewCell {

    @IBOutlet weak var konselorImageView: UIImageView!
    @IBOutlet weak var konselorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.konselorImageView.layer.cornerRadius = self.konselorImageView.frame.width / 2
    }

    func setupCell(historyVM: HistoryVM) {
        self.konselorImageView.kf.setImage(with: URL(string: historyVM.konselorImageUrl))
        self.konselorNameLabel.text = historyVM.konselorName
        self.dateLabel.text = historyVM.date
    }
}
