//
//  ProblemsTableViewCell.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 25/04/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit

class ProblemsTableViewCell: UITableViewCell {

    @IBOutlet weak var companyLogo: UIImageView!
    
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var problemSubject: UILabel!
    
    @IBOutlet weak var problemDate: UILabel!
    
    @IBOutlet weak var problemStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
