//
//  MainViewController.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var menuNameLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Variables
    let defaultRestaurant: String = "4072702673999819"
    var restaurantService = RestaurantManager()

    var restaurant: Restaurant?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupTableView()

        setupRestaurantServiceDelegate()

        performFetchRequest()
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setupRestaurantServiceDelegate() {
        restaurantService.delegate = self
    }

    func performFetchRequest() {
        restaurantService.fetchRestaurantData(lat: "42.361145", lon: "-71.057083")
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuSectionCell", for: indexPath) as! MenuSectionCollectionViewCell

        cell.menuSectionTitleLabel.text = ""

        return cell
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemTableViewCell

        return cell
    }
}

extension MainViewController: RestaurantServiceDelegate {
    func didUpdateRestaurant(_ restaurantModel: Restaurant) {
        self.restaurant = restaurantModel

        let menu = restaurant?.data?.first?.menus?.first

        DispatchQueue.main.async {
            self.restaurantNameLabel.text = restaurantModel.data?.first?.restaurantName
            self.menuNameLabel.text = menu?.menuName

            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }

    func didFailWithError(_ error: Error) {
        print(error)
    }
}
