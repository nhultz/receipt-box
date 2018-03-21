//
//  Receipt.swift
//  ReceiptBox
//
//  Created by Nick Hultz on 3/18/18.
//  Copyright © 2018 nhultz. All rights reserved.
//

import Foundation

class Receipt {
    var name: String?
    var date: Date?
    var totalAmount: Double?

    init(name: String, date: Date, totalAmount: Double) {
        self.name = name
        self.date = date
        self.totalAmount = totalAmount
    }
}
