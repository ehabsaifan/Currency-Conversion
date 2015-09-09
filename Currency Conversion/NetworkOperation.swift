//
//  NetworkOperation.swift
//  Currency Conversion
//
//  Created by Ehab Saifan on 8/15/15.
//  Copyright (c) 2015 DeAnza. All rights reserved.
//
//*****************************
//  This class to create a network session and get the JSON object ready to be used
//*****************************

import Foundation

class NetworkOperation {
    //Configur behavior and policies to use when uploading and downloading data such as timeout values, caching policies, connection requirements, and other types of information that you intend to use with your NSURLSession object.
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    //Provide an API for downloading content via HTTP. It supports authentication and gives your app the ability to perform background downloads when your app is not running or, in iOS, while your app is suspended.
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    
    let queryURL: NSURL
    
    //Function takes [String: AnyObject]? -> Void
    typealias JSONDictionaryCompletion = ([String: AnyObject]? -> Void)
    var Etag: String? = ""
    var Date: String? = ""
    var headerDict:[String:String]? = ["":""]
    
    //Initiate the class with the needed URL
    init(url: NSURL) {
        self.queryURL = url
    }
    
    //Pass the completion function as a parameter to this function
    func downloadJSONFromURL(completion: JSONDictionaryCompletion){
        //request is an object that provides request-specific information such as the URL, cache policy, request type, and body data or body stream
        self.load()
        let request = NSMutableURLRequest(URL: self.queryURL)
        if let lastModified = self.Date{
            request.addValue(lastModified, forHTTPHeaderField: "Date")
        }
        if let lastEtag = self.Etag{
            request.addValue(lastEtag, forHTTPHeaderField: "Etag")
        }

//        self.headerDict["Date"] = self.Date
//        self.headerDict["Etag"] = self.Etag

        request.allHTTPHeaderFields = self.headerDict!
        println("\(request.allHTTPHeaderFields)")
        //Create an HTTP request based on the specified URL request object.
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            //1. Check HTTP response for successful GET request
            if let httpResponse = response as? NSHTTPURLResponse {
                
                switch httpResponse.statusCode {
                case 200:
                    //2. Create JSON object with data
                    if let etag = httpResponse.allHeaderFields["Etag"] as? String{
                        self.Etag = etag
                    }
                    if let date = httpResponse.allHeaderFields["Date"] as? String{
                        self.Date = date
                    }
                    println(httpResponse.allHeaderFields)
                    self.headerDict = httpResponse.allHeaderFields as? [String:String]
                    self.save()
                    let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject]

                    //Pass the Json object to the completion function
                    completion(jsonDictionary)
                default:
                    println("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                }//End switch statement
            }//End if
            else {
                println("Error: Not a valid HTTP response.")
            }//End else
        }
        dataTask.resume()
    }//End downloadJSONFromURL
    
    private func save(){
        NSUserDefaults.standardUserDefaults().setObject(self.Date, forKey: "Date")
        NSUserDefaults.standardUserDefaults().setObject(self.Etag, forKey: "Etag")
        NSUserDefaults.standardUserDefaults().setObject(self.headerDict, forKey: "headerDict")

    }
    
    private func load(){
        self.Date = (NSUserDefaults.standardUserDefaults().objectForKey("Date") as? String)!
        self.Etag = (NSUserDefaults.standardUserDefaults().objectForKey("Etag") as? String)!
        self.headerDict = (NSUserDefaults.standardUserDefaults().objectForKey("headerDict") as? [String:String])
    }
}//End NewtworkOperation class
