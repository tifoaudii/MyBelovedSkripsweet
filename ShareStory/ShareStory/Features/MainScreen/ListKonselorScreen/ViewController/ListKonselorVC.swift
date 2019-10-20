//
//  ListKonselorVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 13/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListKonselorVC: UIViewController {
    
    @IBOutlet weak var konselorTableView: UITableView!
    
    private let listKonselorVM = ListKonselorVM()
    private let disposeBag = DisposeBag()
    private var konselors = [Konselor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.bindViewModel()
    }
        
    fileprivate func configureTableView() {
        self.konselorTableView.delegate = self
        self.konselorTableView.dataSource = self
        self.konselorTableView.tableFooterView = UIView()
    }
    
    fileprivate func bindViewModel() {
        self.listKonselorVM.observeKonselor()
        self.listKonselorVM.konselors
            .drive(onNext: { [unowned self] konselors in
                self.konselors = konselors
                self.konselorTableView.reloadData()
            }).disposed(by: self.disposeBag)

        self.listKonselorVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
    }
}

extension ListKonselorVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.konselors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListKonselorIdentifier", for: indexPath) as? ListKonselorCell else {
            return ListKonselorCell()
        }
        let konselor = konselors[indexPath.row]
        cell.configureCell(konselor: konselor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        konselorTableView.deselectRow(at: indexPath, animated: true)
        let konselor = konselors[indexPath.row]
        
        let detailKonselorVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailKonselor") as DetailKonselorVC
        detailKonselorVC.loadKonselor(konselor: konselor)
        self.present(detailKonselorVC, animated: true, completion: nil)
    }
}
