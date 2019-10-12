//
//  User.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 10/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation

enum Gender: String {
    case male = "Laki-laki"
    case female = "Perempuan"
}

struct User {
    let name: String
    let birthDay: String
    let email: String
    let gender: Gender
    let password: String
}
