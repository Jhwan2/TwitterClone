//
//  ExploerController.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/02.
//

import UIKit

private let reuseIdentifier = "UserCell"

class ExploerController: UITableViewController {
    
    //MARK: Properties
    private var users = [User]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var filteredUsers = [User]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
        configureSearchController()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: API
    func fetchUser() {
        UserService.shard.fetchUser { users in
            self.users = users
            
        }
    }
    
    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        
        navigationItem.title = "Exploer"
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a User"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }

}


//MARK: TableViewDataSource
extension ExploerController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: UISearchResultsUpdating
extension ExploerController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter({ $0.username.contains(searchText) })
    }
}
