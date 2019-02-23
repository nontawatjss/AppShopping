//
//  AccountCell.swift
//  ShoppingNew
//
//  Created by Nontawat on 18/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var ImgCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
