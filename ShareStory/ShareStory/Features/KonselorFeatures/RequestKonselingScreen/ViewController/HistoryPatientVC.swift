//
//  HistoryPatientVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 11/12/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class HistoryPatientVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var patientName = ""
    private var patientId = ""
    private var history = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableView()
        self.bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        DataService.shared.getHistoryKonseling(patient: patientId, completion: { (history) in
            self.history = history
            self.tableView.reloadData()
        }) {
            self.showErrorMessage()
        }
    }
    
    fileprivate func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
    }
}

extension HistoryPatientVC: UITableViewDelegate, UITableViewDataSource {
    
    func setPatientName(name: String, id: String) {
        self.patientName = name
        self.patientId = id
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyOrder = self.history[indexPath.row]
        let uid = Auth.auth().currentUser?.uid ?? ""
        let chatRoom = ChatRoom(id: historyOrder.chatRoomId, patientId: self.patientId, konselorId: uid, status: ChatRoomStatus.done)
        let historyChatVC = UIStoryboard.init(name: "Konselor", bundle: nil).instantiateViewController(identifier: "HistoryPatientChatVC") as HistoryPatientChatVC
        historyChatVC.loadChatRoom(chatRoom: chatRoom)
        self.navigationController?.pushViewController(historyChatVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KonselorHistoryCell", for: indexPath) as? KonselorHistoryCell else {
            return UITableViewCell()
        }
        cell.setupCell(patientName: self.patientName, time: convertDate(date: history[indexPath.row].date))
        return cell
    }
    
    func convertDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        return result
    }
}
