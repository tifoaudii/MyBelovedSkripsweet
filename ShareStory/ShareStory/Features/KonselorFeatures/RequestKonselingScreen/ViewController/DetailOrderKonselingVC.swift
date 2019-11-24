//
//  DetailOrderKonselingVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 27/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailOrderKonselingVC: UIViewController {
    
    @IBOutlet weak var patientImageView: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientAgeLabel: UILabel!
    @IBOutlet weak var patientGenderLabel: UILabel!
    
    var requestOrder: RequestOrderVM?
    private let orderKonselingVM = OrderKonselingVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        self.orderKonselingVM.chatRoom
            .drive(onNext: { [unowned self] chatRoom in
                guard let chatRoom = chatRoom else {
                    return
                }
                self.onOrderAccepted(chatRoom: chatRoom)
            }).disposed(by: disposeBag)
        
        self.orderKonselingVM.isOrderDeclined
            .drive(onNext: { [unowned self] isOrderDeclined in
                if isOrderDeclined {
                    self.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
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
        guard let order = requestOrder else {
            return
        }
        
        self.orderKonselingVM.acceptOrder(order: order)
    }
    
    @IBAction func declineOrderButtonDidClicked(_ sender: Any) {
        self.onOrderDenied()
    }
}

extension DetailOrderKonselingVC {
    
    open func loadOrder(order: RequestOrderVM) {
        self.requestOrder = order
    }
    
    func onOrderAccepted(chatRoom: ChatRoom) {
        let chatVC = UIStoryboard.init(name: "Konselor", bundle: nil).instantiateViewController(identifier: "ChatVC") as KonselorChatVC
        chatVC.loadChatRoom(chatRoom: chatRoom)
        var currentVC = self.navigationController?.viewControllers
        currentVC?.removeLast()
        currentVC?.append(chatVC)
        self.navigationController?.setViewControllers(currentVC!, animated: true)
    }
    
    func onOrderDenied() {
        let alertController = UIAlertController(title: "Menolak Permintaan Konseling", message: "Apakah Anda Yakin?", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Berikan alasan anda kepada pasien"
        }
        let refuseOrderAction = UIAlertAction(title: "Tolak", style: .destructive) { [unowned self] (_) in
            guard let orderId = self.requestOrder?.orderId, let reasonRefusedOrder = alertController.textFields![0].text else {
                return
            }
            self.orderKonselingVM.declineOrder(orderId: orderId, message: reasonRefusedOrder)
        }
        let cancelAction = UIAlertAction(title: "Batalkan", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(refuseOrderAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
