//
//  PlayerViewController.swift
//  Mood
//
//  Created by Olumuyiwa Adenaike on 3/11/16.
//  Copyright © 2016 Olumuyiwa Adenaike. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerViewController: UIViewController {
    
    

    @IBOutlet weak var artWork: UIImageView!
    
   
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var songInfo: UILabel!
   
    @IBOutlet weak var playOrPauseButton: UIButton!
    
    @IBOutlet weak var volumeView: UIView!
    
    @IBOutlet weak var shuffleLabel: UILabel!
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    
    var persistentID:NSNumber!
    var artist:String!
    var song:String!
    var image:UIImage!
    var tag:String!
    var queue = [MPMediaItem]()
    var timer : NSTimer!
    let swipeRecognizer = UISwipeGestureRecognizer()
    
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "#2ECC71")
        //let myVolumeView:MPVolumeView = MPVolumeView(frame: volumeView.frame)
        //volumeView.addSubview(myVolumeView)
        songName.text = song
        songInfo.text = artist
        songName.adjustsFontSizeToFitWidth = true
        setUpShuffleAndRepeatLabel()
        //artWork.image = image
        setUpVolume()
        if (musicPlayer.playbackState == .Playing){
            playOrPauseButton.imageView?.image = UIImage(named: "Pause Filled")
        }else{
             playOrPauseButton.imageView?.image = UIImage(named: "Play Filled")
        }
        
        if (queue.count > 0){   //play created playlist
            playCreatedPlaylist()
        }else{
            if (tag == "song"){
                playSong()
            }
            else{
                playCollection()
            }
        }
        
        musicPlayer.beginGeneratingPlaybackNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "songChanged", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: musicPlayer)
        
        musicPlayer.beginGeneratingPlaybackNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stateChanged", name: MPMusicPlayerControllerPlaybackStateDidChangeNotification, object: musicPlayer)
        
        //swipeRecognizer.addTarget(self, action: "imageViewSwiped")
        //artWork.addGestureRecognizer(swipeRecognizer)
        artWork.userInteractionEnabled = true
        
    }
    
    override func viewDidLayoutSubviews() {
        let query = MPMediaQuery.songsQuery()
        //setUpVolume()
        switch(tag){
            case "song":
                let isSong = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .EqualTo)
                query.addFilterPredicate(isSong)
                if let im = query.items![0].artwork?.imageWithSize(artWork.frame.size){
                    let r = AVMakeRectWithAspectRatioInsideRect(artWork.frame.size,artWork.frame)
                    let im2 = imageOfSize(artWork.frame.size) { im.drawInRect(r) }
                    artWork.image = im2
            }
            case "Artists":
                let isArtist = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyAlbumArtistPersistentID, comparisonType: .EqualTo)
                query.addFilterPredicate(isArtist)
                let image = query.items![0].artwork
                let im = image?.imageWithSize(artWork.frame.size)
                let r = AVMakeRectWithAspectRatioInsideRect(artWork.frame.size,artWork.frame)
                let im2 = imageOfSize(artWork.frame.size) { im!.drawInRect(r) }
                artWork.image = im2
            default: break
            
        }
    
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        musicPlayer.skipToNextItem()
    }
    
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        musicPlayer.skipToPreviousItem()
    }
  
    func setUpShuffleAndRepeatLabel(){
        let repeatMode = musicPlayer.repeatMode
        if (repeatMode == .None){
            repeatLabel.text = "Off"
        }
        else if (repeatMode == .All){
            repeatLabel.text = "All"
        }
        else if (repeatMode == .One){
            repeatLabel.text = "One"
        }else{
            repeatLabel.text = "Off"
        }
        let shuffleMode = musicPlayer.shuffleMode
        if (shuffleMode == .Off){
            shuffleLabel.text = "Off"
        }
        else if (shuffleMode == .Songs){
            shuffleLabel.text = "Songs"
        }
        else{
            shuffleLabel.text = "Off"
        }

        
    }
    
    func playCreatedPlaylist(){
        
        let songQueue = MPMediaItemCollection(items: queue)
        musicPlayer.setQueueWithItemCollection(songQueue)
        musicPlayer.stop()
        let repeatMode = musicPlayer.repeatMode
        musicPlayer.shuffleMode = .Off
        musicPlayer.beginGeneratingPlaybackNotifications()
        musicPlayer.play()
        musicPlayer.repeatMode = repeatMode
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "fireTimer", userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
        
    }
    
    func playSong(){
        let query = MPMediaQuery.songsQuery()
        let isSong = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .EqualTo)
        query.addFilterPredicate(isSong) // get song with persistent id
        let queue = MPMediaItemCollection(items: query.items!)
        var newQueue = [MPMediaItem]()
        for item in queue.items{
            newQueue.append(item) // add song to player queue
        }
        //query.addFilterPredicate(isSong)
        let songs = query.items
        let albumTitle = songs![0].albumTitle  // get song albumtitle
        let albumQuery = MPMediaQuery.albumsQuery()
        let a = MPMediaPropertyPredicate(value: albumTitle, forProperty: MPMediaItemPropertyAlbumTitle, comparisonType: .Contains)
        albumQuery.addFilterPredicate(a) // get album with song's albumtitle
        for songs in albumQuery.collections![0].items{
            if(songs.title != song){ // add all songs in album to queue except song
                newQueue.append(songs)
            }
        }
        for item in newQueue{
            print(item.title)
        }
        
        let songQueue = MPMediaItemCollection(items: newQueue)
        musicPlayer.setQueueWithItemCollection(songQueue)
        musicPlayer.stop()
        let repeatMode = musicPlayer.repeatMode
        musicPlayer.shuffleMode = .Off
        musicPlayer.beginGeneratingPlaybackNotifications()
        musicPlayer.play()
        musicPlayer.repeatMode = repeatMode
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "fireTimer", userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
        
        
    }
    
    func playCollection(){
        let query = MPMediaQuery.songsQuery()
        switch tag{
            case "Albums":
                let isAlbum = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .EqualTo)
                query.addFilterPredicate(isAlbum)
            case "Artists":
                let isArtist = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyAlbumArtistPersistentID, comparisonType: .EqualTo)
                query.addFilterPredicate(isArtist)
            case "Playlists":
                let isPlaylist = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaPlaylistPropertyPersistentID, comparisonType: .EqualTo)
                query.addFilterPredicate(isPlaylist)
            
        default:
            break
        }
