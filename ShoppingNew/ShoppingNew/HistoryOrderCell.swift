//
//  HistoryOrderCell.swift
//  ShoppingNew
//
//  Created by Nontawat on 7/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class HistoryOrderCell: UITableViewCell {

    @IBOutlet weak var ImageP: UIImageView!
    
    @IBOutlet weak var NameP: UILabel!
    
    @IBOutlet weak var AmountP: UILabel!
    
    
    @IBOutlet weak var totalPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
