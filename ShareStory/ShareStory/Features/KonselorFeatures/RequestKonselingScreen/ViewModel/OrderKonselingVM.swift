//
//  KonselingVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 26/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class OrderKonselingVM {
    
    private let _requestOrders = BehaviorRelay<[RequestOrder]>(value: [])
    private let _hasError = BehaviorRelay<Bool>(value: false)
    private let _isOrderAccepted = BehaviorRelay<Bool>(value: false)
    private let _isOrderDeclined = BehaviorRelay<Bool>(value: false)
    private let _chatRoom = BehaviorRelay<ChatRoom?>(value: nil)
    
    var requestOrders: Driver<[RequestOrder]> {
        return _requestOrders.asDriver()
    }
    
    var isOrderAccepted: Driver<Bool> {
        return _isOrderAccepted.asDriver()
    }
    
    var chatRoom: Driver<ChatRoom?> {
        return _chatRoom.asDriver()
    }
    
    var isOrderDeclined: Driver<Bool> {
        return _isOrderDeclined.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var numberOfRequestOrders: Int {
        return _requestOrders.value.count
    }
    
    func fetchRequestOrders() {
        DataService.shared.getRequestOrderFromUser(completion: { [weak self] (requestOrders) in
            self?._requestOrders.accept(requestOrders)
            self?._hasError.accept(false)
        }) { [weak self] in
            self?._hasError.accept(true)
        }
    }
    
    func viewModelForOrder(at index: Int) -> RequestOrderVM? {
        guard index < _requestOrders.value.count else {
            return nil
        }
        
        return RequestOrderVM(with: _requestOrders.value[index])
    }
    
    func acceptOrder(order: RequestOrderVM) {
        DataService.shared.acceptOrder(order: order) { [weak self] (chatRoom) in
            self?._isOrderAccepted.accept(true)
            self?._chatRoom.accept(chatRoom)
            self?.createHistoryOrder(chatRoom: chatRoom)
        }
    }
    
    func observeRequestOrders() {
        DataService.shared.REF_ORDER.observe(.value) { [weak self] (_) in
            self?.fetchRequestOrders()
        }
    }
    
    func declineOrder(orderId: String, message: String) {
        DataService.shared.declineOrder(orderId: orderId, message: message) {[weak self] (success) in
            if success {
                self?._isOrderDeclined.accept(true)
            }
        }
    }
    
    func createHistoryOrder(chatRoom: ChatRoom) {
        DispatchQueue.global(qos: .utility).async { 
            DataService.shared.createHistoryOrder(chatRoom: chatRoom)
        }
    }
}
