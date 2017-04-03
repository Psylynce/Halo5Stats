//
//  WeaponsFilterViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol WeaponsFilterDelegate: class {
    func selectedFilter(_ option: WeaponsFilterViewModel.FilterOption)
}

class WeaponsFilterViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    let viewModel = WeaponsFilterViewModel()
    weak var delegate: WeaponsFilterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupBindAndFires()
        popoverPresentationController?.backgroundColor = .elephant
    }

    // MARK: Private

    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .elephant
    }

    fileprivate func setupBindAndFires() {
        viewModel.selectedOption.bindAndFire { [weak self] (_) in
            self?.tableView.reloadData()
        }
    }
}

extension WeaponsFilterViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = viewModel.options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)

        cell.textLabel?.text = option.rawValue
        cell.textLabel?.font = UIFont.kelson(.Regular, size: 14)
        cell.textLabel?.textColor = .whiteSmoke
        cell.accessoryType = option == viewModel.selectedOption.value ? .checkmark : .none
        cell.tintColor = .whiteSmoke
        cell.backgroundColor = indexPath.row % 2 == 0 ? .elephant : .cinder

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        viewModel.selectedOption.value = option
        delegate?.selectedFilter(option)
    }
}
