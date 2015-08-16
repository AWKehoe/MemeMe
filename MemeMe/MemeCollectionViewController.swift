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
        self.tabBarController?.tabBar.hidden = false
        
        //Get shared memes object from appdelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        
        //If there are no previous memes to show then instantiate the Meme Editor
        if memes!.count == 0 {
            let object:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC")!
            let memeEditorVC = object as! MemeEditorViewController
            
            //Present the view controller using navigation
            self.navigationController!.pushViewController(memeEditorVC, animated: true)
        }
        
        memeCollectionView.reloadData()
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
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    @IBAction func editMeme(sender: UIBarButtonItem) {
        
        openMemeEditor()

        
    }
    
    func openMemeEditor() {
        
        let object:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC")!
        let memeEditorVC = object as! MemeEditorViewController
        
        //Present the view controller using navigation
        self.navigationController!.pushViewController(memeEditorVC, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
