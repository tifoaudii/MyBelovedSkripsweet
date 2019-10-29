//
//  RequestOrderVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 26/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

struct RequestOrderVM {
    
    private var order: RequestOrder
    
    init(with order: RequestOrder) {
        self.order = order
    }
    
    var orderId: String {
        return order.orderId
    }
    
    var orderImageView: UIImage {
        let image = UIImage(named: (self.order.sender.gender == .male) ? "boy": "girl")
        return image!
    }
    
    var orderUserName: String {
        return order.sender.name
    }
    
    var orderUserGender: String {
        return order.sender.gender.rawValue
    }
    
    var orderUserAge: Int {
        return self.calculateUserAge(birthday: self.order.sender.birthDay)
    }
    
    fileprivate func calculateUserAge(birthday: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let dateOfBirth = dateFormatter.date(from: birthday)
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year], from: dateOfBirth!, to: Date())
        return dateComponents.year ?? 0
    }
}
