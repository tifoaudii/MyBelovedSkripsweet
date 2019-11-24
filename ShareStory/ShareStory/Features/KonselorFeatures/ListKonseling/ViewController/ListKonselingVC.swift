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
