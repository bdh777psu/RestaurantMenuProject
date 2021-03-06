//
//  MainViewController.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import CoreLocation
import UIKit

class MainViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var restaurantSelectionButton: UIButton!
    @IBOutlet weak var restaurantPickerView: UIPickerView!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var menuSectionCollectionView: UICollectionView!
    @IBOutlet weak var menuItemTableView: UITableView!

    // MARK: - Variables
    private var restaurantService = RestaurantManager()
    private var restaurant: Restaurant?
    
    private var selectedMenuSectionIndexPath: IndexPath = IndexPath(item: 1, section: 0)
    
    var selectedRestaurantIndex: Int = 0
    
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
        
        setupRestaurantSelectionButton()
        setupRestaurantPickerView()
        
        setupCollectionView()
        setupTableView()

        setupRestaurantServiceDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performFetchRequest()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let contentWidth = menuSectionCollectionView.contentSize.width
        
        menuSectionCollectionView.addTopBorder(with: UIColor(named: "DarkerGrey"), withWidth: contentWidth , andBorderWidth: 1.0)
        menuSectionCollectionView.addBottomBorder(with: UIColor(named: "DarkerGrey"), withWidth: contentWidth , andBorderWidth: 1.0)
        
        menuSectionCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: Setups
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    func setupRestaurantSelectionButton() {
        restaurantSelectionButton.layer.borderWidth = 1.0
        restaurantSelectionButton.layer.borderColor = UIColor(named: "DarkerGrey")?.cgColor
    }
    
    func setupRestaurantPickerView() {
        restaurantPickerView.delegate = self
        restaurantPickerView.dataSource = self
        
        restaurantPickerView.isHidden = true
    }
    
    func setupCollectionView() {
        menuSectionCollectionView.delegate = self
        menuSectionCollectionView.dataSource = self
        
        let nib = UINib(nibName: "MenuSectionCollectionViewCell", bundle: nil)
        menuSectionCollectionView.register(nib, forCellWithReuseIdentifier: "MenuSectionCell")

        if let flowLayout = menuSectionCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    func setupTableView() {
        menuItemTableView.delegate = self
        menuItemTableView.dataSource = self
        
        let nib = UINib(nibName: "MenuItemTableViewCell", bundle: nil)
        menuItemTableView.register(nib, forCellReuseIdentifier: "MenuItemCell")
    }

    //MARK: Networking
    func setupRestaurantServiceDelegate() {
        restaurantService.delegate = self
    }

    func performFetchRequest() {
        activityIndicatorView.startAnimating()
        
        restaurantService.fetchRestaurantData(lat: location?.latitude.description ?? "42.361145", lon: location?.longitude.description ?? "-71.057083")
    }
    
    //MARK: - Actions
    @IBAction func restaurantSelectionButtonClicked(_ sender: UIButton) {
        restaurantPickerView.isHidden = false
    }
}

//MARK: - LocationManager Delegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.location = location
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
}

//MARK: - PickerView Delegate & Datasource
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        restaurant?.data?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return restaurant?.data?[row].restaurantName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        restaurantPickerView.isHidden = true
        
        self.selectedRestaurantIndex = row
        
        performFetchRequest()
    }
}

//MARK: - CollectionView Delegate & Datasource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let menuSections = self.restaurant?.data?[self.selectedRestaurantIndex].menus?.first?.menuSections
        return menuSections?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuSectionCell", for: indexPath) as! MenuSectionCollectionViewCell

        if indexPath.row == selectedMenuSectionIndexPath.item {
            cell.isSelected = true
            cell.menuSectionTitleLabel.textColor = UIColor(named: "ItemTitleGrey")
            cell.selectedSeparatorView.isHidden = false
        } else {
            cell.isSelected = false
            cell.menuSectionTitleLabel.textColor = UIColor(named: "DarkerGrey")
            cell.selectedSeparatorView.isHidden = true
        }
        
        let sectionName = self.restaurant?.data?[self.selectedRestaurantIndex].menus?.first?.menuSections?[indexPath.row].sectionName
        cell.menuSectionTitleLabel.text = sectionName?.uppercased()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedMenuSectionIndexPath = indexPath

        if let cell = collectionView.cellForItem(at: indexPath) as? MenuSectionCollectionViewCell {
            cell.menuSectionTitleLabel.textColor = UIColor(named: "ItemTitleGrey")
            cell.selectedSeparatorView.isHidden = false
        }
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        menuItemTableView.reloadData()
        menuItemTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
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
        let menuItems = self.restaurant?.data?[self.selectedRestaurantIndex].menus?.first?.menuSections?[self.selectedMenuSectionIndexPath.row].menuItems
        return menuItems?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemTableViewCell
        
        let item =  self.restaurant?.data?[self.selectedRestaurantIndex].menus?.first?.menuSections?[self.selectedMenuSectionIndexPath.row].menuItems?[indexPath.row]
        
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
        self.restaurant = restaurantModel

        updateUI()
        
        self.activityIndicatorView.stopAnimating()

        self.restaurantPickerView.reloadAllComponents()

        self.menuSectionCollectionView.reloadData()
        self.menuSectionCollectionView.layoutSubviews()
        
        self.menuItemTableView.reloadData()
        
        self.menuSectionCollectionView.selectItem(at: self.selectedMenuSectionIndexPath, animated: false, scrollPosition: .centeredHorizontally)
    }

    func didFailWithError(_ error: Error) {
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func updateUI() {
        DispatchQueue.main.async {
            let restaurantName = self.restaurant?.data?[self.selectedRestaurantIndex].restaurantName
            self.restaurantSelectionButton.setTitle(restaurantName, for: .normal)
            
            let menuName =  self.restaurant?.data?[self.selectedRestaurantIndex].menus?.first?.menuName
            self.menuNameLabel.text = menuName
        }
    }
}
