//
//  SettingsViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var versionLabel: UILabel!

    let viewModel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupTableView()
    }

    // MARK: - Private

    private func setupAppearance() {
        navigationItem.title = "Settings"
        headerLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        versionLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        versionLabel.font = UIFont.kelson(.Light, size: 14)

        if let version = viewModel.version {
            versionLabel.text = version
        } else {
            versionLabel.hidden = true
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor(haloColor: .Cinder)
        tableView.separatorStyle = .None
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = viewModel.rows[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SettingsCell
        cell.textLabel?.text = row.name
        if row == viewModel.rows.last {
            cell.borderView.hidden = true
        }
        cell.contentView.backgroundColor = UIColor(haloColor: .Cinder).lighter(0.45)
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor(haloColor: .Cinder).lighter(0.85)
        cell.selectedBackgroundView = selectionView

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = viewModel.rows[indexPath.row]

        switch row {
        case .changeDefault:
            UIApplication.appController().applicationViewController.defaultGamertagTapped()
        case .review:
            if let url = viewModel.appReviewUrl where UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
            return
        }
    }

    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.legalText
    }

    func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.textColor = UIColor(haloColor: .WhiteSmoke)
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 200
    }
}
