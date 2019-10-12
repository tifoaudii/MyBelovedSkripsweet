//
//  MapVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 12/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let mapVM = MapVM()
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 10000
    private var konselors = [Konselor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureMapView()
        self.fetchAllKonselors()
        self.bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkLocationAuthorization()
    }
    
    fileprivate func fetchAllKonselors() {
        self.mapVM.getKonselors()
    }
    
    fileprivate func bindViewModel() {
        self.mapVM
            .hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
        
        self.mapVM
            .konselors
            .drive(onNext: { [unowned self] konselors in
                self.konselors = konselors
                self.refreshMapView()
            }).disposed(by: disposeBag)
    }
    
    fileprivate func configureMapView() {
        self.mapView.delegate = self
        guard let userLocation = locationManager.location?.coordinate else {
            return
        }
        
        let coordinateRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    fileprivate func checkLocationAuthorization() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    fileprivate func showErrorMessage() {
        let alertController = UIAlertController(title: "Uppss", message: "Sepertinya ada gangguan dikit, coba lagi ya", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func centeredUserLocation(_ sender: Any) {
        guard let userLocation = locationManager.location?.coordinate else {
            return
        }
        
        let coordinateRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: regionRadius * 2, longitudinalMeters: regionRadius * 2)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapVC: MKMapViewDelegate {
    
    func refreshMapView() {
        let currentAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(currentAnnotations)
        self.mapView.addAnnotations(self.konselors)
    }
}
