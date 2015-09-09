//
//  LiveRate.swift
//  Currency Conversion
//
//  Created by Ehab Saifan on 8/23/15.
//  Copyright (c) 2015 DeAnza. All rights reserved.
//

import Foundation
import UIKit

struct LiveRate {
    
    let countriesList = ["AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTC", "BTN", "BWP", "BYR", "BZD", "CAD", "CDF", "CHF", "CLF", "CLP", "CNY", "COP", "CRC", "CUC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EEK", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "GBP", "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LTL", "LVL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRO", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLL", "SOS", "SRD", "STD", "SVC", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VEF", "VND", "VUV", "WST", "XAF", "XAG", "XAU", "XCD", "XDR", "XOF", "XPF", "YER", "ZAR", "ZMK", "ZMW", "ZWL"]
    
    var quotesDict = [String: Double]()
    var success: Bool? = false
    var terms: String? = ""
    var privacy: String? = ""
    var timestamp: Double? = 0
    var source: String? = "USD"
    var quotes: [String : AnyObject] = ["": ""]
    var time: String?
    var day: String?
    
    init(JSON: [String: AnyObject]?) {
        if let currentRate = JSON {
            self.success = currentRate["success"] as? Bool
            self.terms = currentRate["terms"] as? String
            self.privacy = currentRate["privacy"] as? String
            self.timestamp = currentRate["timestamp"] as? Double
            self.source = currentRate["source"] as? String
            
            if let currentQuotes: AnyObject = currentRate["quotes"]{
                self.quotes = currentQuotes as! [String : AnyObject]
                for country in countriesList {
                    if let Value: AnyObject = quotes["USD\(country)"]{
                        self.quotesDict[country] = Value as? Double
                    }else{
                        self.quotesDict[country] = 0
                    }
                }
            }//End if
            
            self.time = timeStringFromUnixTime(self.timestamp!)
            self.day = dayStringFromTime(self.timestamp!)
            println("Time: \(self.time)")
        }
    }//End init

    func timeStringFromUnixTime(unixTime: Double) -> String {
        let dateFormatter = NSDateFormatter()
        let date = NSDate(timeIntervalSince1970: unixTime)
        
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func dayStringFromTime(unixTime: Double) -> String {
        let dateFormatter = NSDateFormatter()
        let date = NSDate(timeIntervalSince1970: unixTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
}