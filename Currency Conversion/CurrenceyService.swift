//
//  CurrenceyService.swift
//  Currency Conversion
//
//  Created by Ehab Saifan on 8/15/15.
//  Copyright (c) 2015 DeAnza. All rights reserved.
//

import Foundation

struct CurrenceyService {
    
    let CurrencyConversionAPIKey: String
    let CurrencyConversionBaseURL: NSURL?
    
    init(APIKey: String) {
        CurrencyConversionAPIKey = APIKey
        CurrencyConversionBaseURL = NSURL(string: "http://apilayer.net/api/live?access_key=\(CurrencyConversionAPIKey)&format=1")
    }
    
    func getCurrency(completion: (LiveRate? -> Void)) {
        if let currencyURL = CurrencyConversionBaseURL {
            let networkOperation = NetworkOperation(url: currencyURL)
            networkOperation.downloadJSONFromURL {
                (let JSONDictionary) in
                let liverate = LiveRate(JSON: JSONDictionary)
                completion(liverate)
                println(JSONDictionary)
            }
        }//End if
        else {
            println("Could not construct a valid URL")
        }//End else
    }//End getCurrency
}//End CurrenceyService