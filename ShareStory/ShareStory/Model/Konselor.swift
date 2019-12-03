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
    var id: String
    var name: String
    var address: String
    var university: String
    var latitude: Double
    var longitude: Double
    var isOnline: Bool
    var coordinate: CLLocationCoordinate2D
    var distance: Double
    var patientCount: Int
    var rating: Double
    var photoUrl: String
    var title: String?
    var schedule: KonselorSchedule
    
    init(id: String, name: String, address: String, university: String, latitude: Double, longitude: Double, isOnline: Bool, distance: Double = 0, patientCount: Int, rating: Double, photoUrl: String, schedule: KonselorSchedule) {
        self.id = id
        self.name = name
        self.address = address
        self.university = university
        self.latitude = latitude
        self.longitude = longitude
        self.isOnline = isOnline
        self.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        self.title = self.name
        self.distance = distance
        self.rating = rating
        self.patientCount = patientCount
        self.photoUrl = photoUrl
        self.schedule = schedule
        super.init()
    }
}

struct KonselorSchedule {
    var monday: String
    var tuesday: String
    var wednesday: String
    var thursday: String
    var friday: String
}
