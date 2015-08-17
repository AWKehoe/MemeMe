//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Anthony Kehoe on 11/08/2015.
//  Copyright (c) 2015 Anthony Kehoe. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var memes: [Meme]?
    
    @IBOutlet weak var memeTableView: UITableView!
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeImageCell") as! UITableViewCell
        
        let meme = self.memes?[indexPath.row]
        
        // Set the cell attributes - top & bottom text and the image
        cell.textLabel?.text = meme!.topText + "..." + meme!.bottomText
        cell.imageView?.image = meme?.sentMemeImage

        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeSentViewerVC") as! MemeSentViewController
        
        //Extract the sentMeme image and display in the detail sentMeme image viewer controller
        detailController.meme = self.memes?[indexPath.row]
        
        //Hide the bottom tab bar when the meme sent viewer is pushed.
        detailController.hidesBottomBarWhenPushed = true
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(Bool())
        
        //Get shared memes object from appdelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    
    
    
    ///Call the meme editor VC to create new memes
    @IBAction func editMeme(sender: AnyObject) {
        
        openMemeEditor()

    }

    //Create new memes
    func openMemeEditor() {
        
        let object:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC")!
        let memeEditorVC = object as! MemeEditorViewController
        
        //Present the view controller.
        self.presentViewController(memeEditorVC, animated: true, completion: nil)
    }
}
    






