//
//  HistoryVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 30/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//


import UIKit
import Kingfisher

class HistoryVM {
    
    var history: History
    
    init(history: History) {
        self.history = history
    }
    
    var konselorImageUrl: String {
        return history.konselorPhotoUrl
    }
    
    var konselorName: String {
        return history.konselorName
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: history.date)
        return result
    }
}
