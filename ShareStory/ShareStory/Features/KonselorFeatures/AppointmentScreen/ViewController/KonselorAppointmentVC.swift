//
//  KonselorAppointmentVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 10/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class KonselorAppointmentVC: UIViewController {

    @IBOutlet weak var appointmentTableView: UITableView!
    
    private let appointmentVM = KonselorAppointmentVM()
    private let disposeBag = DisposeBag()
    private var appointment = [AppointmentVM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureTableView()
        self.bindViewModel()
    }
    
    fileprivate func configureTableView() {
        self.appointmentTableView.delegate = self
        self.appointmentTableView.dataSource = self
        self.appointmentTableView.tableFooterView = UIView()
    }
    
    fileprivate func bindViewModel() {
        self.appointmentVM.fetchAppointments()
        
        self.appointmentVM.appointments
            .drive(onNext: { [unowned self] appointment in
                self.appointment = appointment
                self.appointmentTableView.reloadData()
            }).disposed(by: disposeBag)
        
        self.appointmentVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
    }
}

extension KonselorAppointmentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appointmentVM.numberOfAppointment
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "konselorAppointmentCell", for: indexPath) as? KonselorAppointmentCell else {
            return UITableViewCell()
        }
        cell.setupCell(appointment: appointment[indexPath.row])
        return cell
    }
    
    
}
