//
//  SettingsViewController.swift
//  Neo
//
//  Created by Meow on 15/06/2020.
//  Copyright © 2020 Meow. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsGif: UIImageView!
    @IBOutlet weak var chatModeButton: UIButton!
    let check = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settingsGifImage = UIImage.gif(name: K.fullGif)
        settingsGif.image = settingsGifImage
        chatModeButton.layer.cornerRadius = chatModeButton.frame.size.height / 5
        
    }
    
    
    @IBAction func chatMode(_ sender: UIButton) {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let firstAction: UIAlertAction = UIAlertAction(title: "Chat Only", style: .default) { action -> Void in
            K.modeOfSpeech = 0
        }
        let secondAction: UIAlertAction = UIAlertAction(title: "Only Aco talks", style: .default) { action -> Void in
            K.modeOfSpeech = 1
        }
        let thirdAction: UIAlertAction = UIAlertAction(title: "Both Aco and you will talk using voice", style: .default) { action -> Void in
            K.modeOfSpeech = 2
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(thirdAction)
        actionSheetController.addAction(cancelAction)

        present(actionSheetController, animated: true) {
            
        }
    }
    

}
