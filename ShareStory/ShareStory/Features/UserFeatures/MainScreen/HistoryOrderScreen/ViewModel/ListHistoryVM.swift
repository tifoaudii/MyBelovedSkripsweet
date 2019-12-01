//
//  ListHistoryVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 30/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ListHistoryVM {
    
    private let _historyOrder = BehaviorRelay<[History]>(value: [])
    private let _hasError = BehaviorRelay<Bool>(value: false)
    
    var historyOrders: Driver<[History]> {
        return _historyOrder.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var numberOfHistoryOrders: Int {
        return _historyOrder.value.count
    }
    
    func fetchHistoryOrders() {
        DataService.shared.getHistoryOrder(completion: { [weak self] (histories) in
            self?._historyOrder.accept(histories)
            self?._hasError.accept(false)
        }) { [weak self] in
            self?._hasError.accept(true)
        }
    }
    
    func viewModelForHistoryAt(index: Int) -> HistoryVM? {
        guard index < numberOfHistoryOrders else {
            return nil
        }
        
        return HistoryVM(history: _historyOrder.value[index])
    }
}
