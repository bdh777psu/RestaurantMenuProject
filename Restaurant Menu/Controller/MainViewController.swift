//
//  MainViewController.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var restaurantNameContainerView: UIView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var menuNameLabel: UILabel!

    @IBOutlet weak var menuSectionCollectionView: UICollectionView!
    @IBOutlet weak var menuItemTableView: UITableView!

    // MARK: - Variables
    var restaurantService = RestaurantManager()
    var restaurant: Restaurant?
    var menu: Menus?
    
    var defaultSection: Int = 1
    var selectedSectionIndexPath: IndexPath?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRestaurantNameContainerView()
        
        setupCollectionView()
        setupTableView()

        setupRestaurantServiceDelegate()

        performFetchRequest()
    }
    
    func setupRestaurantNameContainerView() {
        restaurantNameContainerView.layer.borderWidth = 1.0
        restaurantNameContainerView.layer.borderColor = UIColor(named: "DarkerGrey")?.cgColor
    }

    func setupCollectionView() {
        menuSectionCollectionView.delegate = self
        menuSectionCollectionView.dataSource = self
        
        let nib = UINib(nibName: "MenuSectionCollectionViewCell", bundle: nil)
        menuSectionCollectionView.register(nib, forCellWithReuseIdentifier: "MenuSectionCell")
        
        menuSectionCollectionView.selectItem(at: selectedSectionIndexPath, animated: false, scrollPosition: .centeredHorizontally)
    }

    func setupTableView() {
        menuItemTableView.delegate = self
        menuItemTableView.dataSource = self
        
        let nib = UINib(nibName: "MenuItemTableViewCell", bundle: nil)
        menuItemTableView.register(nib, forCellReuseIdentifier: "MenuItemCell")
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
        return menu?.menuSections?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuSectionCell", for: indexPath) as! MenuSectionCollectionViewCell

        if indexPath.row == defaultSection {
            selectedSectionIndexPath = indexPath
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        cell.menuSectionTitleLabel.text = menu?.menuSections?[indexPath.row].sectionName?.uppercased()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedSectionIndexPath = indexPath

        if let cell = collectionView.cellForItem(at: indexPath) as? MenuSectionCollectionViewCell {
            cell.selectedSeparatorView.isHidden = false
        }
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        menuItemTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MenuSectionCollectionViewCell {
            cell.selectedSeparatorView.isHidden = true
        }
        
        menuItemTableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menu?.menuSections?[self.selectedSectionIndexPath?.row ?? 1].menuItems?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemTableViewCell
        
        let item = menu?.menuSections?[self.selectedSectionIndexPath?.row ?? 1].menuItems?[indexPath.row]

        cell.menuItemNameTitleLabel.text = item?.name
        cell.menuItemDescriptionLabel.text = item?.descriptionValue?.replacingOccurrences(of: "[\\[\\],+]", with: " /", options: .regularExpression, range: nil)
        cell.menuItemPriceLabel.text = "$ " + (item?.price?.description ?? "Please consult")
        
        return cell
    }
}

extension MainViewController: RestaurantServiceDelegate {
    func didUpdateRestaurant(_ restaurantModel: Restaurant) {
        self.restaurant = restaurantModel
        self.menu = restaurant?.data?.first?.menus?.first

        DispatchQueue.main.async {
            self.restaurantNameLabel.text = self.restaurant?.data?.first?.restaurantName
            self.menuNameLabel.text = self.menu?.menuName
        }
        
        self.menuSectionCollectionView.reloadData()
        self.menuItemTableView.reloadData()
    }

    func didFailWithError(_ error: Error) {
        print(error)
    }
}
