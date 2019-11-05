//
//  KonselingCell.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 26/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class KonselingCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameView: UILabel!
    @IBOutlet weak var userAgeView: UILabel!
    @IBOutlet weak var userGenderView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.layer.cornerRadius = 10
    }
    
    func setupCell(viewModel: RequestOrderVM) {
        self.userImageView.image = viewModel.orderImageView
        self.userNameView.text = viewModel.orderUserName
        self.userAgeView.text = "\(viewModel.orderUserAge)"
        self.userGenderView.text = viewModel.orderUserGender
    }
}
