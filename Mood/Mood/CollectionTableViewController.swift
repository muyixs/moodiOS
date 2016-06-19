//
//  CollectionTableViewController.swift
//  Mood
//
//  Created by Olumuyiwa Adenaike on 3/7/16.
//  Copyright © 2016 Olumuyiwa Adenaike. All rights reserved.
//

import UIKit
import MediaPlayer

class CollectionTableViewController: UITableViewController , MPMediaPickerControllerDelegate{
    
    var tag:String?
    
    var type:String?
    
    var data:[MPMediaItem]?
    
    var collection:[MPMediaItemCollection]?
    
    var mediaPicker: MPMediaPickerController?
    
    var createdPlaylist:Playlists!
    
    var createdPlaylistName = "Playlist"
    
    var createdPlayListSongs = [MPMediaItem]()
    
    @IBOutlet var table: UITableView!
    
    var listOfCreatedPlaylists:[Playlists]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = tag
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "2ECC71")
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 70
        setUpPlayListArray()
        setUpData()
    }
    func setUpPlayListArray(){
        listOfCreatedPlaylists = []
        let defaults = NSUserDefaults.standardUserDefaults()
        if let testArray = defaults.arrayForKey("createdPlaylists"){
            for (playlist) in testArray{
                let object = NSKeyedUnarchiver.unarchiveObjectWithData(playlist as! NSData) as!Playlists?
                let mainPlaylist:Playlists = object!
                listOfCreatedPlaylists.append(mainPlaylist)
            }
        }
    }
    func setUpData(){
        let query:MPMediaQuery!
        switch(tag!){
        case "Songs":
            query = MPMediaQuery.songsQuery()
            query.groupingType = .Title
//            guard let result = query.items else{return}
//            data = result
        case "Albums":
            query = MPMediaQuery.albumsQuery()
            query.groupingType = .Album
            guard let result = query.collections else{return}
            collection = result
        case "Artists":
            query = MPMediaQuery.artistsQuery()
            query.groupingType = .AlbumArtist
            guard let result = query.collections else{return}
            collection = result
        case  "Playlists":
            query = MPMediaQuery.playlistsQuery()
            query.groupingType = .Playlist
            guard let result = query.collections else{return}
            collection = result
        default:
            query = MPMediaQuery.songsQuery()
        }
        guard let result = query.items else{return}
        data = result
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (tag == "Songs"){
            return (data?.count)!
        }
        else if(tag == "Playlists"){
            return (collection?.count)! + listOfCreatedPlaylists.count
        }
        else if(tag == "Albums"||tag == "Artists"){
            return (collection?.count)!
        }
       
       return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = "basic1"
        if (tag == "Songs"){
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! SongTableViewCell
            if let title = data![indexPath.row].title{
                cell.title.text = title
            }
            if let info = data![indexPath.row].artist{
                cell.artist.text = info
            }
            cell.persistentID = NSNumber(unsignedLongLong:data![indexPath.row].persistentID)
            if let image = data![indexPath.row].artwork?.imageWithSize(cell.artWork.frame.size){
                let r = AVMakeRectWithAspectRatioInsideRect(cell.artWork.frame.size,cell.artWork.frame)
                let im2 = imageOfSize(cell.artWork.frame.size) { image.drawInRect(r) }
                cell.artWork.image = im2
            }
            return cell
        }
        else if (tag == "Albums"){
            identifier = "basic2"
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! CollectionTableViewCell
            let albums = collection![indexPath.row]
            cell.title.text = albums.representativeItem?.valueForProperty( MPMediaItemPropertyAlbumTitle ) as? String
            cell.info.text = albums.representativeItem?.valueForProperty(MPMediaItemPropertyArtist) as? String
            cell.persistentID = NSNumber(unsignedLongLong:collection![indexPath.row].persistentID)
            let image = albums.representativeItem?.valueForProperty(MPMediaItemPropertyArtwork) as?
            MPMediaItemArtwork
            let im = image?.imageWithSize(cell.artWork.frame.size)
            let r = AVMakeRectWithAspectRatioInsideRect(cell.artWork.frame.size,cell.artWork.frame)
            let im2 = imageOfSize(cell.artWork.frame.size) { im!.drawInRect(r) }
            cell.artWork.image = im2
            return cell
        }
        else if (tag == "Artists"){
            identifier = "basic2"
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! CollectionTableViewCell
            let artists = collection![indexPath.row]
           
            cell.title.text = artists.representativeItem?.valueForProperty(MPMediaItemPropertyAlbumArtist) as? String
            cell.info.text = "\(artists.count) song(s)"
            cell.persistentID = NSNumber(unsignedLongLong:collection![indexPath.row].persistentID)
            let image = artists.representativeItem?.valueForProperty(MPMediaItemPropertyArtwork) as?
            MPMediaItemArtwork
            let im = image?.imageWithSize(cell.artWork.frame.size)
            let r = AVMakeRectWithAspectRatioInsideRect(cell.artWork.frame.size,cell.artWork.frame)
            let im2 = imageOfSize(cell.artWork.frame.size) { im!.drawInRect(r) }
            cell.artWork.image = im2
            return cell
        }else{
            if (indexPath.row < collection!.count){
                identifier = "basic2"
                let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! CollectionTableViewCell
                let playlists = collection![indexPath.row]
                cell.title.text = playlists.valueForProperty(MPMediaPlaylistPropertyName) as? String
            
                cell.info.text = "\(playlists.count) song(s)"
                cell.persistentID = NSNumber(unsignedLongLong:collection![indexPath.row].persistentID)
                let image = playlists.representativeItem?.valueForProperty(MPMediaItemPropertyArtwork) as?
                MPMediaItemArtwork
                if let im = image?.imageWithSize(cell.artWork.frame.size){
                    let r = AVMakeRectWithAspectRatioInsideRect(cell.artWork.frame.size,cell.artWork.frame)
                    let im2 = imageOfSize(cell.artWork.frame.size) { im.drawInRect(r) }
                    cell.artWork.image = im2
                }
            return cell
            }else{
                identifier = "basic2"
                let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! CollectionTableViewCell
                let playlist = listOfCreatedPlaylists[indexPath.row - (collection?.count)!]
                cell.title.text = playlist.name
                let query = MPMediaQuery.playlistsQuery()
                let filter =  MPMediaPropertyPredicate(value: playlist.songs, forProperty: MPMediaPlaylistPropertyPersistentID, comparisonType: .EqualTo)
                query.addFilterPredicate(filter)
                cell.info.text = "\(playlist.songs!.count) song(s)"
                cell.songs = playlist.songs!
                cell.persistentID = NSNumber(unsignedLongLong:playlist.songs![0].persistentID)
                let image = playlist.songs![0].artwork
                if let im = image?.imageWithSize(cell.artWork.frame.size){
                    let r = AVMakeRectWithAspectRatioInsideRect(cell.artWork.frame.size,cell.artWork.frame)
                    let im2 = imageOfSize(cell.artWork.frame.size) { im.drawInRect(r) }
                    cell.artWork.image = im2
                }
               return cell
            }
            
        }
        
    }
    
    func imageOfSize(size:CGSize, _ opaque:Bool = false,
        @noescape _ closure:() -> ()) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
            closure()
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue.identifier == "songToPlayer") {
            if let detailViewController = segue.destinationViewController as? PlayerViewController {
                if let cell = sender as? SongTableViewCell {
                    detailViewController.persistentID = cell.persistentID
                    detailViewController.song = cell.title.text!
                    detailViewController.artist = cell.artist.text!
                    detailViewController.title = cell.artist.text!
                    detailViewController.image = cell.artWork.image
                    detailViewController.tag = "song"
                }
            }
        
        } else if (segue.identifier == "collectionToPlayer"){
            if let detailViewController = segue.destinationViewController as? PlayerViewController {
                if let cell = sender as? CollectionTableViewCell {
                    detailViewController.persistentID = cell.persistentID
                    detailViewController.song = cell.title.text!
                    detailViewController.image = cell.artWork.image
                    detailViewController.title = cell.title.text!
                    detailViewController.tag = tag
                    detailViewController.queue = cell.songs // for created playlists
                }
            }
        }
        
    }
    
    
    @IBAction func createPlaylist(sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        let favoriteAction = UIAlertAction(title: "Playlist", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showTextField()
        
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in })
        optionMenu.addAction(favoriteAction)
        optionMenu.addAction(cancelAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)

    }
    func showMediaPicker(){
        
        let mediaPickerController = MPMediaPickerController(mediaTypes: .Music)
        mediaPickerController.delegate = self
        //mediaPickerController.prompt = "Select Audio"
        presentViewController(mediaPickerController, animated: true, completion: nil)
    
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        if mediaItemCollection.items.count > 0{
            for item in mediaItemCollection.items{
                createdPlayListSongs.append(item)
            }
            let play = MPMediaItemCollection(items: createdPlayListSongs)
            print(play.persistentID)
            createdPlaylist = Playlists(name: createdPlaylistName, songs: play.items)
        }
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        createdPlayListSongs = []
        let defaults = NSUserDefaults.standardUserDefaults()
        if let _ = createdPlaylist{
            if var array = defaults.arrayForKey("createdPlaylists"){
                array.append(NSKeyedArchiver.archivedDataWithRootObject(createdPlaylist))
                defaults.setObject(array, forKey: "createdPlaylists")
                defaults.synchronize()
            }else{
                var array1:[NSData] = []
                NSKeyedArchiver.archivedDataWithRootObject(createdPlaylist)
                array1.append(NSKeyedArchiver.archivedDataWithRootObject(createdPlaylist))
                defaults.setObject(array1, forKey: "createdPlaylists")
                defaults.synchronize()
                
            }
            
        }
        setUpPlayListArray()
        self.tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    func showTextField(){
        var inputTextField:UITextField!
        let playlistPrompt = UIAlertController(title: "", message: "Enter the name of the new playlist", preferredStyle: UIAlertControllerStyle.Alert)
        playlistPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        playlistPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if (inputTextField.text?.characters.count > 0){
                self.showMediaPicker()
                self.createdPlaylistName = inputTextField.text!
            }
        }))
        playlistPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Name"
                textField.keyboardType = UIKeyboardType.Alphabet
                textField.autocapitalizationType = .Words
                inputTextField = textField
        })
        self.presentViewController(playlistPrompt, animated: true, completion: nil)

    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//        if (tag == "Artists"||tag == "Playlists"||tag == "Albums"){
//            identifier = "basic2"
//            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! CollectionTableViewCell
//            //if let artist = collection[indexPath.row] as! MPMedia
//            if let title = data![indexPath.row].title{
//                cell.title.text = title
//            }
//            if let info = data![indexPath.row].artist{
//                cell.info.text = info
//            }
//            if let image = data![indexPath.row].artwork?.imageWithSize(cell.artWork.frame.size){
//                let r = AVMakeRectWithAspectRatioInsideRect(cell.artWork.frame.size,cell.artWork.frame)
//                let im2 = imageOfSize(cell.artWork.frame.size) { image.drawInRect(r) }
//                cell.artWork.image = im2
//            }
//        return cell
//
//        }

