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
        nameStudyLabel.text = "Name study \(cellData.studyName)"
        specialistLabel.text = "Study owner: \(cellData.specialistName)"
        dateLabel.text = "Creation date: \(Utils.getDateFromDouble(date: cellData.date))"
        if let image = cellData.avatar {
            avatar.image = image
        } else {
            avatar.image = UIImage(named: "anonymous_avatar")
        }
    }
}

struct RequstCell {
    let studyName: String
    let specialistName: String
    let date: UInt64
    let avatar: UIImage?
}
