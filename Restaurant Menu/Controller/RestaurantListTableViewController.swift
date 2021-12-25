//
//  RestaurantListTableViewController.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 25/12/21.
//

import UIKit

class RestaurantListTableViewController: UITableViewController {
    
    //MARK: - Variables
    var restaurant: [Data]?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)
        
        cell.textLabel?.text = restaurant?[indexPath.row].restaurantName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigationController?.popViewController(animated: true)
    }
}
