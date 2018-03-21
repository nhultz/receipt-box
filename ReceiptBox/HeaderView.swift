//
//  HeaderView.swift
//  ReceiptBox
//
//  Created by Nick Hultz on 3/21/18.
//  Copyright © 2018 nhultz. All rights reserved.
//

import UIKit


protocol HeaderViewDelegate: class {
    func toggleSection(header: HeaderView, section: Int)
}

class HeaderView: UITableViewHeaderFooterView {

    var group: ReceiptViewModelItem? {
        didSet {
            guard let group = group else {
                return
            }
            titleLabel?.text = group.sectionTitle
            setCollasped(collapsed: group.isCollapsed)
        }
    }

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var arrowButton: UIButton?
    var section: Int = 0

    weak var delegate: HeaderViewDelegate?

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }

    @IBAction func didTapHeader(_ sender: UIButton) {
        delegate?.toggleSection(header: self, section: section)
    }

    func setCollasped(collapsed: Bool) {
        let rotatePi = CGAffineTransform(rotationAngle: CGFloat.pi)
        let rotateNormal = CGAffineTransform.identity

        UIView.animate(withDuration: 0.25) {
            self.arrowButton?.transform = collapsed ? rotatePi : rotateNormal
        }
    }

}
