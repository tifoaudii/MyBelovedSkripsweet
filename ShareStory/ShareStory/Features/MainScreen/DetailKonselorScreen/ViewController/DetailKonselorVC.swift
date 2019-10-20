//
//  DetailKonselorVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 12/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import Kingfisher

class DetailKonselorVC: UIViewController {
    
    @IBOutlet weak var konselorImage: UIImageView!
    @IBOutlet weak var konselorNameLabel: UILabel!
    @IBOutlet weak var konselorUniversityLabel: UILabel!
    @IBOutlet weak var konselorAddressLabel: UILabel!
    
    private var konselor: Konselor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    fileprivate func setupView() {
        guard konselor != nil else {
            return
        }
        
        self.konselorNameLabel.text = konselor?.name
        self.konselorUniversityLabel.text = konselor?.university
        self.konselorAddressLabel.text = konselor?.address
    }
    
    @IBAction func startKonseling(_ sender: Any) {
        DataService.shared.getCurrentUser { (userExist) in
            if userExist {
                
            } else {
                self.navigateToLoginGuide()
            }
        }
    }
    
}

extension DetailKonselorVC {
    
    open func loadKonselor(konselor: Konselor) {
        self.konselor = konselor
    }
}
