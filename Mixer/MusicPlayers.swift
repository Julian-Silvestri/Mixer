//
//  MusicPlayers.swift
//  Mixer
//
//  Created by Julian Silvestri on 2020-06-14.
//  Copyright © 2020 Julian Silvestri. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

//MARK: MUSIC PLAYER 1
class MusicPlayerOne {
    
    var musicPlayerOne: AVAudioPlayer? = nil
//    var trackOne = "runnyBeat"
    var trackOne = ""
    var trackOnePaused: Bool?
     
    init(){
        let trackOnePath = NSDataAsset(name: trackOne)
        //let audioUrl = URL(fileURLWithPath: "\(trackOnePath)")
        do {
            try musicPlayerOne = AVAudioPlayer(data: trackOnePath?.data ?? Data.init())
            musicPlayerOne!.prepareToPlay()
            
        } catch let err{
            print("ERROR Track One")
            print(err.localizedDescription)
        }
    }
    
    func currentTrack()->String{
        return trackOne
    }
    
    func playTrack(){
        musicPlayerOne?.prepareToPlay()
        if musicPlayerOne?.isPlaying == true {
            return
        } else {
            musicPlayerOne?.play()
            trackOnePaused = false
        }
    }
    
    func stopTrack() {
        if musicPlayerOne?.isPlaying == true || trackOnePaused == true {
            musicPlayerOne?.stop()
            musicPlayerOne?.currentTime = 0
            trackOnePaused = false
        } else {
            return
        }
    }
    
    func pauseTrack() {
        if musicPlayerOne?.isPlaying == true {
            musicPlayerOne?.pause()
            trackOnePaused = true
        } else {
            return
        }
    }
    
    func restartTrack() {
        musicPlayerOne?.prepareToPlay()
        musicPlayerOne?.stop()
        musicPlayerOne?.currentTime = 0
        musicPlayerOne?.play()
    }
    
    func isCurrentlyPlaying() -> Bool{
        if musicPlayerOne?.isPlaying == true {
            print("Track 1 is currently Playing")
            return true
        } else {
            print("Track 1 is NOT playing")
            return false
        }
    }
    
    func currentTime()->Double{
        return musicPlayerOne?.currentTime ?? 0
    }
    
    func playSongAtTime(time: Double) {
        musicPlayerOne?.prepareToPlay()
        musicPlayerOne?.currentTime = time
        musicPlayerOne?.play()
    }
    
    func volumeControl(volume: Float) {
        musicPlayerOne?.volume = volume
    }
    func curentVolume()->Float{
        //print("CURRENT VOLUME OF TRACK 2 -> \(musicPlayerOne?.volume)")
        return musicPlayerOne!.volume
    }
    func prepareToPlay(){
        musicPlayerOne?.prepareToPlay()
    }
    func changeTrack(track: String){
        stopTrack()
        //let data = NSDataAsset(name: trackOne)!
//
        //let url = NSURL(fileURLWithPath: trackOne)
//        guard let url = Bundle.main.url(forResource: trackOne, withExtension: "mp3") else {
//            print("mp3 not found")
//            return
//        }
        do {
            //try musicPlayerOne = AVAudioPlayer(data: data.data)
//            try musicPlayerOne = AVAudioPlayer(contentsOf: url)
            try musicPlayerOne = AVAudioPlayer(contentsOf: URL(string: track)!, fileTypeHint: "mp3")
            musicPlayerOne!.prepareToPlay()
            //musicPlayerOne?.play()
            
        } catch let err{
            print("ERROR Track One")
            print(err.localizedDescription)
        }
    }
    
    
    
    
}

//MARK: MUSIC PLAYER 2
class MusicPlayerTwo {
    
    var musicPlayerTwo: AVAudioPlayer? = nil
    //var trackTwo = "runnyBeatBass"
    var trackTwo = ""
    var trackTwoPaused: Bool?
    
    init() {
        
        let trackTwoPath = NSDataAsset(name: trackTwo)
        //let audioUrl = URL(fileURLWithPath: "\(trackTwoPath)")
        do {
            try musicPlayerTwo = AVAudioPlayer(data: trackTwoPath?.data ?? Data.init())
            musicPlayerTwo!.prepareToPlay()
        } catch let err {
            print("ERROR Track Two")
            print(err.localizedDescription)
        }
    }
    
    func playTrack(){
        musicPlayerTwo?.prepareToPlay()
        if musicPlayerTwo?.isPlaying == true {
            return
        } else {
            musicPlayerTwo?.play()
            trackTwoPaused = false
        }
    }
    
    func stopTrack() {
        if musicPlayerTwo?.isPlaying == true || trackTwoPaused == true{
            musicPlayerTwo?.stop()
            musicPlayerTwo?.currentTime = 0
            trackTwoPaused = false
        } else {
            return
        }
    }
    
    func pauseTrack() {
        if musicPlayerTwo?.isPlaying == true {
            musicPlayerTwo?.pause()
            trackTwoPaused = true
        } else {
            return
        }
    }
    
    func restartTrack() {
        musicPlayerTwo?.prepareToPlay()
        musicPlayerTwo?.stop()
        musicPlayerTwo?.currentTime = 0
        musicPlayerTwo?.play()
    }
    func isCurrentlyPlaying() -> Bool{
        if musicPlayerTwo?.isPlaying == true {
            print("Track Two is currently playing ->")
            return true
        } else {
            print("Track Two is NOT playing ->")
            return false
        }
    }
    func currentTime()->Double{
        return musicPlayerTwo?.currentTime ?? 0
    }
    func playSongAtTime(time: Double) {
        musicPlayerTwo?.prepareToPlay()
        musicPlayerTwo?.currentTime = time
        musicPlayerTwo?.play()
    }
    func volumeControl(volume: Float) {
        musicPlayerTwo?.volume = volume
    }
    func curentVolume()->Float{
        //print("CURRENT VOLUME OF TRACK 2 -> \(musicPlayerTwo?.volume)")
        return musicPlayerTwo!.volume
    }
    func prepareToPlay(){
        musicPlayerTwo?.prepareToPlay()
    }
    func changeTrack(track: String){
        stopTrack()

        do {

            try musicPlayerTwo = AVAudioPlayer(contentsOf: URL(string: track)!, fileTypeHint: "mp3")
            musicPlayerTwo!.prepareToPlay()
            //musicPlayerTwo?.play()
            
        } catch let err{
            print("ERROR Track One")
            print(err.localizedDescription)
        }
    }

    
}
