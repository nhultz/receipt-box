//
//  ReceiptCell.swift
//  ReceiptBox
//
//  Created by Nick Hultz on 3/19/18.
//  Copyright © 2018 nhultz. All rights reserved.
//

import UIKit

class ReceiptCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    var item: Receipt? {
        didSet {
            guard let item = item else {
                return
            }

            nameLabel.text = item.name

            if let date = item.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd"
                dateLabel.text = dateFormatter.string(from: date)
            }

            if let amount = item.totalAmount {
                amountLabel.text = String(format: "$%.02f", amount)
            }
        }
    }

    static var identifier: String {
        return "ReceiptCell"
    }
}
