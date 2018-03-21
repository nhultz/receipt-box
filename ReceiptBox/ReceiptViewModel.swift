//
//  ReceiptViewModel.swift
//  ReceiptBox
//
//  Created by Nick Hultz on 3/18/18.
//  Copyright © 2018 nhultz. All rights reserved.
//

import Foundation
import UIKit

protocol ReceiptViewModelItem {
    var sectionTitle: String { get }
    var rowCount: Int { get }
    var isCollapsed: Bool { get set }
}

class ReceiptViewModel: NSObject {
    var monthGroups = [ReceiptViewModelItem]()

    var reloadSections: ((_ section: Int) -> Void)?

    override init() {
        super.init()

        let receipts = [
            Receipt(name: "Starbucks", date: Date(), totalAmount: 15.32),
            Receipt(name: "Dunkin Donuts", date: Date(), totalAmount: 5.50),
            Receipt(name: "Wegmans", date: Date(), totalAmount: 102.45),
            Receipt(name: "Starbucks", date: Date(), totalAmount: 10.15)
        ]

        monthGroups.append(MonthGroupItem(month: "January 2018", receipts: receipts))
        monthGroups.append(MonthGroupItem(month: "February 2018", receipts: receipts))
        monthGroups.append(MonthGroupItem(month: "March 2018", receipts: receipts))
    }

}

extension ReceiptViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return monthGroups.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = monthGroups[section]

        if group.isCollapsed {
            return 0
        } else {
            return group.rowCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let month = monthGroups[indexPath.section] as? MonthGroupItem {
            let receipt = month.receipts[indexPath.row]

            if let cell = tableView.dequeueReusableCell(withIdentifier: ReceiptCell.identifier, for: indexPath) as? ReceiptCell {
                cell.item = receipt
                return cell
            }
        }

        return UITableViewCell()
    }
}

extension ReceiptViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView {
            headerView.group = monthGroups[section]
            headerView.section = section
            headerView.delegate = self
            return headerView
        }
        return UIView()
    }
}

extension ReceiptViewModel: HeaderViewDelegate {
    func toggleSection(header: HeaderView, section: Int) {
        var group = monthGroups[section]

        let collapsed = !group.isCollapsed
        group.isCollapsed = collapsed
        header.setCollasped(collapsed: collapsed)

        // Adjust the number of the rows inside the section
        reloadSections?(section)
    }
}

class MonthGroupItem: ReceiptViewModelItem {
    var isCollapsed = false

    var sectionTitle: String {
        return month
    }

    var rowCount: Int {
        return receipts.count
    }

    var month: String
    var receipts: [Receipt]

    init(month: String, receipts: [Receipt]) {
        self.month = month
        self.receipts = receipts
    }
}
