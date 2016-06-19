//
//  File.swift
//  Mood
//
//  Created by Olumuyiwa Adenaike on 3/6/16.
//  Copyright © 2016 Olumuyiwa Adenaike. All rights reserved.
//

import Foundation
import MediaPlayer

class PlayableItem {
    
    var name:String
    var artWork:String
    var info:String
    
    init(name:String, artWork:String, info:String){
        self.name = name
        self.artWork = artWork
        self.info = info
    }
    
    
}

class Song:PlayableItem{
    
    var artist:String
    
     init(name:String, artWork:String, info:String, artist:String){
        self.artist = artist
        super.init(name: name, artWork: artWork, info: info)
    }
    
}

class Album:PlayableItem{
    
    var artist:String
    var songs:[Song]
    
    init(name:String, artWork:String, info:String, artist:String, songs:[Song]){
        self.artist = artist
        self.songs = songs
        super.init(name: name, artWork: artWork, info: info)
    }
}

class Artist:PlayableItem{
    
    var artist:String
    var songs:[Song]
    var albums:[Album]
    
    init(name:String, artWork:String, info:String, artist:String, songs:[Song],albums:[Album]){
        self.artist = artist
        self.songs = songs
        self.albums = albums
        super.init(name: name, artWork: artWork, info: info)
    }

}
