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
    
    let emptyLabel: UILabel = {
       let label = UILabel()
        label.text = "Tidak ada sesi konseling saat ini"
        label.font = UIFont.init(name: "AvenirNext-DemiBold", size: 18)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    private let listKonselingVM = ListKonselingVM()
    private let disposeBag = DisposeBag()
    private var acceptedOrders = [AcceptedOrder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableView()
        self.bindViewModel()
    }

    fileprivate func bindViewModel() {
        self.listKonselingVM.fetchAllAcceptedOrder()
        self.listKonselingVM.observeNewPatient()
        
        self.listKonselingVM.acceptedOrder
            .drive(onNext: { [unowned self] acceptedOrders in
                self.acceptedOrders = acceptedOrders
                self.configureEmptyLabel()
                self.listKonselingTableView.reloadData()
            }).disposed(by: disposeBag)
        
        self.listKonselingVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func configureTableView() {
        self.listKonselingTableView.delegate = self
        self.listKonselingTableView.dataSource = self
        self.listKonselingTableView.tableFooterView = UIView()
    }
    
    fileprivate func configureEmptyLabel() {
        if acceptedOrders.isEmpty {
            self.view.addSubview(emptyLabel)
            emptyLabel.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
            emptyLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        } else {
            self.emptyLabel.removeFromSuperview()
        }
    }
}

extension ListKonselingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listKonselingVM.numberOfAcceptedOrder
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let acceptedOrder = self.acceptedOrders[indexPath.row]
        let chatVC = UIStoryboard.init(name: "Konselor", bundle: nil).instantiateViewController(identifier: "ChatVC") as KonselorChatVC
        chatVC.loadChatRoom(chatRoom: acceptedOrder.chatRoom)
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListKonselingCell", for: indexPath) as? ListKonselingCell else {
            return ListKonselingCell()
        }
        
        if let viewModel = self.listKonselingVM.viewModelForPatientAt(index: indexPath.row) {
            cell.setupCell(konselingVM: viewModel)
        }
        
        return cell
    }
}
