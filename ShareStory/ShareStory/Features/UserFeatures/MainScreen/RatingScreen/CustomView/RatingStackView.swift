//
//  RatingStackView.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 30/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class RatingStackView: UIStackView {
    
    var indexButton: Int?
    var starsButton = [UIButton]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupView()
    }
    
    func setupView() {
        self.starsButton = (0...4).map({ (index) -> UIButton in
            let button = UIButton(type: .system)
            button.setBackgroundImage(UIImage.init(systemName: "star")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal), for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(self.starButtonDidClicked(_:)), for: .touchUpInside)
            return button
        })
        
        starsButton.forEach({
            addArrangedSubview($0)
        })
    }
    
    @objc func starButtonDidClicked(_ sender: UIButton) {
        self.indexButton = sender.tag
        self.starsButton = self.starsButton.map({ (button) -> UIButton in
            if button.tag <= indexButton! {
                button.setBackgroundImage(UIImage.init(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal), for: .normal)
            } else {
                button.setBackgroundImage(UIImage.init(systemName: "star")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal), for: .normal)
            }
            return button
        })
        
        layoutIfNeeded()
    }
}
