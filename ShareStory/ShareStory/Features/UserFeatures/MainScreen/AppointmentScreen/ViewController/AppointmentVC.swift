//
//  AppointmentVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 01/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AppointmentVC: UIViewController {
    
    @IBOutlet weak var appointmentTableView: UITableView!
    
    private let listAppointmentVM = ListAppointmentVM()
    private let disposeBag = DisposeBag()
    private var appointments = [Appointment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        self.listAppointmentVM.fetchAppointments()
        
        self.listAppointmentVM.appointments
            .drive(onNext: { [unowned self] appointments in
                self.appointments = appointments
                self.appointmentTableView.reloadData()
            }).disposed(by: disposeBag)
        
        self.listAppointmentVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func configureTableView() {
        self.appointmentTableView.delegate = self
        self.appointmentTableView.dataSource = self
    }
}

extension AppointmentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listAppointmentVM.numberOfAppointments
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "appointment_cell", for: indexPath) as? AppointmentCell else {
            return AppointmentCell()
        }
        cell.setupCell(appointment: self.appointments[indexPath.row])
        return cell
    }
}
