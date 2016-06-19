//
//  MainTableViewController.swift
//  Mood
//
//  Created by Olumuyiwa Adenaike on 3/6/16.
//  Copyright © 2016 Olumuyiwa Adenaike. All rights reserved.
//

import UIKit
import MediaPlayer

class MainTableViewController: UITableViewController {
    
    
    var recentlyPlayed:[MPMediaItem]!
    let mainArray = ["Playlists","Songs","Albums","Artists"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 70
        let query = MPMediaQuery.playlistsQuery()
        let isPlaylist = MPMediaPropertyPredicate(value: "Recently Played", forProperty: MPMediaPlaylistPropertyName, comparisonType: .EqualTo)
        query.addFilterPredicate(isPlaylist)
        recentlyPlayed = query.items
        //self.navigationController?.navigationBar.barTintColor = UIColor(hexString:"#00000")
        //self.navigationController?.navigationBar.titleTextAttributes =[NSForegroundColorAttributeName: UIColor(hexString: "#2ECC71")]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0){
            return mainArray.count
        }
        return recentlyPlayed.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var identifier = "recent"
        if (indexPath.section == 0){
            identifier = "main"
             let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! MainTableViewCell
            cell.title.text = mainArray[indexPath.row]
            cell.icon.image = UIImage(named: mainArray[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! RecentTableViewCell
        
        if (recentlyPlayed!.count > 0){
            cell.persistentID = NSNumber(unsignedLongLong: recentlyPlayed[indexPath.row].persistentID)
            cell.name.text = recentlyPlayed![indexPath.row].title!
            cell.info.text = recentlyPlayed![indexPath.row].artist!
            if let image = recentlyPlayed![indexPath.row].artwork?.imageWithSize(cell.artWork.frame.size){
                let r = AVMakeRectWithAspectRatioInsideRect(cell.artWork.frame.size,cell.artWork.frame)
                let im2 = imageOfSize(cell.artWork.frame.size) { image.drawInRect(r) }
                cell.artWork.image = im2
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 1){
            return 70
        }
        return 50
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
        let backItem = UIBarButtonItem()
        backItem.tintColor = UIColor.whiteColor()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if (segue.identifier == "recentToPlayer"){
            if let detailViewController = segue.destinationViewController as? PlayerViewController{
                if let cell = sender as? RecentTableViewCell {
                    detailViewController.persistentID = cell.persistentID
                    detailViewController.song = cell.name.text
                    detailViewController.image = cell.artWork.image
                    detailViewController.title = cell.name.text!
                    detailViewController.tag = "song"
                }
            }
            
        }else{
            if let detailViewController = segue.destinationViewController as? CollectionTableViewController {
                if let cell = sender as? MainTableViewCell {
                    detailViewController.tag = cell.title.text
                }
            }
        }
        
        
    }

    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var returnedView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 25))
        if section == 1{
            returnedView.backgroundColor = UIColor.blackColor()
            returnedView.opaque = true
            let label = UILabel(frame: CGRectMake(20,10, self.view.frame.width,15))
            label.font.fontWithSize(5)
            label.textColor = UIColor(hexString: "#2ECC71")
            label.text = "RECENTLY PLAYED"
            returnedView.addSubview(label)
        }else{
            returnedView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 0.2))
            returnedView.backgroundColor = UIColor.whiteColor()
        }
        return returnedView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height:CGFloat = 1
        if section == 1{
            height = 25
            return height
        }
        return height
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

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}