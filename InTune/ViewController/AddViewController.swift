//
//  AddViewController.swift
//  InTune
//
//  Created by Christina Lu on 12/5/19.
//  Copyright © 2019 Christina Lu. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AddViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var song: Song!
    var color: UIColor = UIColor(red: 174.0/255.0, green: 216.0/255.0, blue: 255.0/255.0, alpha: 1)
    var edited: Bool = false
    
    let colorArray: [UIColor] = [UIColor.systemBlue, UIColor.systemGreen, UIColor.systemPink, UIColor.systemRed, UIColor.systemGray]
    @IBOutlet weak var colorCollection: UICollectionView!
    
    var audioPlayer : AVPlayer?
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var journalEntry: UITextView!
    @IBOutlet weak var songImg: UIImageView!
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
        songImg.image = UIImage(named: "music")
        setupPlayer()
        displaySong()
        
        journalEntry.delegate = self
        journalEntry.text = "New Entry"
        journalEntry.textColor = UIColor.white
        
        self.colorCollection.delegate = self
        self.colorCollection.dataSource = self
    }
    
    func displaySong() {
        songName.text = song.name
        songArtist.text = song.artist
        displayImage()
    }
    
    func displayImage() {
        let url = URL(string: song!.imageUrl)
        let data = try? Data(contentsOf: url!)
        songImg.image = UIImage(data: data!)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if journalEntry.textColor == UIColor.white {
            journalEntry.text = ""
        }
        edited = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if journalEntry.text == "" {
            journalEntry.text = "New Entry"
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if !edited {
            journalEntry.text = ""
        }
        let entry = Entry(song: song, journalEntry: journalEntry.text ?? "", color: color, date: Date())
        EntryDB.addEntry(e: entry)
        performSegue(withIdentifier: "unwindToHome", sender: self)
       }
    
    
    func setupPlayer() {
        let url : URL = song.getUrl()!
        
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorCollection.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        cell.backgroundColor = colorArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.white.cgColor
        color = colorArray[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0.0
    }
}
