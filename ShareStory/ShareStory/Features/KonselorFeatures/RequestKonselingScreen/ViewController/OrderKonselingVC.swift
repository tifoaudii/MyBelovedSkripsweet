//
//  KonselingVC.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 26/10/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderKonselingVC: UIViewController {

    @IBOutlet weak var konselingTableView: UITableView!
    
    let emptyLabel: UILabel = {
       let label = UILabel()
        label.text = "Tidak ada permintaan konseling saat ini"
        label.font = UIFont.init(name: "AvenirNext-DemiBold", size: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    private let konselingVM = OrderKonselingVM()
    private let disposeBag = DisposeBag()
    private var orders = [RequestOrder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableView()
        self.bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        self.konselingVM.fetchRequestOrders()
        self.konselingVM.observeRequestOrders()
        
        self.konselingVM.requestOrders
            .drive(onNext: { [unowned self] orders in
                self.orders = orders
                self.configureEmptyLabel()
                self.konselingTableView.reloadData()
            }).disposed(by: disposeBag)
        
        self.konselingVM.hasError
            .drive(onNext: { [unowned self] hasError in
                if hasError {
                    self.showErrorMessage()
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func configureTableView() {
        self.konselingTableView.delegate = self
        self.konselingTableView.dataSource = self
    }
    
    fileprivate func configureEmptyLabel() {
        if orders.isEmpty {
            self.view.addSubview(emptyLabel)
            emptyLabel.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
            emptyLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        } else {
            self.emptyLabel.removeFromSuperview()
        }
    }
}

extension OrderKonselingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return konselingVM.numberOfRequestOrders
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "konseling_cell", for: indexPath) as? KonselingCell else {
            return KonselingCell()
        }
        
        if let viewModel = konselingVM.viewModelForOrder(at: indexPath.row) {
            cell.setupCell(viewModel: viewModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let orderViewModel = konselingVM.viewModelForOrder(at: indexPath.row) else {
            return
        }
        
        let detailOrder = UIStoryboard.init(name: "Konselor", bundle: nil).instantiateViewController(identifier: "DetailOrderVC") as! DetailOrderKonselingVC
        detailOrder.loadOrder(order: orderViewModel)
        self.navigationController?.pushViewController(detailOrder, animated: true)
    }
}
