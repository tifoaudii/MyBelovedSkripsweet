//
//  SplashVM.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 10/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa
import MapKit

class SplashVM {
   
   private let _updateUserLocationStatus = BehaviorRelay<Bool>(value: false)
   
   var isUpdateUserLocationSuccess: Driver<Bool> {
      return _updateUserLocationStatus.asDriver()
   }
   
   func updateUserLocation(latitude: Double, longitude: Double, failure: @escaping ()-> Void) {
      DispatchQueue.global(qos: .utility).async {
         DataService.shared.userLocation = CLLocation(latitude: latitude, longitude: longitude)
      }
      
      guard let currentUser = Auth.auth().currentUser else {
         failure()
         return
      }
      
      let userLocation = [
         "latitude": latitude,
         "longitude": longitude
      ]
      
      DataService.shared.updateUserLocation(uid: currentUser.uid, location: userLocation) { [weak self] in
         self?._updateUserLocationStatus.accept(true)
      }
   }
}
