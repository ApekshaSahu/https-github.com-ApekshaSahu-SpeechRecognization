//
//  FirstViewController.swift
//  SpeechApp
//
//  Created by Apeksha Sahu on 11/24/18.
//  Copyright © 2018 Apeksha Sahu. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
import AudioToolbox
import CoreAudioKit

class FirstViewController: UIViewController, AVAudioPlayerDelegate, SFSpeechRecognizerDelegate {

    @IBOutlet weak var activityButton: UIActivityIndicatorView!
    
    @IBOutlet weak var textViewMy: UITextView!
    
    var audioPlayer: AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
       activityButton.isHidden = true
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        activityButton.stopAnimating()
        activityButton.isHidden = true
        
    }
    func requestSpeechAuth(){
        print("its called")
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                 print("third statement its called")
            
                
                if let path = Bundle.main.url(forResource: "test", withExtension: "m4a") {
                     print("fourth statement its called")
                    do {
                        let sound = try AVAudioPlayer(contentsOf: path)
                        
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        sound.play()
                         print("fifth statement its called")
                    }catch {
                        print("Error!")
                    }
                    
                    let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
                    recognizer?.delegate = self
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    
                    
                  
                   
                    recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                        if let error = error {
                            print(error)
                            print(result?.bestTranscription.formattedString as Any)
                        }else {
                              print("I am in in")
                            self.textViewMy.text =   result?.bestTranscription.formattedString
                            print(result?.bestTranscription.formattedString as Any)
                        }
                    })
                }else {
                    print("not printed")
                }
            }
        }
        print("its was called")
    }
    
   
    @IBAction func playButtonClicked(_ sender: Any) {
        activityButton.isHidden = false
        activityButton.startAnimating()
        requestSpeechAuth()
       
        
    }
    
    
}

