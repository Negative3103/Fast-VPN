//
//  TariffsDataProvider.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 13/08/24.
//

import UIKit

final class TariffsDataProvider: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    //MARK: - Attributes
    weak var viewController: UIViewController?
    internal var items = [TariffModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Lifecycles
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    //MARK: - Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewController = viewController as? TariffsViewController else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TariffsTableViewCell.defaultReuseIdentifier, for: indexPath) as? TariffsTableViewCell else { return UITableViewCell() }
//        cell.item = items[indexPath.row]
//        cell.didSelect = viewController.selectedTariff?.id == items[indexPath.row].id
//        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = viewController as? TariffsViewController else { return }
        viewController.selectedTariff = items[indexPath.row]
    }
}
