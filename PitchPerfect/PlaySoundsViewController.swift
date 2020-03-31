//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by mac on 29/03/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var snailButton: UIButton! //slow button
    @IBOutlet weak var chipmunkButton: UIButton! //high pitch button
    @IBOutlet weak var rabbitButton: UIButton! //fast button
    @IBOutlet weak var vaderButton: UIButton! //low pitch button
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton! //slow button
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    //Vars to use in the extension class
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    //this enum matches the tags we added to the buttons in order to manage the cases on a switch statement at the function
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        print("Play Sound Button Pressed")
        switch(ButtonType(rawValue: sender.tag)!) {
            //this function converts a tag to a button type
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }

        configureUI(.playing)
    }

    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        print("Stop Audio Button Pressed")
        stopAudio()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //We call the method from the extension in order to setup the audio playing
        setupAudio()
        //We desable the stop button before the view appears
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //We configure the UI before the view appears
        configureUI(.notPlaying)
        
    }
    

}
