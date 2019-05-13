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
}

class MasterViewController: UITableViewController, MasterViewControllable {

    var detailViewController: DetailViewController?
    var viewModelListener: MasterViewModelable?


    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewModel()
        self.tableView.register(UINib.init(nibName: "RedditPostTableViewCell", bundle: nil), forCellReuseIdentifier: "RedditPostTableViewCell")

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
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
//                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
//        cell.textLabel!.text = post.title
        cell.fillUI(with: post)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// Private
extension MasterViewController {
    
    private func loadViewModel() {
        viewModelListener = MasterViewModel(networkManager: NetworkManager(), viewControllerListener: self)
    }
}
