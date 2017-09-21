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

    fileprivate func setupAppearance() {
        navigationItem.title = "Settings"
        headerLabel.textColor = .whiteSmoke
        versionLabel.textColor = .whiteSmoke
        versionLabel.font = UIFont.kelson(.Light, size: 14)

        if let version = viewModel.version {
            versionLabel.text = version
        } else {
            versionLabel.isHidden = true
        }
    }

    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundView = nil
        tableView.backgroundColor = .cinder
        tableView.separatorStyle = .none
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = viewModel.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingsCell
        cell.textLabel?.text = row.name
        if row == viewModel.rows.last {
            cell.borderView.isHidden = true
        }
        cell.contentView.backgroundColor = UIColor.cinder.lighter(0.45)
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor.cinder.lighter(0.85)
        cell.selectedBackgroundView = selectionView

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = viewModel.rows[indexPath.row]

        switch row {
        case .changeDefault:
            UIApplication.appDelegate.applicationViewController.defaultGamertagTapped()
        }
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.legalText
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.textColor = .whiteSmoke
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 200
    }
}
