//
//  ChatVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 22/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift

class ChatVC: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    private var chatRoom: ChatRoom?
    private var messages = [Message]()
    private let chatVM = ChatVM()
    private let disposeBag = DisposeBag()
    private var konselorData: Konselor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableView()
        self.fetchAllMessages()
        self.bindViewModel()
    }
    
    fileprivate func fetchAllMessages() {
        guard let chatRoom = chatRoom else {
            return
        }
        
        self.chatVM.fetchMessages(chatRoom: chatRoom)
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
        
        self.chatVM.isKonselingFinished
            .drive(onNext: { [unowned self] isKonselingFinished in
                if isKonselingFinished {
                    self.onKonselingFinished()
                }
            }).disposed(by: disposeBag)
        
        self.chatVM.konselorData
            .drive(onNext: { [unowned self] konselorData in
                guard let konselorData = konselorData else {
                    return
                }
                
                self.konselorData = konselorData
            }).disposed(by: disposeBag)
    }
    
    fileprivate func configureTableView() {
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTableView.estimatedRowHeight = 90
        self.chatTableView.rowHeight = UITableView.automaticDimension
    }

    @IBAction func sendMessageButtonDidClicked(_ sender: Any) {
        guard let message = messageTextField.text, messageTextField.text != "", let chatRoom = self.chatRoom else {
            return
        }
        
        self.chatVM.sendMessage(content: message, chatRoom: chatRoom)
        self.view.endEditing(true)
    }
    
    @IBAction func endKonselingButtonDidClicked(_ sender: Any) {
        self.showAlertForFinishingKonseling()
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        if message.senderType == .konselor {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatKonselorCell", for: indexPath) as? ChatKonselorCell else {
                return UITableViewCell()
            }
            
            if let viewModel = chatVM.viewModelForMessages(at: indexPath.row) {
                cell.setupCell(messageVM: viewModel)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatPatientCell", for: indexPath) as? ChatPatientCell else {
                return UITableViewCell()
            }
            cell.setupCell(message: message.content)
            return cell
        }
    }
    
    open func loadChatRoom(chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
    }
    
    func showAlertForFinishingKonseling() {
        let alertController = UIAlertController(title: "Mohon Perhatian", message: "Apakah anda ingin mengakhiri sesi konseling?", preferredStyle: .actionSheet)
        
        let finishAction = UIAlertAction(title: "Ya", style: .default) { (_) in
            if let chatRoom = self.chatRoom {
                self.chatVM.finishKonseling(chatRoom: chatRoom)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Batalkan", style: .default, handler: nil)
        alertController.addAction(finishAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func onKonselingFinished() {
        let ratingVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "RatingVC") as RatingVC
        if let konselorData = self.konselorData {
            ratingVC.modalPresentationStyle = .fullScreen
            ratingVC.setKonselor(konselor: konselorData)
            self.present(ratingVC, animated: true, completion: nil)
        }
    }
}
