//
//  DetailKonselorVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 12/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class DetailKonselorVC: UIViewController {
    
    @IBOutlet weak var konselorImage: UIImageView!
    @IBOutlet weak var konselorNameLabel: UILabel!
    @IBOutlet weak var konselorUniversityLabel: UILabel!
    @IBOutlet weak var konselorAddressLabel: UILabel!
    
    private var konselor: Konselor?
    private let orderVm = OrderVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? OrderVC else {
            return
        }
        
        destinationVC.modalPresentationStyle = .fullScreen
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
        DataService.shared.getCurrentUser { [unowned self] (userExist) in
            if !userExist {
                self.navigateToLoginGuide()
            } else {
                guard let konselor = self.konselor else {
                    return
                }
                self.orderVm.createOrder(konselorId: konselor.id)
                self.performSegue(withIdentifier: "order_segue", sender: nil)
            }
        }
    }
    
}

extension DetailKonselorVC {
    open func loadKonselor(konselor: Konselor) {
        self.konselor = konselor
    }
}
