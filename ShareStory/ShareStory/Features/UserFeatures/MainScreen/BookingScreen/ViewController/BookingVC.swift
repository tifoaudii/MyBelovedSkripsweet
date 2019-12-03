//
//  BookingVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 01/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BookingVC: UIViewController {

    @IBOutlet weak var konselorImageView: UIImageView!
    @IBOutlet weak var konselorNameLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    
    let scheduleCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        viewLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = viewLayout
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let bookingVM = BookingVM()
    private let disposeBag = DisposeBag()
    private let cellId = "bookingCell"
    private var konselor: Konselor?
    private var times = [String]()
    private var selectedTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureCollectionView()
        self.setupView()
        self.bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        guard let konselor = self.konselor else {
            return
        }
        self.bookingVM.getKonselorAvailableTime(konselor: konselor)
        
        self.bookingVM.times
            .drive(onNext: { [unowned self] times in
                self.times = times
                self.scheduleCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        self.bookingVM.isAppointmentCreated
            .drive(onNext: { [unowned self] success in
                if success {
                    self.onAppointmentSuccessfulCreated()
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func setupView() {
        guard konselor != nil else {
            return
        }
        
        self.konselorNameLabel.text = konselor?.name
        self.konselorImageView.kf.setImage(with: URL(string: konselor?.photoUrl ?? ""))
        self.konselorImageView.layer.cornerRadius = self.konselorImageView.frame.width / 2
    }
    
    fileprivate func configureCollectionView() {
        self.view.addSubview(scheduleCollectionView)
        self.scheduleCollectionView.delegate = self
        self.scheduleCollectionView.dataSource = self
        self.scheduleCollectionView.register(BookingCell.self, forCellWithReuseIdentifier: cellId)
        self.scheduleCollectionView.allowsMultipleSelection = false
        self.scheduleCollectionView.anchor(top: scheduleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 50)
    }
    
    @IBAction func dismissButtonDidClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendButtonDidClicked(_ sender: Any) {
        if selectedTime.isEmpty {
            return self.showValidationMessage(message: "Waktu")
        }
        
        if let konselor = konselor {
            self.bookingVM.sendAppointment(time: selectedTime, konselor: konselor)
        }
    }
}

extension BookingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bookingVM.numberOfTimes
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedTime = self.times[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? BookingCell else {
            return BookingCell()
        }
        let time = self.times[indexPath.item]
        cell.time = time
        if !bookingVM.isTimeAvailable(time: time) {
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = .lightGray
            cell.alpha = 0.75
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: self.scheduleCollectionView.frame.height - 10)
    }
    
    func onAppointmentSuccessfulCreated() {
        let alertController = UIAlertController(title: "Berhasil Membuat Appointment", message: "", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Ok", style: .default) { [unowned self] (_) in
            self.presentingViewController?
                .presentingViewController?
                .dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    open func setKonselor(konselor: Konselor) {
        self.konselor = konselor
    }
}
