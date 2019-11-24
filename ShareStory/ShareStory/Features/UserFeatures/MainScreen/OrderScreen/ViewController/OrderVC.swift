//
//  OrderVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 23/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderVC: UIViewController {
    
    private var orderId: String?
    private let orderVM = OrderVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.observeOrderStatus()
        self.bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        self.orderVM.isOrderCanceled
            .drive(onNext: { [unowned self] isOrderCanceled in
                if isOrderCanceled {
                    self.onOrderCanceled()
                }
            }).disposed(by: disposeBag)
        
        self.orderVM.isOrderAccepted
            .drive(onNext: { [unowned self] isOrderAccepted in
                if isOrderAccepted {
                    self.onOrderAccepted()
                }
            }).disposed(by: disposeBag)
        
        self.orderVM.isOrderRefused
            .drive(onNext: { [unowned self] isOrderRefused in
                if isOrderRefused {
                    self.onOrderRefused()
                }
            }).disposed(by: disposeBag)
        
        self.orderVM.chatRoom
            .drive(onNext: { [unowned self] chatRoom in
                guard chatRoom != nil else {
                    return
                }
                self.navigateToChatVC(chatRoom: chatRoom!)
            }).disposed(by: disposeBag)
    }
    
    fileprivate func observeOrderStatus() {
        guard let orderId = self.orderId else {
            return
        }
        
        self.orderVM.observeOrderStatus(orderId: orderId)
    }
    
    @IBAction func cancelButtonDidClicked(_ sender: Any) {
        guard let orderId = self.orderId else {
            return
        }
        
        self.orderVM.cancelOrder(orderId: orderId)
    }
}

extension OrderVC {
    
    open func setOrderId(orderId: String) {
        self.orderId = orderId
    }
    
    func onOrderCanceled() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onOrderAccepted() {
        guard let orderId = self.orderId else {
            return
        }
        
        self.orderVM.getChatRoom(orderId: orderId)
    }
    
    func onOrderRefused() {
        guard let orderId = self.orderId else {
            return
        }
        
        self.orderVM.getOrderRefusedMessage(orderId: orderId) { [unowned self] (message) in
            let alertController = UIAlertController(title: "Permintaan Anda Ditolak Konselor", message: "'\(message)'", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Mengerti", style: .cancel) { [unowned self] (_) in
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func navigateToChatVC(chatRoom: ChatRoom) {
        let chatVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ChatVC") as ChatVC
        chatVC.loadChatRoom(chatRoom: chatRoom)
        chatVC.modalPresentationStyle = .fullScreen
        self.present(chatVC, animated: true) { [unowned self] in
            
        }
    }
}
