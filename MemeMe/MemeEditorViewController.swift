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
    
    //TODO: write code for top right Cancel button
    //TODO: write code for share button
    //TODO: setting data source for camera
    
    //Set the default attributes for the top and bottom text fields
    
    let memeTextAttributes = [
        
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0,
        NSKernAttributeName : 2
    ]
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Set the editor formats and states of nav bar and buttons
        prepareEditorFormat()
        
        //Allocate delegates for both text fields to self.
        self.topMemeText.delegate = self
        self.bottomMemeText.delegate = self
        
        //Set the image sources - delegate for imagePicker and check if device camera available. If no camera disable camera button.
        imagePickerController.delegate = self
        memeCameraButtonItem.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
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
            imagePickerController.sourceType = .PhotoLibrary
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            
            
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = pickedImage
            memeSaveButtonItem.enabled = true
           
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
            if let navigationController = self.navigationController {
                navigationController.popToRootViewControllerAnimated(true)
            }
    }
 
    func prepareEditorFormat() {
        
        //Set the top and bottom text to TEXT and text attributes
        topMemeText.text = "TOP"
        bottomMemeText.text  = "BOTTOM"
        
        //Set the default text attributes for top and bottom text fields
        topMemeText.defaultTextAttributes = memeTextAttributes
        bottomMemeText.defaultTextAttributes = memeTextAttributes
        
        //Set text to centre alignment
        topMemeText.textAlignment = .Center
        bottomMemeText.textAlignment = .Center
        
        //Set textField to clear on editing
        topMemeText.clearsOnBeginEditing = true
        bottomMemeText.clearsOnBeginEditing = true
        
        
        //Setup top navigaTion bar
        memeSaveButtonItem.style = UIBarButtonItemStyle.Plain
        
        //Disbale save button to start sharing of unfinished memes
        memeSaveButtonItem.enabled = false
        

    }
    
}

