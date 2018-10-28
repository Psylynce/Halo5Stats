//
//  VideoViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {

    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        registerNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadVideo()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private

    fileprivate var currentTime: CMTime?

    @objc fileprivate func replayVideo(_ notification: Notification) {
        if let player = player {
            player.seek(to: .zero)
            player.play()
        }
    }

    @objc fileprivate func appEnteredForeground() {
        if let currentTime = currentTime {
            play(fromTime: currentTime)
            self.currentTime = nil
        }
    }

    @objc fileprivate func appEnteredBackground() {
        player?.pause()
        currentTime = player?.currentTime()
    }

    fileprivate func play(fromTime time: CMTime) {
        guard let player = player else { return }
        if player.status == .readyToPlay && player.currentItem?.status == .readyToPlay {
            player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { (_) in
                player.play()
            }) 
        } else {
            let delay = Int64(Double(NSEC_PER_SEC) * 0.2)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay) / Double(NSEC_PER_SEC)) { [weak self] in
                self?.play(fromTime: time)
            }
        }
    }

    fileprivate var playerLayer: AVPlayerLayer? {
        guard let path = Bundle.main.path(forResource: "HaloIntro", ofType: "mp4") else { return nil }

        let url = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = view.frame
        playerLayer.videoGravity = .resizeAspectFill

        return playerLayer
    }

    fileprivate func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(replayVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    fileprivate func loadVideo() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
        } catch {}

        if let playerLayer = playerLayer {
            view.layer.addSublayer(playerLayer)
        }

        if let player = player {
            player.isMuted = true
            player.play()
        }
    }
}
