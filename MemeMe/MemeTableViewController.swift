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
    
//    //TODO: Remove the tempMeme1 and tempMeme2
//    let tempMeme1 = Meme(topText: "Big text", bottomText: "Bottom Big", memeImage: UIImage(named: "big")!, sentMemeImage: UIImage(named: "big")!)
//    let tempMeme2 = Meme(topText: "Drax text", bottomText: "Bottom Drax", memeImage: UIImage(named: "drax")!, sentMemeImage: UIImage(named: "drax")!)
//    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeImageCell") as! UITableViewCell
        
        let meme = self.memes?[indexPath.row]
        
        // Set the cell attributes - top & bottom text and the image
        
        cell.textLabel?.text = meme!.topText + "..." + meme!.bottomText
        //cell.topLabelText?.text = meme?.topText
        //cell.bottomLabelText.text = meme?.bottomText
        cell.imageView?.image = meme?.sentMemeImage

        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //TODO: Set the image to sentMeme image.

        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeSentViewerVC") as! MemeSentViewController
        
        //Extract the sentMeme image and display in the detail sentMeme image viewer controller
        detailController.meme = self.memes?[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(Bool())
        
        //Get shared memes object from appdelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        
        
//        //TODO: create temp memes for testing purposes, remove these
//        memes?.append(tempMeme1)
//        memes?.append(tempMeme2)
        
        //If there are no previous memes to show then instantiate the Meme Editor
        if memes!.count == 0 {
            
            openMemeEditor()
            
        }
        
        memeTableView.reloadData()

    
    }
    
    
    
    @IBAction func editMeme(sender: AnyObject) {
        
        openMemeEditor()
        
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func openMemeEditor() {
        
        let object:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC")!
        let memeEditorVC = object as! MemeEditorViewController
        
        //Present the view controller using navigation
        self.navigationController!.pushViewController(memeEditorVC, animated: true)
        
    }
}
