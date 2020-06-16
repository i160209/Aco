//
//  Constants.swift
//  Neo
//
//  Created by Meow on 15/06/2020.
//  Copyright © 2020 Meow. All rights reserved.
//

import Foundation

struct K {
    static let welcomeMessage = "Hello...\nI am\nAco"
    static let exitMessage = "bai bai\n;-;"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let welcomeGif = "welcome"
    static let exitGif = "sad"
    static let errorMessage = "Sorry! I am having a problem. Try again."
    static let fullGif = "full"
    
    static var modeOfSpeech = 1
    
    struct BotStates {
        static let lookingAround = "listening"
        static let searching = "looking"
        static let found = "Found"
        static let done = "done"
        
        static let placeWait = "Say something, I'm listening!"
        static let placeHolder = "Click the mic!"
    }
    
    struct BrandColors {
        static let background = "BackGround"
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
}
