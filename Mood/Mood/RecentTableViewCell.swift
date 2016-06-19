//
//  RecentTableViewCell.swift
//  Mood
//
//  Created by Olumuyiwa Adenaike on 3/6/16.
//  Copyright © 2016 Olumuyiwa Adenaike. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    @IBOutlet weak var artWork: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var info: UILabel!
    
    var persistentID:NSNumber!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
