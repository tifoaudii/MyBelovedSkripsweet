//
//  Konselor.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 12/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import MapKit

class Konselor: NSObject, MKAnnotation {
    var name: String
    var address: String
    var university: String
    var latitude: Double
    var longitude: Double
    var isOnline: Bool
    var coordinate: CLLocationCoordinate2D
    var distance: Double
    var title: String?
    
    init(name: String, address: String, university: String, latitude: Double, longitude: Double, isOnline: Bool, distance: Double = 0) {
        self.name = name
        self.address = address
        self.university = university
        self.latitude = latitude
        self.longitude = longitude
        self.isOnline = isOnline
        self.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        self.title = self.name
        self.distance = distance
        super.init()
    }

}