//        let isSong = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .EqualTo)
//        query.addFilterPredicate(isSong) // get song with persistent id
        let queue = MPMediaItemCollection(items: query.items!)
        var newQueue = [MPMediaItem]()
        for item in queue.items{
            newQueue.append(item) // add song to player queue
        }
        let songQueue = MPMediaItemCollection(items: newQueue)
        musicPlayer.setQueueWithItemCollection(songQueue)
        musicPlayer.stop()
        let repeatMode = musicPlayer.repeatMode
        musicPlayer.shuffleMode = .Off
        musicPlayer.beginGeneratingPlaybackNotifications()
        musicPlayer.play()
        musicPlayer.repeatMode = repeatMode
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "fireTimer", userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
    }
    
   
    
    @IBAction func pauseOrPlay(sender: AnyObject) {
        
        if(musicPlayer.playbackState == .Playing){
            musicPlayer.pause()
        }
        else{
            musicPlayer.play()
        }
    }
    
    @IBAction func next(sender: AnyObject) {
        musicPlayer.skipToNextItem()
        
    }
    
    
    @IBAction func previous(sender: AnyObject) {
        musicPlayer.skipToPreviousItem()
    }
    
    
    @IBAction func repeatSong(sender: AnyObject) {
        let repeatMode = musicPlayer.repeatMode
        if (repeatMode == .None){
            musicPlayer.repeatMode = .All
            repeatLabel.text = "All"
            
        }
        else if (repeatMode == .All){
            musicPlayer.repeatMode = .One
            repeatLabel.text = "One"
        }
        else if (repeatMode == .One){
            musicPlayer.repeatMode = .All
            repeatLabel.text = "Off"
        }
    
    }
    
    @IBAction func shuffleSong(sender: AnyObject) {
        
        let shuffleMode = musicPlayer.shuffleMode
        if (shuffleMode == .Off){
            musicPlayer.shuffleMode = .Songs
            shuffleLabel.text = "Songs"
        }
        else if (shuffleMode == .Songs){
            musicPlayer.shuffleMode = .Off
            shuffleLabel.text = "Off"
        }
    }
    
    
    
    func songChanged(){
        defer {
            self.timer?.fire()
        }
        songName.text = musicPlayer.nowPlayingItem?.title
        if let im = musicPlayer.nowPlayingItem?.artwork?.imageWithSize(artWork.frame.size){
            let r = AVMakeRectWithAspectRatioInsideRect(artWork.frame.size,artWork.frame)
            let im2 = imageOfSize(artWork.frame.size) { im.drawInRect(r) }
            artWork.image = im2
        }
        songInfo.text = musicPlayer.nowPlayingItem?.artist
    }
    
    func stateChanged(){
        let currentState = musicPlayer.playbackState
        
        if (currentState == .Playing){
            playOrPauseButton.imageView?.image = UIImage(named: "Pause Filled")
        }
        else if (currentState == .Paused){
            playOrPauseButton.imageView?.image = UIImage(named: "Play Filled")
            
       }
//        else if (currentState == .Stopped){
//            playOrPauseButton.imageView?.image = UIImage(named: "Play Filled")
//            musicPlayer.stop()
//        }
        
    }
    func fireTimer() {
        guard let item = musicPlayer.nowPlayingItem where musicPlayer.playbackState != .Stopped else {
            self.progressView.hidden = true
            return
        } //
        self.progressView.hidden = false
        let current = musicPlayer.currentPlaybackTime
        let total = item.playbackDuration
        self.progressView.progress = Float(current / total)
    }
    
    
    
    func setUpVolume(){
        let myVolumeView:MPVolumeView = MPVolumeView(frame: volumeView.bounds)
        print(volumeView.frame)
        let size = CGSizeMake(20,20)
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(size.height,size.height), false, 0)
        UIColor(hexString: "#2ECC71" ).setFill()
        UIBezierPath(ovalInRect:
            CGRectMake(0,0,size.height,size.height)).fill()
        let draw1 = UIGraphicsGetImageFromCurrentImageContext()
        //UIColor.redColor().setFill()
        UIBezierPath(ovalInRect:
            CGRectMake(0,0,size.height,size.height)).fill()
        let draw2 = UIGraphicsGetImageFromCurrentImageContext()
        UIColor.orangeColor().setFill()
        UIBezierPath(ovalInRect:
            CGRectMake(0,0,size.height,size.height)).fill()
        UIGraphicsEndImageContext()
        
        myVolumeView.setMinimumVolumeSliderImage(
            draw1.resizableImageWithCapInsets(UIEdgeInsetsMake(9,9,9,9),
                resizingMode:.Stretch),
            forState:.Normal)
        myVolumeView.setMaximumVolumeSliderImage(
            draw2.resizableImageWithCapInsets(UIEdgeInsetsMake(9,9,9,9),
                resizingMode:.Stretch),
            forState:.Normal)
        self.volumeView.addSubview(myVolumeView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageOfSize(size:CGSize, _ opaque:Bool = false,
        @noescape _ closure:() -> ()) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
            closure()
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
