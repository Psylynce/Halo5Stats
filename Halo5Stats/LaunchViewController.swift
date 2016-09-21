//
//  LaunchViewController.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit
import Foundation

protocol LaunchViewControllerDelegate: class {
    func launchViewControllerButtonTapped(sender: UIButton)
    func cancelButtonTapped(sender: UIButton)
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if MetadataManager.initialMetadataLoaded == false {
            showMetadataLabel()

            MetadataManager.fetchMetadata{ [weak self] in
                MetadataManager.initialMetadataLoaded = true

                dispatch_async(dispatch_get_main_queue()) {
                    self?.hideMetadataLabel {
                        self?.animateElements()
                    }
                }
            }
        } else {
            animateElements()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        resetView()
    }
    
    // MARK: - LaunchViewController
    
    // MARK: Internal

    var isChangingGamertag: Bool = false
    weak var delegate: LaunchViewControllerDelegate?
    
    // MARK: Private

    private let gamertagManager = GamertagManager.sharedManager
    private let gamertagValidator = GamertagValidator()
    private var isLoadingMetadataLabelAnimating: Bool = false

    private var tapGesture: UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        return gesture
    }

    private func setupElements() {
        view.backgroundColor = UIColor.blackColor()
        scrollView.delegate = self
        contentView.backgroundColor = UIColor.clearColor()

        metadataLabel.font = UIFont.kelson(.Regular, size: 18)
        metadataLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        metadataLabel.alpha = 0

        let attributes: [String : AnyObject]? = [NSForegroundColorAttributeName : UIColor(haloColor: .WhiteSmoke).colorWithAlphaComponent(0.6), NSFontAttributeName : UIFont.kelson(.Regular, size: 14)! ]
        let placeholder = NSAttributedString(string: "Enter Gamertag", attributes: attributes)
        textField.attributedPlaceholder = placeholder
        textField.delegate = self
        textField.autocorrectionType = .No
        textField.textAlignment = .Center
        textField.borderStyle = .None
        textField.textColor = UIColor.whiteColor()
        textField.tintColor = UIColor.whiteColor()
        textField.alpha = 0
        textField.font = UIFont.kelson(.Regular, size: 16)
        
        launchButton.addTarget(self, action: #selector(launchButtonTapped(_:)), forControlEvents: .TouchUpInside)
        launchButton.setTitle("Launch", forState: .Normal)
        launchButton.alpha = 0
        borderView.alpha = 0
        cancelButton.alpha = 0
        cancelButton.enabled = isChangingGamertag

        cancelButton.setTitleColor(UIColor(haloColor: .WhiteSmoke), forState: .Normal)
        cancelButton.titleLabel?.font = UIFont.kelson(.Regular, size: 17)

        videoContainerView.alpha = 0
        view.addGestureRecognizer(tapGesture)
    }

    private func resetView() {
        imageViewVerticalCenterConstraint.constant = 0

        textField.alpha = 0
        launchButton.alpha = 0
        borderView.alpha = 0
        cancelButton.alpha = 0
        videoContainerView.alpha = 0
    }

    private func animateElements() {
        imageViewVerticalCenterConstraint.constant = -logoImageView.frame.height / 2.5

        UIView.animateWithDuration(0.3, delay: 0.5, options: .CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            }) { (_) in
            UIView.animateWithDuration(0.3, animations: {
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

    private func showMetadataLabel() {
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: { [weak self] in
            self?.metadataLabel.alpha = 1
            }, completion: nil)
    }

    private func hideMetadataLabel(completion: () -> Void) {
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: { [weak self] in
            self?.metadataLabel.alpha = 0
        }) { (_) in
            completion()
        }
    }

    @objc private func endEditing() {
        view.endEditing(true)
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let possibleNewText = text.stringByReplacingCharactersInRange(range.rangeForString(text), withString: string)
        
        let lengthIsValid = possibleNewText.characters.count <= GamertagManager.K.maxGamertagLength
        let charactersAreValid = gamertagManager.containsGamertagCharacters(possibleNewText) || possibleNewText.isEmpty
        
        return lengthIsValid && charactersAreValid
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    
    func launchButtonTapped(sender: UIButton) {
        guard let gamertag = textField.text else { return }
        view.endEditing(true)
        showIndicator(animate: true)

        gamertagValidator.validate(gamertag, shouldSaveGamertag: true) { [weak self] (success) in
            self?.hideIndicator()

            if success {
                SpartanManager.sharedManager.saveSpartan(gamertag)
                if let changing = self?.isChangingGamertag where changing {
                    GamertagManager.sharedManager.defaultGamertagChanged()
                }
                self?.delegate?.launchViewControllerButtonTapped(sender)
                self?.textField.text = nil
            }
        }
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
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

    func showIndicator(animate animate: Bool) {
        UIView.animateWithDuration(0.3, animations: { [weak self] in
            self?.textField.alpha = 0
            self?.launchButton.alpha = 0
            self?.borderView.alpha = 0
            if let changing = self?.isChangingGamertag where changing {
                self?.cancelButton.alpha = 0
            }
            }) { [weak self] (_) in
                self?.loadingIndicator.show(animate: animate)
        }
    }

    func hideIndicator() {
        loadingIndicator.hide()
        UIView.animateWithDuration(0.3) { [weak self] in
            self?.textField.alpha = 1
            self?.launchButton.alpha = 1
            self?.borderView.alpha = 1
            if let changing = self?.isChangingGamertag where changing {
                self?.cancelButton.alpha = 1
            }
        }
    }
}

