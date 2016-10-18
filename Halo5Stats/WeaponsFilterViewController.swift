//
//  WeaponsFilterViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol WeaponsFilterDelegate: class {
    func selectedFilter(option: WeaponsFilterViewModel.FilterOption)
}

class WeaponsFilterViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    let viewModel = WeaponsFilterViewModel()
    weak var delegate: WeaponsFilterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupBindAndFires()
    }

    // MARK: Private

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupBindAndFires() {
        viewModel.selectedOption.bindAndFire { [weak self] (_) in
            self?.tableView.reloadData()
        }
    }
}

extension WeaponsFilterViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let option = viewModel.options[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath)
        cell.textLabel?.text = option.rawValue
        cell.accessoryType = option == viewModel.selectedOption.value ? .Checkmark : .None

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let option = viewModel.options[indexPath.row]
        viewModel.selectedOption.value = option
        delegate?.selectedFilter(option)
    }
}
