//
//  MedalDetailViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class MedalDetailViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var countDifficultyLabel: UILabel!
    @IBOutlet var radialView: RadialBackgroundView!

    var openingFrame: CGRect!
    var viewModel: MedalDetailViewModel!

    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupDismissal()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        animateViews(open: true, completion: nil)
    }

    fileprivate func setupAppearance() {
        radialView.alpha = 0
        imageView = UIImageView(frame: openingFrame)
        view.addSubview(imageView)
        imageView.image = viewModel.imageManager.cachedMedalImage(viewModel.medal)
        setupLabels()
    }

    fileprivate func setupLabels() {
        nameLabel.textColor = .whiteSmoke
        descriptionLabel.textColor = .whiteSmoke
        countDifficultyLabel.textColor = .whiteSmoke

        nameLabel.font = UIFont.kelson(.Medium, size: 20)
        descriptionLabel.font = UIFont.kelson(.Regular, size: 16)
        countDifficultyLabel.font = UIFont.kelson(.Bold, size: 14)

        nameLabel.alpha = 0
        descriptionLabel.alpha = 0
        countDifficultyLabel.alpha = 0

        nameLabel.text = viewModel.medal.name
        descriptionLabel.text = viewModel.medal.description
        countDifficultyLabel.attributedText = attributedMedalText
    }

    fileprivate var attributedMedalText: NSAttributedString {
        let classification = "Classification:"
        let difficulty = "Difficulty:"
        let count = "Count:"
        let finalText = "\(classification) \(viewModel.medal.classification.normalizedFromCapitalizedString)\n\(difficulty) \(viewModel.medal.difficulty)\n\(count) \(viewModel.medal.count)"
        let nsText = finalText as NSString
        let classificationRange = nsText.range(of: classification)
        let difficultyRange = nsText.range(of: difficulty)
        let countRange = nsText.range(of: count)
        let font = UIFont.kelson(.Light, size: 14) ?? UIFont.systemFont(ofSize: 14)

        let final = NSMutableAttributedString(string: finalText)
        final.addAttributes([.font : font], range: classificationRange)
        final.addAttributes([.font : font], range: difficultyRange)
        final.addAttributes([.font : font], range: countRange)

        return final
    }

    fileprivate func animateViews(open: Bool, completion: (() -> Void)?) {
        if open {
            animateOpen()
        } else {
            animateClose(completion)
        }
    }

    fileprivate func animateOpen() {
        let frame = endingFrame

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20.0, options: [], animations: { [weak self] in
            self?.imageView.frame = frame
            self?.radialView.alpha = 1
            self?.nameLabel.alpha = 1
            self?.descriptionLabel.alpha = 1
            self?.countDifficultyLabel.alpha = 1
            }, completion: nil)
    }

    fileprivate func animateClose(_ completion: (() -> Void)?) {
        let frame = openingFrame

        UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: { [weak self] in
            self?.imageView.frame = frame!
            self?.radialView.alpha = 0
            self?.nameLabel.alpha = 0
            self?.descriptionLabel.alpha = 0
            self?.countDifficultyLabel.alpha = 0
            }, completion: { (_) in
                if let completion = completion {
                    completion()
                }
        })
    }

    fileprivate var endingFrame: CGRect {
        let endingSize: CGFloat = 100
        let halfImageView: CGFloat = endingSize / 2
        let origin = CGPoint(x: view.frame.size.width / 2 - halfImageView, y: view.frame.size.height / 3 - halfImageView)
        let size = CGSize(width: endingSize, height: endingSize)
        let frame = CGRect(origin: origin, size: size)

        return frame
    }

    fileprivate func setupDismissal() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
    }

    @objc fileprivate func dismissView() {
        animateViews(open: false) { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
    }
}
