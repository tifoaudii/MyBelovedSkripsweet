//
//  SplashVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 09/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseAuth
import MapKit

class SplashVC: UIViewController {
   
   private let splashVM = SplashVM()
   private let disposeBag = DisposeBag()
   private let locationManager = CLLocationManager()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.getUserLocation()
      self.bindViewModel()
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      self.checkLocationAuthorization()
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard let mainVC = segue.destination as? UITabBarController else {
         return
      }
      mainVC.modalPresentationStyle = .fullScreen
   }
   
   fileprivate func bindViewModel() {
      self.splashVM
         .isUpdateUserLocationSuccess
         .drive(onNext: { [unowned self] success in
            if success {
               DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [unowned self] in
                  self.performSegue(withIdentifier: "main_segue", sender: nil)
               }
            }
         }).disposed(by: disposeBag)
   }
   
   fileprivate func getUserLocation() {
      guard let userLocation = locationManager.location?.coordinate else {
         return
      }
      
      self.splashVM.updateUserLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
   }
   
   fileprivate func checkLocationAuthorization() {
       if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
           locationManager.requestWhenInUseAuthorization()
       }
   }
}