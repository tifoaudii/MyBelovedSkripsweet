//
//  ListKonselingVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 31/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ListKonselingVM {
    
    private let _acceptedOrder = BehaviorRelay<[AcceptedOrder]>(value: [])
    private let _hasError = BehaviorRelay<Bool>(value: false)
    
    var acceptedOrder: Driver<[AcceptedOrder]> {
        return _acceptedOrder.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var numberOfAcceptedOrder: Int {
        return _acceptedOrder.value.count
    }
    
    func fetchAllAcceptedOrder() {
        DataService.shared.fetchAllAcceptedOrder(completion: { [weak self] (acceptedOrders) in
            self?._acceptedOrder.accept(acceptedOrders)
            self?._hasError.accept(false)
        }) { [weak self] in
            self?._hasError.accept(true)
        }
    }
    
    func observeNewPatient() {
        DataService.shared.REF_CHATROOM.observe(.value) { [weak self] (_) in
            self?.fetchAllAcceptedOrder()
        }
    }
    
    func viewModelForPatientAt(index: Int) -> KonselingVM? {
        guard index < numberOfAcceptedOrder else {
            return nil
        }
        
        return KonselingVM(acceptedOrder: _acceptedOrder.value[index])
    }
}
