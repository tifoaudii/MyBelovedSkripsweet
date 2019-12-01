//
//  RatingVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 30/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RatingVC: UIViewController {
    
    @IBOutlet weak var konselorImageView: UIImageView!
    @IBOutlet weak var konselorNameLabel: UILabel!
    @IBOutlet weak var ratingStackView: RatingStackView!
    
    private let ratingVM = RatingVM()
    private let disposeBag = DisposeBag()
    private var konselor: Konselor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.setupView()
    }
    
    fileprivate func setupView() {
        guard let konselor = self.konselor else {
            return
        }
        
        self.konselorNameLabel.text = konselor.name
        self.konselorImageView.kf.setImage(with: URL(string: konselor.photoUrl))
        self.konselorImageView.layer.cornerRadius = self.konselorImageView.frame.width / 2
    }
    
    fileprivate func bindViewModel() {
        self.ratingVM.didFinishGiveRating
            .drive(onNext: { [unowned self] didFinishGiveRating in
                if didFinishGiveRating {
                    self.onFinishGiveRating()
                }
            }).disposed(by: disposeBag)
        
        self.ratingVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func finishButtonDidClicked(_ sender: Any) {
        guard let ratingValue = self.ratingStackView.indexButton, let konselor = self.konselor else {
            return self.showValidationMessage(message: "rating")
        }
        
        self.ratingVM.submitRating(rating: ratingValue + 1, konselor: konselor)
    }
}

extension RatingVC {
    
    func onFinishGiveRating() {
        self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    open func setKonselor(konselor: Konselor) {
        self.konselor = konselor
    }
}
