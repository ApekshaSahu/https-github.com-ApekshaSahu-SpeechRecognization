//
//  SecondViewController.swift
//  SpeechApp
//
//  Created by Apeksha Sahu on 11/24/18.
//  Copyright © 2018 Apeksha Sahu. All rights reserved.
//

import UIKit
import Speech
import AudioToolbox
import AVFoundation
import AVKit
import CoreAudioKit


class SecondViewController: UIViewController, SFSpeechRecognizerDelegate, AVAudioPlayerDelegate, PortDelegate {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var microButton: UIButton!
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    
    
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    let port = AVAudioSessionPortDescription()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        microButton.isEnabled = false  //2
        
        speechRecognizer!.delegate = self  //3
      
       
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microButton.isEnabled = isButtonEnabled
            }
            func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
                if available {
                    self.microButton.isEnabled = true
                } else {
                    self.microButton.isEnabled = false
                }
        }
    }
        
    }
    
    func startRecording() {
        let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
        speechRecognizer?.delegate = self
        var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
        var recognitionTask: SFSpeechRecognitionTask?
        let audioEngine = AVAudioEngine()
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // try audioSession.setCategory(AVAudioSession.Category.record)
          
         
            try audioSession.setCategory(AVAudioSession.Category.multiRoute, mode: .spokenAudio, options: .defaultToSpeaker)
            print("till here")
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
              print("till here I am")
            try audioSession.setPreferredSampleRate(Double(48000))
               print("till here I am here hello")
            try audioSession.setMode(AVAudioSession.Mode.measurement)
               print("till here I am helloooooooo")
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
               print("till here I am suno suno")
        } catch {
            
            print("audioSession properties weren't set because of an erroraudioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNodes = audioEngine.inputNode as? AVAudioInputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequests = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequests.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequests, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                (inputNodes as AnyObject).removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microButton.isEnabled = true
            }
        })
        
      let recordingFormat = try! inputNodes.outputFormat(forBus: 0)
        inputNodes.installTap(onBus: 0, bufferSize: 10240, format: recordingFormat, block: { (buffer, when)
            in
          self.recognitionRequest?.append(buffer)
        })
       /* let recordingFormat = (inputNodes as AnyObject).outputFormat(forBus: 0)
        (inputNodes as? AVAudioNode)?.installTap(onBus: 0, bufferSize: 10240, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }*/
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = "Say something, I'm listening!"
        
    }


    @IBAction func microPhoneClicked(_ sender: Any) {
        do {
            
         if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
         
            try! audioEngine.inputNode.removeTap(onBus: 0)
            
            recognitionRequest?.endAudio()
            microButton.isEnabled = false
            microButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            microButton.setTitle("Stop Recording", for: .normal)
        }
    }
     catch {
    print("null")
        
    }
    }
}

