//
//  SongTableViewCell.swift
//  Mood
//
//  Created by Olumuyiwa Adenaike on 3/7/16.
//  Copyright © 2016 Olumuyiwa Adenaike. All rights reserved.
//

import UIKit
import MediaPlayer

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var artist: UILabel!
    
    @IBOutlet weak var artWork: UIImageView!
    
    var persistentID:NSNumber!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        artist.adjustsFontSizeToFitWidth = true
        title.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
