//
//  KonselorAppointmentVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 10/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class KonselorAppointmentVM {
    
    private let _appointments = BehaviorRelay<[AppointmentVM]>(value: [])
    private let _hasError = BehaviorRelay<Bool>(value: false)
    
    var appointments: Driver<[AppointmentVM]> {
        return _appointments.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var numberOfAppointment: Int {
        return _appointments.value.count
    }
    
    func fetchAppointments() {
        DataService.shared.fetchKonselorAppointments(completion: { [weak self] (appointment) in
            self?._appointments.accept(appointment)
            self?._hasError.accept(false)
        }) { [weak self] in
            self?._hasError.accept(true)
        }
    }
}
