//
//  Playlists.swift
//  Mood
//
//  Created by Olumuyiwa Adenaike on 3/13/16.
//  Copyright © 2016 Olumuyiwa Adenaike. All rights reserved.
//

import Foundation
import MediaPlayer

class Playlists: NSObject, NSCoding{
    var name:String?
    var songs:[MPMediaItem]?
    init(name:String, songs:[MPMediaItem]){
        self.songs = songs
        self.name = name
        
    }
    override init(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let name = aDecoder.decodeObjectForKey("name") as? String {
            self.name = name
        }
        if let songs = aDecoder.decodeObjectForKey("songs") as? [MPMediaItem] {
            self.songs = songs
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        if let name = self.name {
            aCoder.encodeObject(name, forKey: "name")
        }
        
        if let songs = self.songs {
            aCoder.encodeObject(songs,forKey: "songs")
        }
        
        
    }
    
}
