//
//  ChatViewController.swift
//  Neo
//
//  Created by Meow on 15/06/2020.
//  Copyright © 2020 Meow. All rights reserved.
//

import UIKit
import Speech
import AVKit

class ChatViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var speechStatusLabel: UILabel!
    @IBOutlet weak var botState: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var timer: Timer?
    var modeOfSpeech: Int = 0

    var messages: [Message] = [Message(sender: "bot", body: "Hi! How are you?")]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        checkSpeechMode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        messageTextField.layer.cornerRadius = messageTextField.frame.size.height / 5
        speechStatusLabel.layer.cornerRadius = speechStatusLabel.frame.size.height / 5
        
        self.setupSpeech()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
        let voice = Speak()
        voice.sayThis(message: messages[0].body)
        
        let botStateImage = UIImage.gif(name: K.BotStates.lookingAround)
        botState.image = botStateImage
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func changeBotStateToLookingAround() {
        let botStateImage = UIImage.gif(name: K.BotStates.lookingAround)
        botState.image = botStateImage
    }
    
    func loadMessages() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func chatBot(message: String) -> Bool {
        let headers = [
            "x-rapidapi-host": "acobot-brainshop-ai-v1.p.rapidapi.com",
            "x-rapidapi-key": "4a2b409e62msh613aae317867bd7p19ba82jsn7952e16aad8a"
        ]
        
        let urlString = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let convertedMessage = urlString {
            let request = NSMutableURLRequest(url: NSURL(string: "https://acobot-brainshop-ai-v1.p.rapidapi.com/get?bid=178&key=sX5A2PcYZbsN5EY6&uid=mashape&msg=" + convertedMessage)! as URL,
                cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print("There was an error getting response")
                } else {
                    let responseData = String(data: data!, encoding: String.Encoding.utf8)
                    if let reply = responseData{
                        if let index = reply.firstIndex(of: ":"){
                            let index = reply.index(index, offsetBy: 2)
                            var str = String(reply[index...])
                            if let index = str.lastIndex(of: "\""){
                                let index = reply.index(index, offsetBy: -1)
                                str = String(str[...index])
                                self.messages.append(Message(sender: "bot", body: str))
                                
                                self.loadMessages()
                                if K.modeOfSpeech != 0 {
                                    let voice = Speak()
                                    voice.sayThis(message: str)
                                }
                                
                            }
                        }
                    }
                }
            })
            
            dataTask.resume()
            return true
        }
        return false
    }
    
    @objc func changeBotStateToDone() {
        let botStateImage = UIImage.gif(name: K.BotStates.done)
        botState.image = botStateImage
    }
    
    @objc func changeBubbleToEmpty() {
        sendButton.setImage(UIImage(systemName: "bubble.left"), for: UIControl.State.normal)
    }
    
    
    func messagePasser(){
        if let messageBody = messageTextField.text {
            if messageBody == "" {
                return
            }
            if messageBody == "Exit" || messageBody == "exit" || messageBody == "Bye" || messageBody == "bye" || messageBody == "Bye Bye" || messageBody == "bye bye" || messageBody == "Bye bye" {
                performSegue(withIdentifier:"exitSegue",sender: self)
            }
            if K.modeOfSpeech == 2 {
                sendButton.setImage(UIImage(systemName: "mic.circle.fill"), for: UIControl.State.normal)
            } else {
                sendButton.setImage(UIImage(systemName: "bubble.left.fill"), for: UIControl.State.normal)
            }
            
            let botStateImage = UIImage.gif(name: K.BotStates.searching)
            botState.image = botStateImage
            
            Timer.scheduledTimer(timeInterval: 3,
            target: self,
            selector: #selector(self.changeBotStateToLookingAround),
            userInfo: nil,
            repeats: false)
            
            messages.append(Message(sender: "user", body: messageBody))
            loadMessages()
            
            if chatBot(message: messageBody) == false {
                messages.append(Message(sender: "bot", body: K.errorMessage))
                loadMessages()
                let voice = Speak()
                voice.sayThis(message: K.errorMessage)
            }
            
            
            Timer.scheduledTimer(timeInterval: 5,
            target: self,
            selector: #selector(self.changeBotStateToDone),
            userInfo: nil,
            repeats: false)
            
            if K.modeOfSpeech == 2 {
                sendButton.setImage(UIImage(systemName: "mic.circle"), for: UIControl.State.normal)
            } else {
                Timer.scheduledTimer(timeInterval: 2,
                target: self,
                selector: #selector(self.changeBubbleToEmpty),
                userInfo: nil,
                repeats: false)
            }
            
            
        }
        messageTextField.text = ""
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if K.modeOfSpeech == 2 {
            startSpeechToText()
        } else {
            messagePasser()
        }
    }
    @IBAction func enterPressed(_ sender: UITextField) {
        messagePasser()
    }
    
    func checkSpeechMode(){
        if K.modeOfSpeech == 2 {
            speechStatusLabel.isHidden = false
            messageTextField.isHidden = true
            sendButton.setImage(UIImage(systemName: "mic.circle"), for: UIControl.State.normal)
        } else {
            speechStatusLabel.isHidden = true
            messageTextField.isHidden = false
            sendButton.setImage(UIImage(systemName: "bubble.left"), for: UIControl.State.normal)
        }
    }
    
    
    //Speech to Text Code
    func startSpeechToText() {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            
            sendButton.setImage(UIImage(systemName: "mic.circle"), for: UIControl.State.normal)
        } else {
            self.startRecording()
            
            let botStateImage = UIImage.gif(name: K.BotStates.searching)
            botState.image = botStateImage
            sendButton.setImage(UIImage(systemName: "mic.circle.fill"), for: UIControl.State.normal)
        }
    }
    
    func setupSpeech() {
        
            SFSpeechRecognizer.requestAuthorization { (authStatus) in

                switch authStatus {
                case .authorized:
                    print("All Good")

                case .denied:
                    let alert = UIAlertController(title: "Permission Denied", message: "You didn't provide the required permission", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                case .restricted:
                    let alert = UIAlertController(title: "Permission Restricted", message: "Speech recognition restricted on this device", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                case .notDetermined:
                    let alert = UIAlertController(title: "Permission Not Determined", message: "Speech recognition not yet authorized", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                @unknown default:
                    let alert = UIAlertController(title: "Unknown Error", message: "Speech Recognition not authorized", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
    }

    
    
        func startRecording() {

            // Clear all previous session data and cancel task
            if recognitionTask != nil {
                recognitionTask?.cancel()
                recognitionTask = nil
            }

            // Create instance of audio session to record voice
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("audioSession properties weren't set because of an error.")
            }

            self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

            let inputNode = audioEngine.inputNode

            guard let recognitionRequest = recognitionRequest else {
                fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            }

            recognitionRequest.shouldReportPartialResults = true

            self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in

                var isFinal = false

                if result != nil {

                    self.speechStatusLabel.text = result?.bestTranscription.formattedString
                    isFinal = (result?.isFinal)!
                    self.speechStatusLabel.textColor = UIColor.black
                }
                
                
                
                if error != nil || isFinal {

                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    if let messageBody = self.speechStatusLabel.text {
                        self.messages.append(Message(sender: "user", body: messageBody))
                        self.loadMessages()
                        if self.chatBot(message: messageBody) == false {
                            self.messages.append(Message(sender: "bot", body: K.errorMessage))
                            self.loadMessages()
                            let voice = Speak()
                            voice.sayThis(message: K.errorMessage)
                        }
                    }

                    self.recognitionRequest = nil
                    self.recognitionTask = nil

                }
            })

            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                self.recognitionRequest?.append(buffer)
            }

            self.audioEngine.prepare()

            do {
                try self.audioEngine.start()
            } catch {
                print("audioEngine couldn't start because of an error.")
            }
            
            placeHolderTextView(listening: true)
            
        }

    func placeHolderTextView(listening: Bool) {
        if listening == true{
            speechStatusLabel.text = K.BotStates.placeWait
        } else {
            speechStatusLabel.text = K.BotStates.placeHolder
        }
        speechStatusLabel.textColor = UIColor.lightGray
    }
    
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        
        if message.sender == "user" {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
    
    
}

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class UITextViewPadding : UITextView {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    textContainerInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
  }
}


