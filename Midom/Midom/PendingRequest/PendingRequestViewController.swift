//
//  PendingRequestViewController.swift
//  Midom
//
//  Created by Eugen Druzin on 30/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

class PendingRequestViewController: UIViewController {

    @IBOutlet weak var nameStudyLabel: UILabel!
    @IBOutlet weak var specialistLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    private let service: MidomService
    private let crId: Int

    init(midomService: MidomService, crId: Int) {
        self.service = midomService
        self.crId = crId
        super.init(nibName: "PendingRequestViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func acceptButtonClicked(_ sender: UIButton) {
    }

    @IBAction func rejectButtonClicked(_ sender: UIButton) {
    }
}
