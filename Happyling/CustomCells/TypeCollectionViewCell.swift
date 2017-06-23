//
//  TypeCollectionViewCell.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 22/06/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
