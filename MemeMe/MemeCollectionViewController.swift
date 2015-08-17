//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Anthony Kehoe on 11/08/2015.
//  Copyright (c) 2015 Anthony Kehoe. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    var memes: [Meme]?
    
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Get shared memes object from appdelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes?[indexPath.row]
        
        cell.memeImage.image = meme?.sentMemeImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        //TODO: Set the image to sentMeme image.
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeSentViewerVC") as! MemeSentViewController
        
        //Extract the sentMeme image and display in the detail sentMeme image viewer controller
        detailController.meme = self.memes?[indexPath.row]
        
        //Hide the Bottom Tab Bar upon the navigation push
        detailController.hidesBottomBarWhenPushed = true
       
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    ///Open the Meme editor to add new memes
    @IBAction func editMeme(sender: UIBarButtonItem) {
        
        openMemeEditor()

    }

    ///Call the memeEditorVC
    func openMemeEditor() {
        
        let object:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC")!
        let memeEditorVC = object as! MemeEditorViewController
        
        //Present the view controller.
        self.presentViewController(memeEditorVC, animated: true, completion: nil)
        
    }
    
}
