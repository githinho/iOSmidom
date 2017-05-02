//
//  AcceptedRequestViewController.swift
//  Midom
//
//  Created by Eugen Druzin on 02/05/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

class AcceptedRequestViewController: UIViewController {

    @IBOutlet weak var studyProviderLabel: UILabel!
    @IBOutlet weak var studyNameLabel: UILabel!
    @IBOutlet weak var commentLable: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!

    private let service: MidomService
    private let crId: Int
    
    init(midomService: MidomService, crId: Int) {
        self.service = midomService
        self.crId = crId
        super.init(nibName: "AcceptedRequestViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
