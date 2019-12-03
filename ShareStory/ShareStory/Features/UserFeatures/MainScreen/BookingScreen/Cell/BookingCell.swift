//
//  BookingCell.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 01/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class BookingCell: UICollectionViewCell {
    
    var time: String? {
        didSet {
            guard time != nil else {
                return
            }
            self.timeLabel.text = time
        }
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .systemTeal
                self.timeLabel.textColor = .white
            } else {
                self.backgroundColor = .secondarySystemBackground
                self.timeLabel.textColor = .black
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        self.backgroundColor = .secondarySystemBackground
        self.addSubview(timeLabel)
        
        timeLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
    }
}
