//
//  CollectionTableViewCell.swift
//  Mood
//
//  Created by Olumuyiwa Adenaike on 3/7/16.
//  Copyright © 2016 Olumuyiwa Adenaike. All rights reserved.
//

import UIKit
import MediaPlayer

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var info: UILabel!
    
    @IBOutlet weak var artWork: UIImageView!
    
    var persistentID:NSNumber!
    
    var songs = [MPMediaItem]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title.adjustsFontSizeToFitWidth = true
        info.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.title.preferredMaxLayoutWidth = self.title.frame.size.width
        self.info.preferredMaxLayoutWidth = self.info.frame.size.width
    }


}
