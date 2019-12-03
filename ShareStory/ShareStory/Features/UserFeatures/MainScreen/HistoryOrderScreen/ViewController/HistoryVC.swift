//
//  HistoryVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 30/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class HistoryVC: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    private let listHistoryVM = ListHistoryVM()
    private let disposeBag = DisposeBag()
    private var historyOrders = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableView()
        self.bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        self.listHistoryVM.fetchHistoryOrders()
        
        self.listHistoryVM.historyOrders
            .drive(onNext: { [unowned self] historyOrders in
                self.historyOrders = historyOrders
                self.historyTableView.reloadData()
            }).disposed(by: disposeBag)
        
        self.listHistoryVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func configureTableView() {
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
    }
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyOrder = self.historyOrders[indexPath.row]
        let uid = Auth.auth().currentUser?.uid ?? ""
        let chatRoom = ChatRoom(id: historyOrder.chatRoomId, patientId: uid, konselorId: historyOrder.konselorId, status: ChatRoomStatus.done)
        let historyChatVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "HistoryChatVC") as HistoryChatVC
        historyChatVC.loadChatRoom(chatRoom: chatRoom)
        self.navigationController?.pushViewController(historyChatVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHistoryVM.numberOfHistoryOrders
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "history_cell", for: indexPath) as? HistoryCell else {
            return HistoryCell()
        }
        
        if let viewModel = self.listHistoryVM.viewModelForHistoryAt(index: indexPath.row) {
            cell.setupCell(historyVM: viewModel)
        }
        
        return cell
    }
}
