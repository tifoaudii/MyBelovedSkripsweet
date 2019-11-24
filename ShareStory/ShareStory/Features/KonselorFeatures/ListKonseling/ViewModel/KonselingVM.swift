//
//  KonselingVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 31/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class KonselingVM {
    
    var acceptedOrder: AcceptedOrder
    
    init(acceptedOrder: AcceptedOrder) {
        self.acceptedOrder = acceptedOrder
    }
    
    var patientImageView: UIImage {
        let gender = self.acceptedOrder.patient.gender
        return UIImage(named: gender == .male ? "boy":"girl")!
    }
    
    var patientName: String {
        return self.acceptedOrder.patient.name
    }
    
    var patientGender: String {
        return self.acceptedOrder.patient.gender.rawValue
    }
}
