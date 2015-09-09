//
//  CurrencyViewController.swift
//  Currency Conversion
//
//  Created by Ehab Saifan on 7/30/15.
//  Copyright (c) 2015 DeAnza. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    private let access_key = "499371be18afa64c248d09e73151f7de"

    var currencyStringFrom: String = "LBP"
    var currencyStringTo: String = "AED"
    var currencyDoubleFrom: Double = 0
    var currencyDoubleTo: Double = 0
    let MAX = 340282346638529000000000000000000000000.0
    var rate: Double = 0
    var timeText = ""
    var dayText = ""
    var currentrates = LiveRate(JSON: nil)
    let countries = CountryObject().getObjects()
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var countyPicker: UIPickerView!
    @IBOutlet weak var date: UILabel?
    @IBOutlet weak var refreshActivity: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        retrieveCurrentCurrencies()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return countries[row].countryAcronym
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.currencyStringFrom = countries[row].countryAcronym
        }
        else{
            self.currencyStringTo = countries[row].countryAcronym
        }
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = countries[row].countryAcronym
        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 18.0)!,NSForegroundColorAttributeName:UIColor(red: 0, green: 122/255.0, blue: 1, alpha: 1)])
        return myTitle
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color  and center the label's background
            let hue = CGFloat(row)/CGFloat(countries.count)
            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness:0.8, alpha: 0.8)
            pickerLabel.textAlignment = .Center
            
        }
        let titleData = countries[row].countryAcronym
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 18.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        pickerLabel!.attributedText = myTitle
        return pickerLabel
    }
    
    func retrieveCurrentCurrencies(){
        let currencyService = CurrenceyService(APIKey: access_key)
        currencyService.getCurrency(){
            (let liverate) in
            if let current = liverate {
                dispatch_async(dispatch_get_main_queue()) {
                    self.currentrates = current
                    let list = self.currentrates.quotesDict
                    if let fromVal = list[self.currencyStringFrom]{
                        self.currencyDoubleFrom = fromVal
                    }
                    if let toVal = list[self.currencyStringTo]{
                        self.currencyDoubleTo = toVal
                    }
                    self.rate = self.currentRate(self.currencyDoubleFrom, To: self.currencyDoubleTo)
                    if let time = current.time {
                        self.timeText = time
                    }
                    if let day = current.day {
                        self.dayText = day
                    }
                    self.date?.text = "Rates last updated on \(self.dayText) at \(self.timeText)"
                    self.toggleRefreshAnimation(false)
                }
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FullList"{
            let controller = segue.destinationViewController as! FullListTableViewController
            controller.quotesDict = self.currentrates.quotesDict
            controller.sourceCurrencyValue = self.currencyDoubleFrom
            controller.sourceCurrencyString = self.currencyStringFrom
            }
    }

    func configureView() {
        // Change the font and size of nav bar text
        if let navBarFont = UIFont(name: "HelveticaNeue", size: 20.0) {
            let navBarAttributesDictionary: [NSObject: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: navBarFont
            ]
            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
        // Center the picker view
        self.countyPicker.selectRow(self.countries.count/2, inComponent: 0, animated: false)
        self.countyPicker.selectRow(self.countries.count/2, inComponent: 1, animated: false)
    }
    
    @IBAction func refreshPressed(sender: AnyObject) {
        self.toggleRefreshAnimation(true)
        self.retrieveCurrentCurrencies()
    }
    
    func toggleRefreshAnimation(on: Bool){
        self.refreshButton.hidden = on
        if on {
            self.refreshActivity.startAnimating()
        }else{
            self.refreshActivity.stopAnimating()
        }
    }
    
    @IBAction func Calculate(sender: AnyObject) {
        let list = self.currentrates.quotesDict
        if let fromVal = list[self.currencyStringFrom]{
            self.currencyDoubleFrom = fromVal
        }
        if let toVal = list[self.currencyStringTo]{
            self.currencyDoubleTo = toVal
        }
        self.rate = self.currentRate(self.currencyDoubleFrom, To: self.currencyDoubleTo)
        let amount = amountInput.text.toDouble()! * self.rate
        self.result.text = "\(amount)"
        if let time = currentrates.time {
            self.timeText = time
        }
        if let day = currentrates.day {
            self.dayText = day
        }
        self.date?.text = "Rates last updated on \(self.dayText) at \(self.timeText)"
    }
    
    //String to Double
    func amountEntered() -> Double {
        if let amountString = amountInput.text.toDouble(){
            if amountString < self.MAX {
                return amountString
            }else if amountString > self.MAX {
                return self.MAX
            }else {
                return 0
            }
        }
        return 0
    }
    //Change rate
    func currentRate(From: Double, To: Double) -> Double {
        return (To/From)
    }

}

//Creating a toDouble method
extension String {
    func toDouble() -> Double? {
        if let value = NSNumberFormatter().numberFromString(self)?.doubleValue {
            return value
        }else{
            return 1
        }
    }
}

