//
//  BookingVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 01/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BookingVM {
    
    private let _times = BehaviorRelay<[String]>(value: [])
    private let _hasError = BehaviorRelay<Bool>(value: false)
    private let _isAppointmentCreated = BehaviorRelay<Bool>(value: false)
    
    var times: Driver<[String]> {
        return _times.asDriver()
    }
    
    var hasError: Driver<Bool> {
        return _hasError.asDriver()
    }
    
    var isAppointmentCreated: Driver<Bool> {
        return _isAppointmentCreated.asDriver()
    }
    
    var numberOfTimes: Int {
        return _times.value.count
    }
    
    func getKonselorAvailableTime(konselor: Konselor) {
        let currentDay = self.getCurrentDay()
        switch currentDay {
            case "Monday":
                let times = konselor.schedule.monday.split(separator: ",").map(String.init)
                self._times.accept(times)
            case "Tuesday":
                let times = konselor.schedule.tuesday.split(separator: ",").map(String.init)
                self._times.accept(times)
            case "Wednesday":
                let times = konselor.schedule.wednesday.split(separator: ",").map(String.init)
                self._times.accept(times)
            case "Thursday":
                let times = konselor.schedule.thursday.split(separator: ",").map(String.init)
                self._times.accept(times)
            case "Friday":
                let times = konselor.schedule.friday.split(separator: ",").map(String.init)
                self._times.accept(times)
            default: break
        }
    }
    
    private func getCurrentDay() -> String {
        let date = Date()
        let calendar = Calendar.current
        var currentDay = ""
        var day: Date?
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        day = calendar.date(byAdding: .day,value: 0, to: date)
        currentDay = formatter.string(from: day!)
        return currentDay
    }
    
    private func getCurrentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        var currentDay = ""
        var day: Date?
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        day = calendar.date(byAdding: .day,value: 0, to: date)
        currentDay = formatter.string(from: day!)
        return currentDay
    }
    
    private func getCurrentHour() -> String {
        let date = Date()
        let calendar = Calendar.current
        var currentTime = ""
        var day: Date?
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        day = calendar.date(byAdding: .day,value: 0, to: date)
        currentTime = formatter.string(from: day!)
        return currentTime
    }
    
    func isTimeAvailable(time: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let pickedTime = dateFormatter.date(from:time)!
        let currentTime = dateFormatter.date(from: self.getCurrentHour())
        
        return pickedTime.compare(currentTime!) == .orderedDescending
    }
    
    func sendAppointment(time: String, konselor: Konselor) {
        let timeAppointment = "\(time),\(self.getCurrentTime())"
        DataService.shared.createAppointment(time: timeAppointment, konselor: konselor) { [weak self] (success) in
            if success {
                self?._isAppointmentCreated.accept(true)
            }
        }
    }
}
