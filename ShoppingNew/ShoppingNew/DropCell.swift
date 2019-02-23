//
//  DropCell.swift
//  ShoppingNew
//
//  Created by Nontawat on 14/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class DropCell: UITableViewCell {

    @IBOutlet weak var ImageCell: UIImageView!
    @IBOutlet weak var NameCell: UILabel!
    
    
    @IBOutlet weak var PriceCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
