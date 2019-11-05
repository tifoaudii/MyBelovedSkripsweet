//
//  ListKonselingVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 31/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListKonselingVC: UIViewController {

    @IBOutlet weak var listKonselingTableView: UITableView!
    
    private let listKonselingVM = ListKonselingVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bindViewModel()
    }

    fileprivate func bindViewModel() {
        
    }
}
