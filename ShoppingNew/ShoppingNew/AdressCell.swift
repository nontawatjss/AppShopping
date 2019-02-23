//
//  AdressCell.swift
//  ShoppingNew
//
//  Created by Nontawat on 4/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class AdressCell: UITableViewCell {

    @IBOutlet weak var TExtAdress: UITextView!
    @IBOutlet weak var BTAddress: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
