//
//  MasterViewController.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 11/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import UIKit

protocol MasterViewControllable: class {
    func reloadTable()
    func beginUpdates()
    func endUpdates()
    func updateCellFor(indexPath: IndexPath)
    func deleteCellFor(indexPath: IndexPath)
}

class MasterViewController: UITableViewController, MasterViewControllable {

    var detailViewController: DetailViewController?
    var viewModelListener: MasterViewModelable?


    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewModel()
        self.tableView.register(UINib.init(nibName: "RedditPostTableViewCell", bundle: nil), forCellReuseIdentifier: "RedditPostTableViewCell")

        if let split = splitViewController {
            splitViewController?.preferredDisplayMode = .allVisible
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        tableView.refreshControl?.addTarget(self, action: #selector(refreshPostRedditData), for: .valueChanged)
        viewModelListener?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                let detailViewModel = viewModelListener?.getViewModelListener(viewController: controller, postFromRow: indexPath.row)
                controller.viewModelListener = detailViewModel
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
    }
    
    @objc func refreshPostRedditData() {
        viewModelListener?.refreshData()
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func beginUpdates() {
        tableView.beginUpdates()
    }
    
    func endUpdates() {
        tableView.endUpdates()
    }
    
    func updateCellFor(indexPath: IndexPath) {
        if indexPath.row < viewModelListener?.numberOfPosts() ?? 0
        {
            guard let cell = tableView.cellForRow(at: indexPath) as? RedditPostTableViewCell else { return }
            guard let post = viewModelListener?.postFor(row: indexPath.row) else { return }
            cell.fillUI(with: post)
        }
    }
    
    func deleteCellFor(indexPath: IndexPath) {
        updateDetailViewWithoutCellSelection(indexPath: indexPath)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func updateDetailViewWithoutCellSelection(indexPath: IndexPath) {
        if indexPath == tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            performSegue(withIdentifier: "showDetail", sender: nil)
        }
    }
    @IBAction func dismissAllButtonPressed(_ sender: Any) {
        viewModelListener?.dismissAllPosts()
    }
}

// Table data source
extension MasterViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelListener?.numberOfPosts() ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedditPostTableViewCell", for: indexPath) as! RedditPostTableViewCell
        guard let post = viewModelListener?.postFor(row: indexPath.row) else { return UITableViewCell() }
        cell.delegate = self
        cell.fillUI(with: post)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
}

// Private
extension MasterViewController {
    
    private func loadViewModel() {
        viewModelListener = MasterViewModel(networkManager: NetworkManager(), viewControllerListener: self, coreDataManager: CoreDataManager())
    }
}

extension MasterViewController: RedditPostTableViewCellDelegate {
    func deletePost(sender: UIButton) {
        let point = tableView.convert(CGPoint(x: sender.bounds.midX, y: sender.bounds.midY), from: sender)
        if let indexPath = tableView.indexPathForRow(at: point) {
            viewModelListener?.deletePostFrom(row: indexPath.row)
        }
    }
}
