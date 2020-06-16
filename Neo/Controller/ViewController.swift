//
//  ViewController.swift
//  Neo
//
//  Created by Meow on 04/05/2020.
//  Copyright © 2020 Meow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var WelcomeGif: UIImageView!
    @IBOutlet weak var Welcome: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let welcomeGifImage = UIImage.gif(name: K.welcomeGif)
        WelcomeGif.image = welcomeGifImage
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
        let title = K.welcomeMessage
        var charIndex = 0.0
        for letter in title{
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex , repeats: false) { (timer) in
                self.Welcome.text?.append(letter)
            }
            charIndex += 1
        }
        DispatchQueue.main.asyncAfter(deadline:.now() + 3.0, execute: {
           self.performSegue(withIdentifier:"welcomeSegue",sender: self)
        })
            
    }


}

