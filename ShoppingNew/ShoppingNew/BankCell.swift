//
//  BankCell.swift
//  ShoppingNew
//
//  Created by Nontawat on 27/1/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class BankCell: UITableViewCell {

    @IBOutlet weak var ImageBank: UIImageView!
    @IBOutlet weak var ImageSelect: UIImageView!
    @IBOutlet weak var BankType: UILabel!
    @IBOutlet weak var NameBank: UILabel!
    @IBOutlet weak var BankId: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
