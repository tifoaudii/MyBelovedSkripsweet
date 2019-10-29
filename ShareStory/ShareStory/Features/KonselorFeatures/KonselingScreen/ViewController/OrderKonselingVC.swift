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
        
        self.konselingVM.requestOrders
            .drive(onNext: { [unowned self] orders in
                self.orders = orders
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
