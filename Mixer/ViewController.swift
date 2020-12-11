//
//  ViewController.swift
//  Mixer
//
//  Created by Julian Silvestri on 2020-06-14.
//  Copyright © 2020 Julian Silvestri. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var trackTwoDurationTime: UILabel!
    @IBOutlet weak var durationLabel_two: UILabel!
    @IBOutlet weak var trackOneDurationTIme: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var noTrackTwoView: UIView!
    @IBOutlet weak var noTrackOneView: UIView!
    @IBOutlet weak var noTracksStack: UIStackView!
    @IBOutlet weak var mainStack: UIStackView!
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
    @IBOutlet weak var trackOneVolumeLabel: UILabel!
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
    //
    @IBOutlet weak var addTrackOne_noTrack: UIButton!
    @IBOutlet weak var addTrackTwo_noTrack: UIButton!
    
    var audioPlayerOne: MusicPlayerOne?
    var audioPlayerTwo: MusicPlayerTwo?
    var trackOneTimer = Timer()
    var trackTwoTimer = Timer()
    var trackOneTime_Double = Double()
    var trackTwoTime_Double = Double()
    var trackOneSet: Bool? = false
    var trackTwoSet: Bool? = false
    var changingTrackOne: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.mainStack.isHidden = true
        
        self.trackOneView.layer.cornerRadius = 10
        self.trackTwoView.layer.cornerRadius = 10
        //test
        
        self.trackOneTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(trackOneTime), userInfo: nil, repeats: true)
        self.trackTwoTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(trackTwoTime), userInfo: nil, repeats: true)
        
        self.audioPlayerOne = MusicPlayerOne()
        self.audioPlayerTwo = MusicPlayerTwo()
        self.titleOfApp.textColor = UIColor.white
        
        //set titles of songs
        self.trackOneTitle.text = self.audioPlayerOne?.trackOne
        self.trackTwoTitle.text = self.audioPlayerTwo?.trackTwo
        
        //Corner Radius - No Tracks
        self.addTrackOne_noTrack.layer.cornerRadius = 5
        self.addTrackTwo_noTrack.layer.cornerRadius = 5
        
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
            self.trackOneVolumeLabel.textColor = UIColor.white
            self.durationLabel.textColor = UIColor.white
            //player 2
            self.trackTwoView.backgroundColor = UIColor.black
            self.trackTwoPlayBtn.backgroundColor = UIColor.systemGreen
            self.trackTwoPauseBtn.backgroundColor = UIColor.gray
            self.trackTwoStopBtn.backgroundColor = UIColor.systemRed
            self.trackTwoRestartBtn.backgroundColor = UIColor.systemOrange
            self.trackTwoChangeTrackBtn.backgroundColor = UIColor.systemTeal
            self.trackTwoTitle.textColor = UIColor.white
            self.trackTwoVolume.textColor = UIColor.white
            self.durationLabel_two.textColor = UIColor.white
            //other
            self.noTracksStack.backgroundColor = UIColor.black
            
        } else {
            print("Dark mode")
            //player 1
            self.trackOneView.backgroundColor = UIColor.black
            self.trackOnePlayBtn.backgroundColor = UIColor.systemGreen
            self.trackOneStopBtn.backgroundColor = UIColor.systemRed
            self.trackOnePauseBtn.backgroundColor = UIColor.gray
            self.trackOneRestartTrackBtn.backgroundColor = UIColor.systemOrange
            self.trackOneChangeTrackBtn.backgroundColor = UIColor.systemTeal
            self.trackOneTitle.textColor = UIColor.white
            self.trackOneVolume.textColor = UIColor.white
            self.trackOneVolumeLabel.textColor = UIColor.white
            self.durationLabel.textColor = UIColor.white
            //player 2
            self.trackTwoView.backgroundColor = UIColor.black
            self.trackTwoPlayBtn.backgroundColor = UIColor.systemGreen
            self.trackTwoPauseBtn.backgroundColor = UIColor.gray
            self.trackTwoStopBtn.backgroundColor = UIColor.systemRed
            self.trackTwoRestartBtn.backgroundColor = UIColor.systemOrange
            self.trackTwoChangeTrackBtn.backgroundColor = UIColor.systemTeal
            self.trackTwoTitle.textColor = UIColor.white
            self.trackTwoVolume.textColor = UIColor.white
            self.durationLabel_two.textColor = UIColor.white
            //other
            self.noTracksStack.backgroundColor = UIColor.black
        }
        
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
        if self.audioPlayerOne?.isCurrentlyPlaying() == true {
            self.audioPlayerOne?.restartTrack()
        } else if audioPlayerOne?.trackOnePaused == true {
            self.audioPlayerOne?.playTrack()
        }
        
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
    
    //MARK: Change Track One
    @IBAction func changeTrackOne(_ sender: Any) {
        self.changingTrackOne = true
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    //MARK: Add Track One
    @IBAction func addTrackOne(_ sender: Any) {
        self.changingTrackOne = true
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    @IBAction func changeTrackTwo(_ sender: Any) {
        self.changingTrackOne = false
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    //MARK: Add Track Two
    @IBAction func addTrackTwo(_ sender: Any) {
        self.changingTrackOne = false

        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion:nil)
    }
    
    
    func showMainMixer(){
        
        if self.trackTwoSet == true && self.trackOneSet == true {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.noTracksStack.alpha = 0
            }, completion: { _ in
                self.noTracksStack.isHidden = true
                self.mainStack.isHidden = false
            })
        } else {
            return
        }
    }

}
extension ViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
        
        if changingTrackOne == true {
            let selectedFileURL = URL(fileURLWithPath: "\(urls[0].path)")
            print("\(selectedFileURL)")
            
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
                self.trackOneTitle.text = "\(sandboxFileURL.lastPathComponent)"
                self.audioPlayerOne?.trackOne = "\(sandboxFileURL.path)"
                self.audioPlayerOne?.changeTrack(track: "\(sandboxFileURL)")
                print("Already exists! Do nothing")
                if self.audioPlayerOne?.trackOne == "" {
                    return
                } else {
                    print("track one is set")
                    self.trackOneSet = true
                    self.addTrackOne_noTrack.isEnabled = false
                    UIView.animate(withDuration: 0.5, animations: {
                        self.addTrackOne_noTrack.backgroundColor = UIColor.green
                    },completion: {_ in
                        self.showMainMixer()
                        self.addTrackOne_noTrack.setTitle("Track One Added", for: .normal)
                    })
                }
            } else {

                print("Error: 1")

            }
        } else {
            //changing track two
            let selectedFileURL = URL(fileURLWithPath: "\(urls[0].path)")
            print("\(selectedFileURL)")
            
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
                self.trackTwoTitle.text = "\(sandboxFileURL.lastPathComponent)"
                self.audioPlayerTwo?.trackTwo = "\(sandboxFileURL.path)"
                self.audioPlayerTwo?.changeTrack(track: "\(sandboxFileURL)")
                print("Already exists! Do nothing")
                
                if self.audioPlayerTwo?.trackTwo == ""{
                    return
                } else {
                    self.trackTwoSet = true
                    print("Track Two Is set")
  
                    self.addTrackTwo_noTrack.isEnabled = false
                    UIView.animate(withDuration: 0.5, animations: {
                        self.addTrackTwo_noTrack.backgroundColor = UIColor.green
                    }, completion: {_ in
                        self.showMainMixer()
                        self.addTrackTwo_noTrack.setTitle("Track Two Added!", for: .normal)

                    })
                }
            } else {

                print("Error: 2")

                
            }
        }


    }
    
//    func saveFile(name: String) {
//
//        let file = name
//        let filename = getDocumentsDirectory().appendingPathComponent(name)
//
//        do {
//            try file.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
//        } catch {
//
//        }
//
//    }
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
}


