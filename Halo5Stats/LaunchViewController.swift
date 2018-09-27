//
//  LaunchViewController.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit
import Foundation

protocol LaunchViewControllerDelegate: class {
    func launchViewControllerButtonTapped(_ sender: UIButton)
    func cancelButtonTapped(_ sender: UIButton)
}

class LaunchViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    struct K {
        static let buttonLowerPositionConstant: CGFloat = 250.0
        static let buttonHigherPositionConstant: CGFloat = 400.0
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        gamertagValidator.viewController = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if MetadataManager.initialMetadataLoaded == false {
            showMetadataLabel()

            MetadataManager.fetchMetadata{ [weak self] in
                MetadataManager.initialMetadataLoaded = true

                DispatchQueue.main.async {
                    self?.hideMetadataLabel {
                        self?.animateElements()
                    }
                }
            }
        } else {
            animateElements()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        resetView()
    }
    
    // MARK: - LaunchViewController
    
    // MARK: Internal

    var isChangingGamertag: Bool = false
    weak var delegate: LaunchViewControllerDelegate?
    
    // MARK: Private

    fileprivate let gamertagManager = GamertagManager.sharedManager
    fileprivate let gamertagValidator = GamertagValidator()
    fileprivate var isLoadingMetadataLabelAnimating: Bool = false

    fileprivate var tapGesture: UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        return gesture
    }

    fileprivate func setupElements() {
        view.backgroundColor = UIColor.black
        scrollView.delegate = self
        contentView.backgroundColor = UIColor.clear

        metadataLabel.font = UIFont.kelson(.Regular, size: 18)
        metadataLabel.textColor = .whiteSmoke
        metadataLabel.alpha = 0

        let attributes: [NSAttributedString.Key : AnyObject]? = [
            .foregroundColor : UIColor.whiteSmoke.withAlphaComponent(0.6),
            .font : UIFont.kelson(.Regular, size: 14)!
        ]
        let placeholder = NSAttributedString(string: "Enter Gamertag", attributes: attributes)
        textField.attributedPlaceholder = placeholder
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.textColor = UIColor.white
        textField.tintColor = UIColor.white
        textField.alpha = 0
        textField.font = UIFont.kelson(.Regular, size: 16)
        
        launchButton.addTarget(self, action: #selector(launchButtonTapped(_:)), for: .touchUpInside)
        launchButton.setTitle("Launch", for: .normal)
        launchButton.alpha = 0
        borderView.alpha = 0
        cancelButton.alpha = 0
        cancelButton.isEnabled = isChangingGamertag

        cancelButton.setTitleColor(.whiteSmoke, for: .normal)
        cancelButton.titleLabel?.font = UIFont.kelson(.Regular, size: 17)

        videoContainerView.alpha = 0
        view.addGestureRecognizer(tapGesture)
    }

    fileprivate func resetView() {
        imageViewVerticalCenterConstraint.constant = 0

        textField.alpha = 0
        launchButton.alpha = 0
        borderView.alpha = 0
        cancelButton.alpha = 0
        videoContainerView.alpha = 0
    }

    fileprivate func animateElements() {
        imageViewVerticalCenterConstraint.constant = -logoImageView.frame.height / 2.5

        UIView.animate(withDuration: 0.3, delay: 0.5, options: UIView.AnimationOptions(), animations: {
            self.view.layoutIfNeeded()
            }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                self.videoContainerView.alpha = 1
                self.launchButton.alpha = 1
                self.textField.alpha = 1
                self.borderView.alpha = 1

                if self.isChangingGamertag {
                    self.cancelButton.alpha = 1
                }
            })
        }
    }

    fileprivate func showMetadataLabel() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions(), animations: { [weak self] in
            self?.metadataLabel.alpha = 1
            }, completion: nil)
    }

    fileprivate func hideMetadataLabel(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions(), animations: { [weak self] in
            self?.metadataLabel.alpha = 0
        }) { (_) in
            completion()
        }
    }

    @objc fileprivate func endEditing() {
        view.endEditing(true)
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let possibleNewText = text.replacingCharacters(in: range.rangeForString(text), with: string)
        
        let lengthIsValid = possibleNewText.count <= GamertagManager.K.maxGamertagLength
        let charactersAreValid = gamertagManager.containsGamertagCharacters(possibleNewText) || possibleNewText.isEmpty
        
        return lengthIsValid && charactersAreValid
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    
    @objc func launchButtonTapped(_ sender: UIButton) {
        guard let gamertag = textField.text else { return }
        view.endEditing(true)
        showIndicator(animate: true)

        gamertagValidator.validate(gamertag, shouldSaveGamertag: true) { [weak self] (success) in
            self?.hideIndicator()

            if success {
                SpartanManager.sharedManager.saveSpartan(gamertag)
                if let changing = self?.isChangingGamertag, changing {
                    GamertagManager.sharedManager.defaultGamertagChanged()
                }
                self?.delegate?.launchViewControllerButtonTapped(sender)
                self?.textField.text = nil
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        textField.text = nil
        delegate?.cancelButtonTapped(sender)
    }

    // MARK: - IBOutlets
    
    @IBOutlet var videoContainerView: UIView!
    @IBOutlet var imageViewVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var metadataLabel: UILabel!
    @IBOutlet var loadingIndicator: LoadingIndicator!
    @IBOutlet var textField: UITextField!
    @IBOutlet var borderView: UIView!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var cancelButton: UIButton!
}

extension LaunchViewController: DataLoader {

    func showIndicator(animate: Bool) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.textField.alpha = 0
            self?.launchButton.alpha = 0
            self?.borderView.alpha = 0
            if let changing = self?.isChangingGamertag, changing {
                self?.cancelButton.alpha = 0
            }
            }, completion: { [weak self] (_) in
                self?.loadingIndicator.show(animate: animate)
        }) 
    }

    func hideIndicator() {
        loadingIndicator.hide()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.textField.alpha = 1
            self?.launchButton.alpha = 1
            self?.borderView.alpha = 1
            if let changing = self?.isChangingGamertag, changing {
                self?.cancelButton.alpha = 1
            }
        }) 
    }
}
