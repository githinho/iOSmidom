//
//  AcceptedRequestCollectionViewCell.swift
//  Midom
//
//  Created by Eugen Druzin on 02/05/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

class AcceptedRequestCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImageView: UIImageView!

    func configure(image: UIImage) {
        cellImageView.image = image
    }
}
