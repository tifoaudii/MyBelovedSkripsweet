//
//  Order.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 23/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation

enum OrderStatus: String {
    case waiting = "Menunggu"
    case refused = "Ditolak"
    case accepted = "Diterima"
}

struct Order {
    var senderId: String
    var konselorId: String
    var status: OrderStatus
}

struct RequestOrder {
    var orderId: String
    var sender: User
}
