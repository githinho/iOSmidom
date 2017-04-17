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
    
    public func configure(request: ConsultationRequest) {
        nameStudyLabel.text = "Name study \(String(describing: request.studyObj?.name))"
        specialistLabel.text = "Study owner: \(String(describing: request.studyObj?.ownerObj?.getFullName()))"
        dateLabel.text = "Creation date: \(String(describing: request.creationTime))"
    }
}
