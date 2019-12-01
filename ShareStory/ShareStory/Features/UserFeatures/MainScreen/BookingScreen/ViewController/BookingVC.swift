//
//  BookingVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 01/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

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
    
    private let cellId = "bookingCell"
    private var selectedTime = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureCollectionView()
    }
    
    fileprivate func configureCollectionView() {
        self.view.addSubview(scheduleCollectionView)
        self.scheduleCollectionView.delegate = self
        self.scheduleCollectionView.dataSource = self
        self.scheduleCollectionView.register(BookingCell.self, forCellWithReuseIdentifier: cellId)
        self.scheduleCollectionView.allowsMultipleSelection = false
        self.scheduleCollectionView.anchor(top: scheduleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 50)
    }
    
}

extension BookingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? BookingCell else {
            return BookingCell()
        }
        
        cell.time = "13.00"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: self.scheduleCollectionView.frame.height - 10)
    }
}
