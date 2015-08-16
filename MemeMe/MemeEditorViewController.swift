//
//  ViewController.swift
//  MemeEditorController
//
//  Created by Anthony Kehoe on 30/07/2015.
//  Copyright (c) 2015 Anthony Kehoe. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var mImage: UIImage!
    
    var memes: [Meme]?

    @IBOutlet weak var topMemeText: UITextField!
    @IBOutlet weak var bottomMemeText: UITextField!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeNavigationBar: UINavigationBar!
    @IBOutlet weak var memeSaveButtonItem: UIBarButtonItem!
    @IBOutlet weak var memeCancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var memeToolBar: UIToolbar!
    @IBOutlet weak var memeCameraButtonItem: UIBarButtonItem!
    @IBOutlet weak var memeAlbumButtonItem: UIBarButtonItem!
    
    let imagePickerController = UIImagePickerController()

    var textFieldWithFocus: Int?
    var i = 1
    
    //TODO: setting data source for camera
    //TODO: Use firstresponders for field testing
    
    //Create placeholder for text attributes
    var memeTextAttributes: [String: NSObject] = [:]
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        prepareEditorView()
        setTextFieldsBehaviour()
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Subscribe to keyboard notifications
        self.subscribeToKeyboardNotifications()
        
        //Hide the table and collection view buttons
        self.tabBarController?.tabBar.hidden = true
        

    }
    
    override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)
            
        //Unsubscribe from keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
        
        //Enable table and collection view buttons
        self.tabBarController?.tabBar.hidden = false
    }

    func subscribeToKeyboardNotifications() {
                
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
                
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
                
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
        UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)

        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if textFieldWithFocus == 2 {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        //self.view.frame.origin.y += getKeyboardHeight(notification)
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
            
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        textFieldWithFocus = textField.tag
        println("Field tag is \(textFieldWithFocus)")
            return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
            return true
    }

    
    @IBAction func cancelMemeEditor(sender: UIBarButtonItem) {
        
        returntoTabController()
        
    }
    @IBAction func selectImageFromCamera(sender: UIBarButtonItem) {
        
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .Camera
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func selectImageFromAlbum(sender: UIBarButtonItem) {
            
            imagePickerController.allowsEditing = false
            imagePickerController.delegate = self
            imagePickerController.sourceType = .PhotoLibrary
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            
            
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = pickedImage
            memeSaveButtonItem.enabled = true
            self.dismissViewControllerAnimated(true, completion: nil)

           
        }
        
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        mImage = generateMemedImage()
        
        let activityVC = UIActivityViewController(activityItems: [mImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = saveMemeAfterSharing
        
        self.presentViewController(activityVC, animated: true, completion: nil)

        
        }
    
    func generateMemedImage() -> UIImage {
        
       
        memeNavigationBar.hidden = true
        memeToolBar.hidden = true
        
        UIGraphicsBeginImageContext(self.memeImage.frame.size)
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        memeNavigationBar.hidden = false
        memeToolBar.hidden = false

       
        return memedImage
        
    }
    
    func saveMeme() {
            
            var meme = Meme(topText: topMemeText.text, bottomText: bottomMemeText.text, memeImage: memeImage.image!, sentMemeImage: mImage!)
            
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
            
    }
    
    func saveMemeAfterSharing(activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) {
            if completed {
                self.saveMeme()
                self.returntoTabController()
                //self.dismissViewControllerAnimated(true, completion: nil)
        
            }
    }
    
    func returntoTabController() {

        var controller: UITabBarController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
        
        
    }
 
    func prepareEditorView() {
        
        //Set the text attributes for two text fields
        memeTextAttributes = [
            
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0,
            NSKernAttributeName : 2
            
        ]
        
        
        //Set the top and bottom text to TEXT and text attributes
        topMemeText.text = "TOP"
        bottomMemeText.text  = "BOTTOM"
        
        //Set image to nil
        memeImage.image = nil
        
        //Set the default text attributes for top and bottom text fields
        topMemeText.defaultTextAttributes = memeTextAttributes
        bottomMemeText.defaultTextAttributes = memeTextAttributes
        
        //Set text to centre alignment
        topMemeText.textAlignment = .Center
        bottomMemeText.textAlignment = .Center
        
        memeSaveButtonItem.enabled = false

        
        //Set the image sources - delegate for imagePicker and check if device camera available. If no camera disable camera button.
        memeCameraButtonItem.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        

    }
    
    func setTextFieldsBehaviour() {
        
        //Set textField to clear on editing
        topMemeText.clearsOnBeginEditing = true
        bottomMemeText.clearsOnBeginEditing = true
        
        //Allocate delegates for both text fields to self.
        self.topMemeText.delegate = self
        self.bottomMemeText.delegate = self
        
    }
}

