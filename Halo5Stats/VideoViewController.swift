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

        view.backgroundColor = UIColor.blackColor()
        registerNotifications()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        loadVideo()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Private

    private var currentTime: CMTime?

    @objc private func replayVideo(notification: NSNotification) {
        if let player = player {
            player.seekToTime(kCMTimeZero)
            player.play()
        }
    }

    @objc private func appEnteredForeground() {
        if let currentTime = currentTime {
            play(fromTime: currentTime)
            self.currentTime = nil
        }
    }

    @objc private func appEnteredBackground() {
        player?.pause()
        currentTime = player?.currentTime()
    }

    private func play(fromTime time: CMTime) {
        guard let player = player else { return }
        if player.status == .ReadyToPlay && player.currentItem?.status == .ReadyToPlay {
            player.seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero) { (_) in
                player.play()
            }
        } else {
            let delay = Int64(Double(NSEC_PER_SEC) * 0.2)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay), dispatch_get_main_queue()) { [weak self] in
                self?.play(fromTime: time)
            }
        }
    }

    private var playerLayer: AVPlayerLayer? {
        guard let path = NSBundle.mainBundle().pathForResource("HaloIntro", ofType: "mp4") else { return nil }

        let url = NSURL.fileURLWithPath(path)
        let playerItem = AVPlayerItem(URL: url)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = view.frame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill

        return playerLayer
    }

    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(replayVideo(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: player?.currentItem)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appEnteredBackground), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appEnteredForeground), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

    private func loadVideo() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch {}

        if let playerLayer = playerLayer {
            view.layer.addSublayer(playerLayer)
        }

        if let player = player {
            player.muted = true
            player.play()
        }
    }
}
