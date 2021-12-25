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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var menuSectionCollectionView: UICollectionView!
    @IBOutlet weak var menuItemTableView: UITableView!

    // MARK: - Variables
    private var restaurantService = RestaurantManager()
    private var menu: Menus?
    
    private var selectedSectionIndexPath: IndexPath = IndexPath(item: 1, section: 0)

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRestaurantNameContainerView()
        
        setupCollectionView()
        setupTableView()

        setupRestaurantServiceDelegate()

        performFetchRequest()
    }
    
    override func viewWillLayoutSubviews() {
        let contentWidth = menuSectionCollectionView.contentSize.width
        
        menuSectionCollectionView.addTopBorder(with: UIColor(named: "DarkerGrey"), withWidth: contentWidth , andBorderWidth: 1.0)
        menuSectionCollectionView.addBottomBorder(with: UIColor(named: "DarkerGrey"), withWidth: contentWidth , andBorderWidth: 1.0)
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

//MARK: - CollectionView Delegate & Datasource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu?.menuSections?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuSectionCell", for: indexPath) as! MenuSectionCollectionViewCell

        if indexPath.row == selectedSectionIndexPath.item {
            cell.isSelected = true
            cell.menuSectionTitleLabel.textColor = UIColor(named: "ItemTitleGrey")
            cell.selectedSeparatorView.isHidden = false
        } else {
            cell.isSelected = false
            cell.menuSectionTitleLabel.textColor = UIColor(named: "DarkerGrey")
            cell.selectedSeparatorView.isHidden = true
        }
        
        cell.menuSectionTitleLabel.text = menu?.menuSections?[indexPath.row].sectionName?.uppercased()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedSectionIndexPath = indexPath

        if let cell = collectionView.cellForItem(at: indexPath) as? MenuSectionCollectionViewCell {
            cell.menuSectionTitleLabel.textColor = UIColor(named: "ItemTitleGrey")
            cell.selectedSeparatorView.isHidden = false
        }
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        menuItemTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MenuSectionCollectionViewCell {
            cell.menuSectionTitleLabel.textColor = UIColor(named: "DarkerGrey")
            cell.selectedSeparatorView.isHidden = true
        }
        
        menuItemTableView.reloadData()
    }
}

//MARK: - TableView Delegate & Datasource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menu?.menuSections?[self.selectedSectionIndexPath.row].menuItems?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemTableViewCell
        
        let item = menu?.menuSections?[self.selectedSectionIndexPath.row].menuItems?[indexPath.row]
        
        cell.menuItemNameTitleLabel.text = item?.name
        
        
        let itemDescriptionValue = item?.descriptionValue
        let itemDescription = itemDescriptionValue?.replacingOccurrences(of: "[\\[\\],+]", with: " /", options: .regularExpression, range: nil)
        
        cell.menuItemDescriptionLabel.text = itemDescription
        
        
        let itemPriceValue = item?.price
        let itemPrice = itemPriceValue?.description ?? "Please consult"
        let price = itemPrice.replacingOccurrences(of: ".0", with: "", options: .forcedOrdering, range: nil)
        
        cell.menuItemPriceLabel.text = "$ " + price
        
        return cell
    }
}

//MARK: - Web Service Delegate
extension MainViewController: RestaurantServiceDelegate {
    func didUpdateRestaurant(_ restaurantModel: Restaurant) {
        self.menu = restaurantModel.data?.first?.menus?.first

        DispatchQueue.main.async {
            self.restaurantNameLabel.text = restaurantModel.data?.first?.restaurantName
            self.menuNameLabel.text = self.menu?.menuName
            self.menuSectionCollectionView.selectItem(at: self.selectedSectionIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        
        self.activityIndicatorView.stopAnimating()
        
        self.menuSectionCollectionView.reloadData()
        self.menuSectionCollectionView.layoutSubviews()
        
        self.menuItemTableView.reloadData()
    }

    func didFailWithError(_ error: Error) {
        print(error)
    }
}
