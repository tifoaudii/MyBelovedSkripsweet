//
//  HistoryPatientChatVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 14/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HistoryPatientChatVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var chatRoom: ChatRoom?
    private var messages = [Message]()
    private let chatVM = KonselorChatVM()
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableView()
        self.fetchAllMessages()
        self.bindViewModel()
    }
    
    fileprivate func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
    }
    
    fileprivate func fetchAllMessages() {
        guard let chatRoom = chatRoom else {
            return
        }
        
        self.chatVM.fetchAllMessages(chatRoom: chatRoom)
        self.chatVM.observeMessage(chatRoom: chatRoom)
        self.chatVM.observeKonseling(chatRoom: chatRoom)
    }
    
    fileprivate func bindViewModel() {
        self.chatVM.messages
            .drive(onNext: { [unowned self] messages in
                self.messages = messages
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        self.chatVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
    }

}

extension HistoryPatientChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        if message.senderType == .patient {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "KonselorPatientCellIdentifier", for: indexPath) as? PatientKonselorChatCell else {
                return UITableViewCell()
            }
            
            if let viewModel = chatVM.viewModelForMessages(at: indexPath.row) {
                cell.setupCell(messageVM: viewModel)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "KonselorSenderCellIdentifier", for: indexPath) as? SenderKonselorChatCell else {
                return UITableViewCell()
            }
            cell.setupCell(message: message.content)
            return cell
        }
    }
    
    open func loadChatRoom(chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
    }
}
