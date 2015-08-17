//
//  MemeSentViewController.swift
//  MemeMe
//
//  Created by Anthony Kehoe on 12/08/2015.
//  Copyright (c) 2015 Anthony Kehoe. All rights reserved.
//

import UIKit

class MemeSentViewController: UIViewController {

    var meme: Meme?
    
    
    @IBOutlet weak var sentMemeImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        sentMemeImage.image = meme?.sentMemeImage


        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
