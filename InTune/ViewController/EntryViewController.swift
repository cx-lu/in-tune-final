//
//  EntryViewController.swift
//  InTune
//
//  Created by Christina Lu on 12/5/19.
//  Copyright © 2019 Christina Lu. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class EntryViewController: UIViewController {
    
    var entry: Entry!
    var audioPlayer : AVPlayer?
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var journalEntry: UITextView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var currTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let playImage = UIImage(named: "play")
    let pauseImage = UIImage(named: "pause")
    
    var totalTimeValue = 1.0
    
    var playBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        displaySong()
        colorView.backgroundColor = entry.color
    }
    
    func displaySong() {
        songName.text = entry.name
        songArtist.text = entry.artist
        journalEntry.text = entry.journalEntry
        
        let url = URL(string: entry!.imgUrl)
        let data = try? Data(contentsOf: url!)
        img.image = UIImage(data: data!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        date.text = dateFormatter.string(from: entry.date)
    }
    
    func setupPlayer() {
        let url : URL = entry.song.getUrl()!
        
        DispatchQueue.main.async {
            self.audioPlayer = AVPlayer(url: url)
            let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
            
            self.audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: nil, using: { (time : CMTime) in
                self.updateCurrentProgress(time)
            })
            self.populateSongDurationLabel()
        }
    }
    
    @IBAction func playPause(_ sender: Any) {
        if (playBool) {
            audioPlayer!.play()
            playBool = !playBool
            playPauseButton.setImage(pauseImage, for: .normal)
        } else {
            audioPlayer!.pause()
            playBool = !playBool
            playPauseButton.setImage(playImage, for: .normal)
        }
        
    }
    
    func populateSongDurationLabel() {
        if let totalSeconds = audioPlayer?.currentItem?.asset.duration.seconds {
            let totalSecondsInt = Int(totalSeconds)
            let minutes = totalSecondsInt / 60
            if (totalSecondsInt - minutes * 60 < 10) {
                totalTime.text = String(minutes) + ":0" + String(totalSecondsInt)
            } else {
                totalTime.text = String(minutes) + ":" + String(totalSecondsInt)
            }
            totalTimeValue = totalSeconds
        }
    }
    
    func updateCurrentProgress(_ time : CMTime) {
        let totalSecondsDouble = time.seconds
        let totalSecondsInt = Int(totalSecondsDouble)
        let minutes = totalSecondsInt / 60
        if (totalSecondsInt - minutes * 60 < 10) {
            currTime.text = String(minutes) + ":0" + String(totalSecondsInt)
        } else {
            currTime.text = String(minutes) + ":" + String(totalSecondsInt)
        }
        progressBar.setProgress(Float(totalSecondsDouble / totalTimeValue), animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer!.pause()
    }
    
}
