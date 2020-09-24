//
//  ViewController.swift
//  Mixer
//
//  Created by Julian Silvestri on 2020-06-14.
//  Copyright © 2020 Julian Silvestri. All rights reserved.
//

import UIKit
import Foundation
import Accelerate
import AVFoundation
import MetalKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleOfApp: UILabel!
    //MARK: Track One View
    @IBOutlet weak var trackOneView: UIView!
    @IBOutlet weak var trackOnePlayBtn: UIButton!
    @IBOutlet weak var trackOnePauseBtn: UIButton!
    @IBOutlet weak var trackOneStopBtn: UIButton!
    @IBOutlet weak var trackOneRestartTrackBtn: UIButton!
    @IBOutlet weak var trackOneChangeTrackBtn: UIButton!
    @IBOutlet weak var trackOneDurationLabel: UILabel!
    @IBOutlet weak var trackOneTitle: UILabel!
    @IBOutlet weak var trackOneVolume: UILabel!
    @IBOutlet weak var trackOneVolumeControl: UISlider!
    //MARK: Track Two View
    @IBOutlet weak var trackTwoView: UIView!
    @IBOutlet weak var trackTwoRestartBtn: UIButton!
    @IBOutlet weak var trackTwoChangeTrackBtn: UIButton!
    @IBOutlet weak var trackTwoTitle: UILabel!
    @IBOutlet weak var trackTwoDurationLabel: UILabel!
    @IBOutlet weak var trackTwoVolumeControl: UISlider!
    @IBOutlet weak var trackTwoVolume: UILabel!
    @IBOutlet weak var trackTwoPlayBtn: UIButton!
    @IBOutlet weak var trackTwoPauseBtn: UIButton!
    @IBOutlet weak var trackTwoStopBtn: UIButton!
   
    var audioPlayerOne: MusicPlayerOne?
    var audioPlayerTwo: MusicPlayerTwo?
    var trackOneTimer = Timer()
    var trackTwoTimer = Timer()
    var trackOneTime_Double = Double()
    var trackTwoTime_Double = Double()
    
    var engine : AVAudioEngine!
    var audioVisualizer : AudioVisualizer!
    let fftSetup = vDSP_DFT_zop_CreateSetup(nil, 1024, vDSP_DFT_Direction.FORWARD)
    var prevRMSValue : Float = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioVisualizer = AudioVisualizer()
        //audioVisualizer.frame = CGRect(x:0,y:0,width:200, height: 100)
        view.addSubview(audioVisualizer)
        
        //constraining to window
        audioVisualizer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        audioVisualizer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        audioVisualizer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        audioVisualizer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        audioVisualizer.heightAnchor.constraint(equalToConstant: 200).isActive = true
        setupAudio()
        
        self.trackOneView.layer.cornerRadius = 10
        self.trackTwoView.layer.cornerRadius = 10
        
        self.trackOneTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(trackOneTime), userInfo: nil, repeats: true)
        self.trackTwoTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(trackTwoTime), userInfo: nil, repeats: true)
        
        self.audioPlayerOne = MusicPlayerOne()
        self.audioPlayerTwo = MusicPlayerTwo()
        self.titleOfApp.textColor = UIColor.white
        
        //set titles of songs
        self.trackOneTitle.text = self.audioPlayerOne?.trackOne
        self.trackTwoTitle.text = self.audioPlayerTwo?.trackTwo
        
        //corner radius - palyer 1
        self.trackOnePlayBtn.layer.cornerRadius = 5
        self.trackOneStopBtn.layer.cornerRadius = 5
        self.trackOneRestartTrackBtn.layer.cornerRadius = 5
        self.trackOnePauseBtn.layer.cornerRadius = 5
        self.trackOneChangeTrackBtn.layer.cornerRadius = 5
        //corner radius - player 2
        self.trackTwoPlayBtn.layer.cornerRadius = 5
        self.trackTwoStopBtn.layer.cornerRadius = 5
        self.trackTwoPauseBtn.layer.cornerRadius = 5
        self.trackTwoRestartBtn.layer.cornerRadius = 5
        self.trackTwoChangeTrackBtn.layer.cornerRadius = 5
        
        self.trackOneVolume.text = "\(self.trackOneVolumeControl.value.rounded())"
        self.trackTwoVolume.text = "\(self.trackTwoVolumeControl.value.rounded())"
        
        self.view.backgroundColor = UIColor.black
        
        if traitCollection.userInterfaceStyle == .light {
            print("Light mode")
            //player 1
            self.trackOneView.backgroundColor = UIColor.black
            self.trackOnePlayBtn.backgroundColor = UIColor.systemGreen
            self.trackOneStopBtn.backgroundColor = UIColor.systemRed
            self.trackOnePauseBtn.backgroundColor = UIColor.gray
            self.trackOneRestartTrackBtn.backgroundColor = UIColor.systemOrange
            self.trackOneChangeTrackBtn.backgroundColor = UIColor.systemTeal
            self.trackOneTitle.textColor = UIColor.white
            self.trackOneVolume.textColor = UIColor.white
            //player 2
            self.trackTwoView.backgroundColor = UIColor.black
            self.trackTwoPlayBtn.backgroundColor = UIColor.systemGreen
            self.trackTwoPauseBtn.backgroundColor = UIColor.gray
            self.trackTwoStopBtn.backgroundColor = UIColor.systemRed
            self.trackTwoRestartBtn.backgroundColor = UIColor.systemOrange
            self.trackTwoChangeTrackBtn.backgroundColor = UIColor.systemTeal
            self.trackTwoTitle.textColor = UIColor.white
            self.trackTwoVolume.textColor = UIColor.white
            
        } else {
            print("Dark mode")
            //player 1
            self.trackOneView.backgroundColor = UIColor.clear
            self.trackOnePlayBtn.backgroundColor = UIColor.systemGreen
            self.trackOneStopBtn.backgroundColor = UIColor.systemRed
            self.trackOnePauseBtn.backgroundColor = UIColor.gray
            self.trackOneRestartTrackBtn.backgroundColor = UIColor.systemOrange
            self.trackOneChangeTrackBtn.backgroundColor = UIColor.systemTeal
            //player 2
            self.trackTwoView.backgroundColor = UIColor.clear
            self.trackTwoPlayBtn.backgroundColor = UIColor.systemGreen
            self.trackTwoPauseBtn.backgroundColor = UIColor.gray
            self.trackTwoStopBtn.backgroundColor = UIColor.systemRed
            self.trackTwoRestartBtn.backgroundColor = UIColor.systemOrange
            self.trackTwoChangeTrackBtn.backgroundColor = UIColor.systemTeal
            
        }
        
    }
    
    func setupAudio(){
        /* Setup & Start Engine */
        
        //initialize it
        engine = AVAudioEngine()
        
        //initialzing the mainMixerNode singleton which will connect to the default output node
        _ = engine.mainMixerNode
        
        //prepare and start
        engine.prepare()
        do {
            try engine.start()
        } catch {
            print(error)
        }
        
        /* Add a player node (our music!) to the engine */
        
        //first we need the resource url for our file
        //let trackOnePath = NSDataAsset(name: "runnyBeat")!
        guard let url = Bundle.main.url(forResource: "runnyBeat", withExtension: "mp3") else {
            print("mp3 not found")
            return
        }
        
        //now we need to create our player node
        let player = AVAudioPlayerNode()
        
        do {
            //player nodes have a few ways to play-back music, the easiest way is from an AVAudioFile
            let audioFile = try AVAudioFile(forReading: url)
            
            //audio always has a format, lets keep track of what the format is as an AVAudioFormat
            let format = audioFile.processingFormat
            print(format)
            
            //we now need to connect add the node to our engine. This part is a little weird but we first need
            //to attach it to the engine itself before connecting it to the mainMixerNode. Recall that the
            //mainMixerNode connects to the default outputNode, so now we'll have a complete playback path from
            //our file to the outputNode!
            engine.attach(player)
            engine.connect(player, to: engine.mainMixerNode, format: format)
            
            //let's play the file!
            //note: player must be attached first before scheduling a file to play
            player.scheduleFile(audioFile, at: nil, completionHandler: nil)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //tap it to get the buffer data at playtime
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: nil) { (buffer, time) in
               self.processAudioData(buffer: buffer)
           }
        //start playing the music!
        player.play()
    }
    

    func processAudioData(buffer: AVAudioPCMBuffer){
        guard let channelData = buffer.floatChannelData?[0] else {return}
        let frames = buffer.frameLength
        
        //rms jj
        let rmsValue = SignalProcessing.rms(data: channelData, frameLength: UInt(frames))
        let interpolatedResults = SignalProcessing.interpolate(current: rmsValue, previous: prevRMSValue)
        prevRMSValue = rmsValue
        
        //pass values to the audiovisualizer for the rendering
        for rms in interpolatedResults {
            audioVisualizer.loudnessMagnitude = rms
        }
        
        //fft
        let fftMagnitudes =  SignalProcessing.fft(data: channelData, setup: fftSetup!)
        audioVisualizer.frequencyVertices = fftMagnitudes
    }
    
    @objc func trackOneTime() {
        self.trackOneDurationLabel.text = "\(self.audioPlayerOne?.currentTime().rounded() ?? 0.0)"
        self.trackOneTime_Double = self.audioPlayerOne?.currentTime() ?? 0.0
    }
    @objc func trackTwoTime() {
        self.trackTwoDurationLabel.text = "\(self.audioPlayerTwo?.currentTime().rounded() ?? 0.0)"
        self.trackTwoTime_Double = self.audioPlayerTwo?.currentTime() ?? 0.0
    }
    //MARK: Play Track One
    @IBAction func playTrackOne(_ sender: Any) {
        
        print("PLAYING TRACK ONE")
        if self.audioPlayerTwo?.isCurrentlyPlaying() == true {

            self.audioPlayerOne!.prepareToPlay()

            self.audioPlayerOne?.playSongAtTime(time: self.trackTwoTime_Double + 0.1839)
            self.audioPlayerTwo?.stopTrack()

            //player 1
            self.trackOnePlayBtn.setTitle("Playing", for: .normal)
            self.trackOnePauseBtn.setTitle("Pause", for: .normal)
            //player 2
            self.trackTwoPlayBtn.setTitle("Play", for: .normal)
            self.trackTwoPauseBtn.setTitle("Pause", for: .normal)
            //self.trackOneStopBtn.setTitle("Stop", for: .normal)
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackTwoView.backgroundColor = UIColor.black
                self.trackOneView.backgroundColor = UIColor.systemGreen
            } else {
                print("Dark mode")
                self.trackTwoView.backgroundColor = UIColor.black
                self.trackOneView.backgroundColor = UIColor.systemGreen
            }
            
        } else if self.audioPlayerOne?.trackOnePaused == true {
            self.audioPlayerOne?.playTrack()
            //player 1
            self.trackOnePlayBtn.setTitle("Playing", for: .normal)
            self.trackOnePauseBtn.setTitle("Pause", for: .normal)
            //player 2
            self.trackTwoPlayBtn.setTitle("Play", for: .normal)
            self.trackTwoPauseBtn.setTitle("Pause", for: .normal)
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackTwoView.backgroundColor = UIColor.black
                self.trackOneView.backgroundColor = UIColor.systemGreen
            } else {
                print("Dark mode")
                self.trackTwoView.backgroundColor = UIColor.black
                self.trackOneView.backgroundColor = UIColor.systemGreen
            }
        } else if self.audioPlayerTwo?.trackTwoPaused == true {
            
            self.audioPlayerOne!.prepareToPlay()

            self.audioPlayerOne?.playSongAtTime(time: self.trackTwoTime_Double + 0.1839)
            self.audioPlayerTwo?.stopTrack()

            //player 1
            self.trackOnePlayBtn.setTitle("Playing", for: .normal)
            self.trackOnePauseBtn.setTitle("Pause", for: .normal)
            //player 2
            self.trackTwoPlayBtn.setTitle("Play", for: .normal)
            self.trackTwoPauseBtn.setTitle("Pause", for: .normal)
            //self.trackOneStopBtn.setTitle("Stop", for: .normal)
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackTwoView.backgroundColor = UIColor.black
                self.trackOneView.backgroundColor = UIColor.systemGreen
            } else {
                print("Dark mode")
                self.trackTwoView.backgroundColor = UIColor.black
                self.trackOneView.backgroundColor = UIColor.systemGreen
            }
            
        } else {
            self.audioPlayerOne?.playTrack()
            //player 1
            self.trackOnePlayBtn.setTitle("Playing", for: .normal)
            self.trackOnePauseBtn.setTitle("Pause", for: .normal)
            //player 2
            self.trackTwoPlayBtn.setTitle("Play", for: .normal)
            self.trackTwoPauseBtn.setTitle("Pause", for: .normal)
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackTwoView.backgroundColor = UIColor.black
                self.trackOneView.backgroundColor = UIColor.systemGreen
            } else {
                print("Dark mode")
                self.trackTwoView.backgroundColor = UIColor.black
                self.trackOneView.backgroundColor = UIColor.systemGreen
            }
        }
        
    }
    
    //MARK: Pause Track One
    @IBAction func pauseTrackOne(_ sender: Any) {
        print("Pausing Track One")

        if self.audioPlayerOne?.isCurrentlyPlaying() == true {
            self.audioPlayerOne?.pauseTrack()
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackOneView.backgroundColor = UIColor.lightGray

            } else {
                print("Dark mode")
                self.trackOneView.backgroundColor = UIColor.gray
            }
        } else {
            return
        }
    }
    
    //MARK: Restart Track One
    @IBAction func restartTrackOne(_ sender: Any) {
        self.audioPlayerOne?.restartTrack()
    }
    
    //MARK: Stop Track One
    @IBAction func stopTrackOne(_ sender: Any) {
        
        if self.audioPlayerOne?.trackOnePaused == true {
            self.audioPlayerOne?.stopTrack()
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackOneView.backgroundColor = UIColor.black

            } else {
                print("Dark mode")
                self.trackOneView.backgroundColor = UIColor.black
            }
        } else if self.audioPlayerOne?.isCurrentlyPlaying() == true {
            self.audioPlayerOne?.stopTrack()
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackOneView.backgroundColor = UIColor.black

            } else {
                print("Dark mode")
                self.trackOneView.backgroundColor = UIColor.black
            }
        } else {
            return
        }
    }
    
    //MARK: Play Track Two
    @IBAction func playTrackTwo(_ sender: Any) {
        
        self.audioPlayerTwo?.prepareToPlay()
        if self.audioPlayerOne?.isCurrentlyPlaying() == true {
            print("Track 2 - CURRENTLY PLAYING TRACK 1")

            self.audioPlayerOne?.volumeControl(volume: (self.audioPlayerTwo?.curentVolume())!)
            self.audioPlayerTwo?.playSongAtTime(time: self.trackOneTime_Double + 0.1839)
            self.audioPlayerOne?.stopTrack()
            
            //player 1
            self.trackOnePlayBtn.setTitle("Play", for: .normal)
            self.trackOnePauseBtn.setTitle("Pause", for: .normal)
            //player 2
            self.trackTwoPlayBtn.setTitle("Playing", for: .normal)
            self.trackTwoPauseBtn.setTitle("Pause", for: .normal)

            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackOneView.backgroundColor = UIColor.black
                self.trackTwoView.backgroundColor = UIColor.systemGreen
            } else {
                print("Dark mode")
                self.trackOneView.backgroundColor = UIColor.black
                self.trackTwoView.backgroundColor = UIColor.systemGreen
            }
            
        } else if self.audioPlayerTwo?.trackTwoPaused == true {
            self.audioPlayerTwo?.playTrack()
            //player 1
            self.trackOnePlayBtn.setTitle("Play", for: .normal)
            self.trackOnePauseBtn.setTitle("Pause", for: .normal)
            //player 2
            self.trackTwoPlayBtn.setTitle("Playing", for: .normal)
            self.trackTwoPauseBtn.setTitle("Pause", for: .normal)
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackOneView.backgroundColor = UIColor.black
                self.trackTwoView.backgroundColor = UIColor.systemGreen
            } else {
                print("Dark mode")
                self.trackOneView.backgroundColor = UIColor.black
                self.trackTwoView.backgroundColor = UIColor.systemGreen
            }
        } else if self.audioPlayerOne?.trackOnePaused == true {
    
            self.audioPlayerOne?.volumeControl(volume: (self.audioPlayerTwo?.curentVolume())!)
            self.audioPlayerTwo?.playSongAtTime(time: self.trackOneTime_Double + 0.1839)
            self.audioPlayerOne?.stopTrack()
            
            //player 1
            self.trackOnePlayBtn.setTitle("Play", for: .normal)
            self.trackOnePauseBtn.setTitle("Pause", for: .normal)
            //player 2
            self.trackTwoPlayBtn.setTitle("Playing", for: .normal)
            self.trackTwoPauseBtn.setTitle("Pause", for: .normal)

            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackOneView.backgroundColor = UIColor.black
                self.trackTwoView.backgroundColor = UIColor.systemGreen
            } else {
                print("Dark mode")
                self.trackOneView.backgroundColor = UIColor.black
                self.trackTwoView.backgroundColor = UIColor.systemGreen
            }
            
        }else {
            
            self.audioPlayerTwo?.playTrack()
            //player 1
            self.trackOnePlayBtn.setTitle("Play", for: .normal)
            self.trackOnePauseBtn.setTitle("Pause", for: .normal)
            //player 2
            self.trackTwoPlayBtn.setTitle("Playing", for: .normal)
            self.trackTwoPauseBtn.setTitle("Pause", for: .normal)
            
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackOneView.backgroundColor = UIColor.black
                self.trackTwoView.backgroundColor = UIColor.systemGreen
            } else {
                print("Dark mode")
                self.trackOneView.backgroundColor = UIColor.black
                self.trackTwoView.backgroundColor = UIColor.systemGreen
            }
        }
    }
    //MARK: Pause track 2
    @IBAction func pauseTrackTwo(_ sender: Any) {
        print("Pausing Track Two")

        if self.audioPlayerTwo?.isCurrentlyPlaying() == true {
            self.audioPlayerTwo?.pauseTrack()
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackTwoView.backgroundColor = UIColor.lightGray

            } else {
                print("Dark mode")
                self.trackTwoView.backgroundColor = UIColor.gray
            }
        } else {
            return
        }
    }
    //MARK: Stop track 2
    @IBAction func stopTrackTwo(_ sender: Any) {
        
        if self.audioPlayerTwo?.trackTwoPaused == true {
            self.audioPlayerTwo?.stopTrack()
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackOneView.backgroundColor = UIColor.black

            } else {
                print("Dark mode")
                self.trackOneView.backgroundColor = UIColor.black
            }
        } else if self.audioPlayerTwo?.isCurrentlyPlaying() == true {
            self.audioPlayerTwo?.stopTrack()
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                self.trackTwoView.backgroundColor = UIColor.black

            } else {
                print("Dark mode")
                self.trackTwoView.backgroundColor = UIColor.black
            }
        } else {
            return
        }
    }
    @IBAction func restartTrackTwo(_ sender: Any) {
        self.audioPlayerTwo?.restartTrack()
    }
    
    //MARK: Volume Control: Track One
    @IBAction func volumeChangeTrackOne(_ sender: UISlider) {
        self.audioPlayerOne?.volumeControl(volume: sender.value)
        self.trackOneVolume.text = "\(self.trackOneVolumeControl.value.rounded())"
    }
    
    //MARK: Volume Control: Track Two
    @IBAction func volumeChangeTrackTwo(_ sender: UISlider) {
        self.audioPlayerTwo?.volumeControl(volume: sender.value)
        self.trackTwoVolume.text = "\(self.trackTwoVolumeControl.value.rounded())"
    }
    
    @IBAction func changeTrackOne(_ sender: Any) {
       
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    
//    func colourScheme_WhiteBlack(){
//        if traitCollection.userInterfaceStyle == .light {
//            print("Light mode")
//            self.trackTwoView.backgroundColor = UIColor.white
//            self.trackOneView.backgroundColor = UIColor.systemGreen
//        } else {
//            print("Dark mode")
//            self.trackOneView.backgroundColor = UIColor.black
//            self.trackOneView.backgroundColor = UIColor.systemGreen
//        }
//    }

}
extension ViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
//        guard let selectedFileURL = urls.first else {
//            return
//        }
        
        let selectedFileURL = URL(fileURLWithPath: urls[0].absoluteString)
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            self.trackOneTitle.text = selectedFileURL.absoluteString
            self.audioPlayerOne?.trackOne = selectedFileURL.absoluteString
            print("Already exists! Do nothing")
        } else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                print("Copied file!")
            }
            catch {
                print("Error: \(error)")
            }
            
        }
    }
}


