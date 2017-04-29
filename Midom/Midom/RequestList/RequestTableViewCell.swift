//
//  RequestTableViewCell.swift
//  Midom
//
//  Created by Eugen Druzin on 17/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameStudyLabel: UILabel!
    @IBOutlet weak var specialistLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    public func configure(cellData: RequstCell) {
        nameStudyLabel.text = "Name study \(cellData.studyName))"
        specialistLabel.text = "Study owner: \(cellData.specialistName)"
        dateLabel.text = "Creation date: \(String(cellData.date).description)"
    }
}

struct RequstCell {
//    let avatar: Data
    let studyName: String
    let specialistName: String
    let date: Double
}
