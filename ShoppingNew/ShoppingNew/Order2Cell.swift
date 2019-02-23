//
//  Order2Cell.swift
//  ShoppingNew
//
//  Created by Nontawat on 3/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class Order2Cell: UITableViewCell {

    @IBOutlet weak var NameP: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    
    @IBOutlet weak var AmountP: UILabel!
    @IBOutlet weak var SumP: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
