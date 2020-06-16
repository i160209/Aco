//
//  Speak.swift
//  Neo
//
//  Created by Meow on 15/06/2020.
//  Copyright © 2020 Meow. All rights reserved.
//

import Foundation
import AVFoundation

struct Speak {
    var voiceToUse: AVSpeechSynthesisVoice?
    let voices = AVSpeechSynthesisVoice.speechVoices()
    let voiceSynth = AVSpeechSynthesizer()
    
    init(){
        for voice in voices{
            if voice.name == "Samantha" {
                voiceToUse = voice
            }
        }
    }
    
    func sayThis(message: String){
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = voiceToUse
        utterance.rate = 0.5

        voiceSynth.speak(utterance)
    }
}
