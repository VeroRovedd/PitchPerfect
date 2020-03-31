//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by mac on 25/03/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import AVFoundation //Import to have acces to the features including in the AVFoundation classes (audio and video)

//The view controller is responsible to manage the behaviour between the view(what the user sees on screen) and the model (how the data is managed)
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    //a class can only inherit from another superclass, so We are telling that this class is going to act as a delegate of the AVAudioRecorder class (we can use as many protocols as required)
    
    //Its a var that contains an instance of the class AVAudioRecorder and it's gonna be used for record the audio
    var audioRecorder: AVAudioRecorder!
    
    //Outlets are components that wait for an action to be trigered on the viewcontroller and has a response on the view
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    //The function viewDidLoad helps us to control some actions/setup once the view app is loaded in memory, this class is overrided
    override func viewDidLoad() {
        super.viewDidLoad() //Accesing to the method at superclass
        print("viewDidLoad called")
        enableStopButton(false)
    }
    
    //We override the method viewWillAppear that contains code ...
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }
    
    //We override the method viewDidAppear that contains setup once the view was presented to the user
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear called")
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        enableStopButton(true)

        //Create the audio session and tell the AVAudiorecorder to start recording audio (L4.3)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath ?? "No URL assigned")

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        //Adding this line to delegate
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        print("Record stopped")
        enableStopButton(false)
        
        //Stop recording and deactivate the session
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //As we add the class to delegate, we can call functions of that class such as this one that will help us to call the stop recording segue and mome to the next view
    //MARK: AVRecorderAudio delegation
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //This function receives a flag that tell us if the record audio is already finished and saved
        if flag {
            print("finished recording, preparing to the next view")
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func enableStopButton(_ enableButton: Bool) {
        if enableButton {
            recordingLabel.text = "Recording in progress"
            recordingLabel.textColor = UIColor.purple
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        } else {
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
            recordingLabel.text = "Tap to record"
            recordingLabel.textColor = UIColor.black
        }
    }
}

