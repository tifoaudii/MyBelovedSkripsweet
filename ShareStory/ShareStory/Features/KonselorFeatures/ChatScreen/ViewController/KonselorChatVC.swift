//
//  ChatVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 31/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class KonselorChatVC: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    private var chatRoom: ChatRoom?
    private var messages = [Message]()
    private let chatVM = KonselorChatVM()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableView()
        self.configureBackButton()
        self.fetchAllMessages()
        self.bindViewModel()
    }
    
    fileprivate func fetchAllMessages() {
        guard let chatRoom = chatRoom else {
            return
        }
        
        self.chatVM.fetchAllMessages(chatRoom: chatRoom)
        self.chatVM.observeMessage(chatRoom: chatRoom)
    }
    
    fileprivate func bindViewModel() {
        self.chatVM.messages
            .drive(onNext: { [unowned self] messages in
                self.messages = messages
                self.messageTextField.text = ""
                self.chatTableView.reloadData()
            }).disposed(by: disposeBag)
        
        self.chatVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func configureTableView() {
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
    }
    
    fileprivate func configureBackButton() {
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    @IBAction func backButtonDidClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendMessageButtonDidClicked(_ sender: Any) {
        guard let message = messageTextField.text, let chatRoom = chatRoom else {
            return
        }
        
        self.chatVM.sendMessage(content: message, chatRoom: chatRoom)
        self.view.endEditing(true)
    }
}

extension KonselorChatVC: UITableViewDelegate, UITableViewDataSource {
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
