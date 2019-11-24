//
//  OrderVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 23/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class OrderVM {
    
    private let _orderId = BehaviorRelay<String>(value: "")
    private let _chatRoom = BehaviorRelay<ChatRoom?>(value: nil)
    private let _isUserExist = BehaviorRelay<Bool>(value: false)
    private let _isOrderSuccess = BehaviorRelay<Bool>(value: false)
    private let _isOrderAccepted = BehaviorRelay<Bool>(value: false)
    private let _isOrderRefused = BehaviorRelay<Bool>(value: false)
    private let _isOrderCanceled = BehaviorRelay<Bool>(value: false)
    private let _hasError = BehaviorRelay<Bool>(value: false)
    
    var chatRoom: Driver<ChatRoom?> {
        return _chatRoom.asDriver()
    }
    
    var orderId: Driver<String> {
        return _orderId.asDriver()
    }
    
    var isUserExist: Driver<Bool> {
        return _isUserExist.asDriver()
    }
    
    var isOrderSuccess: Driver<Bool> {
        return _isOrderSuccess.asDriver()
    }
    
    var isOrderAccepted: Driver<Bool> {
        return _isOrderAccepted.asDriver()
    }
    
    var isOrderRefused: Driver<Bool> {
        return _isOrderRefused.asDriver()
    }
    
    var isOrderCanceled: Driver<Bool> {
        return _isOrderCanceled.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    func getCurrentUser() {
        DataService.shared.getCurrentUser { [weak self] (isUserExist) in
            if isUserExist {
                self?._isUserExist.accept(true)
            }
        }
    }
    
    func createOrder(konselorId: String, completion: @escaping (_ orderId: String)->()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let newOrder = Order(senderId: userId, konselorId: konselorId, status: .waiting)
        DataService.shared.createOrder(order: newOrder) { (orderSuccess, orderId) in
            if orderSuccess {
                completion(orderId)
            }
        }
    }
    
    func getChatRoom(orderId: String) {
        DataService.shared.getChatRoom(orderId: orderId, completion: { [weak self] (chatRoom) in
            self?._chatRoom.accept(chatRoom)
        }) { [weak self] in
            self?._hasError.accept(true)
        }
    }
    
    func getOrderRefusedMessage(orderId: String, completion: @escaping (_ message: String)->()) {
        DataService.shared.REF_ORDER.child(orderId).observeSingleEvent(of: .value) { (orderSnapshot) in
            let orderInfo = orderSnapshot.childSnapshot(forPath: "info").value as! String
            completion(orderInfo)
        }
    }
    
    func observeOrderStatus(orderId: String) {
        DataService.shared.REF_ORDER.child(orderId).observe(.value) { [weak self] (orderSnapshot) in
            let orderStatus = orderSnapshot.childSnapshot(forPath: "status").value as! String
            
            switch OrderStatus.init(rawValue: orderStatus) {
            case .accepted:
                self?._isOrderAccepted.accept(true)
            case .refused:
                self?._isOrderRefused.accept(true)
            case .cancel:
                self?._isOrderCanceled.accept(true)
            default:
                break
            }
        }
    }
    
    func cancelOrder(orderId: String) {
        DataService.shared.REF_ORDER.child(orderId).updateChildValues(["status": OrderStatus.cancel.rawValue])
    }
}
