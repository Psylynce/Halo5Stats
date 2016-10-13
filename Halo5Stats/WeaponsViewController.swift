//
//  WeaponsViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class WeaponsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!

    var viewModel: WeaponsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    // MARK: Private

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension WeaponsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weapons.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let weapon = viewModel.weapons[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("WeaponCell", forIndexPath: indexPath)
        cell.textLabel?.text = weapon.name
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = StoryboardScene.Weapons.weaponStatsDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
