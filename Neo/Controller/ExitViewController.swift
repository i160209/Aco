//
//  ExitViewController.swift
//  Neo
//
//  Created by Meow on 15/06/2020.
//  Copyright © 2020 Meow. All rights reserved.
//

import UIKit

class ExitViewController: UIViewController {

    @IBOutlet weak var ExitGif: UIImageView!
    @IBOutlet weak var ExitLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let welcomeGifImage = UIImage.gif(name: K.exitGif)
        ExitGif.image = welcomeGifImage
        navigationController?.isNavigationBarHidden = true
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let title = K.exitMessage
        var charIndex = 0.0
        for letter in title{
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex , repeats: false) { (timer) in
                self.ExitLabel.text?.append(letter)
            }
            charIndex += 1
        }
        //Timer.scheduledTimer(withTimeInterval: 3 , repeats: false) { (timer) in
        //    exit(-1)
        //}
        
    }
    
}
