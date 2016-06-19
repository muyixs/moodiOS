//
//  MainTableViewCell.swift
//  Mood
//
//  Created by Olumuyiwa Adenaike on 3/6/16.
//  Copyright © 2016 Olumuyiwa Adenaike. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
