//
//  RatingVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 30/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RatingVM {
    
    let _didFinishGiveRating = BehaviorRelay<Bool>(value: false)
    let _hasError = BehaviorRelay<Bool>(value: false)
    
    var didFinishGiveRating: Driver<Bool> {
        return _didFinishGiveRating.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    func submitRating(rating: Int, konselor: Konselor) {
        DataService.shared.submitRating(rating: rating, konselor: konselor) { [weak self] (success) in
            if success {
                self?._didFinishGiveRating.accept(true)
            }
        }
    }
}
