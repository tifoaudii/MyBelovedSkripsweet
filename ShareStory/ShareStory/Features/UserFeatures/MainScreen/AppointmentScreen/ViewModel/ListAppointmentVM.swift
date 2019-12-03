//
//  ListAppointmentVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 01/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ListAppointmentVM {
    
    private let _appointment = BehaviorRelay<[Appointment]>(value: [])
    private let _hasError = BehaviorRelay<Bool>(value: false)
    
    var appointments: Driver<[Appointment]> {
        return _appointment.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var numberOfAppointments: Int {
        return _appointment.value.count
    }
    
    func fetchAppointments() {
        DataService.shared.fetchAppointments(completion: { [weak self] (appointments) in
            self?._appointment.accept(appointments)
            self?._hasError.accept(false)
        }) { [weak self] in
            self?._hasError.accept(true)
        }
    }
    
}
