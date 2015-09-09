//
//  FullListTableViewController.swift
//  Currency Conversion
//
//  Created by Ehab Saifan on 8/25/15.
//  Copyright (c) 2015 DeAnza. All rights reserved.
//

import UIKit

class FullListTableViewController: UITableViewController {
    
    let currentrates = LiveRate(JSON: nil)
    let countriesObj = CountryObject().getObjects()
    let countriesDict = CountryObject().countriesDict
    var ratesList:[Double] = []
    var quotesDict:[String:Double] = [:] {
        didSet{
            self.configureRates()
        }
    }
    var sourceCurrencyString: String = ""
    var sourceCurrencyValue: Double = 0 {
        didSet{
            self.configureRates()        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return countriesObj.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CountryCell", forIndexPath: indexPath) as! FullListTableViewCell
        cell.countryLabel.text = "\(self.countriesObj[indexPath.row].countryAcronym), \(self.countriesObj[indexPath.row].countryName )"
        cell.rateLabel.text = "\(ratesList[indexPath.row])"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let countryName = countriesDict[sourceCurrencyString]{
            return "\(sourceCurrencyString), \(countryName)"
        }
        return "\(sourceCurrencyString)"
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView{
            headerView.textLabel.textColor = UIColor.whiteColor()
            headerView.textLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
            headerView.textLabel.textAlignment = .Center
            headerView.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        }
    }
    
    func configureView(){
        // Configure nav bar back button
        if let buttonFont = UIFont(name: "HelveticaNeue", size: 20.0) {
            let barButtonAttributesDictionary: [NSObject: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: buttonFont
            ]
            UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributesDictionary, forState: .Normal)
        }
    }
    

    func configureRates(){
        self.ratesList = []
        for value in self.quotesDict.values{
            self.ratesList.append(currentRate(self.sourceCurrencyValue, To: value))
        }
        self.tableView.reloadData()
    }
    
    func currentRate(From: Double, To: Double) -> Double {
        return (To/From)
    }

}
