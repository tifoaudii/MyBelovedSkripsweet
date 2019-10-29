//
//  DetailOrderKonselingVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 27/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class DetailOrderKonselingVC: UIViewController {

    @IBOutlet weak var patientImageView: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientAgeLabel: UILabel!
    @IBOutlet weak var patientGenderLabel: UILabel!
    
    var requestOrder: RequestOrderVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    fileprivate func setupView() {
        guard requestOrder != nil else {
            return
        }
        self.patientImageView.image = requestOrder?.orderImageView
        self.patientNameLabel.text = requestOrder?.orderUserName
        self.patientAgeLabel.text = "\(String(describing: requestOrder!.orderUserAge)) Tahun"
        self.patientGenderLabel.text = requestOrder?.orderUserGender
    }
    
    @IBAction func acceptOrderButtonDidClicked(_ sender: Any) {
        
    }
    
    @IBAction func declineOrderButtonDidClicked(_ sender: Any) {
        
    }
}

extension DetailOrderKonselingVC {
    
    open func loadOrder(order: RequestOrderVM) {
        self.requestOrder = order
    }
}
