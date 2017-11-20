//
//  DataFetch.swift
//  movieapp
//
//  Created by preetha on 20/10/16.
//  Copyright © 2016 preetha. All rights reserved.
//

import UIKit
import Alamofire

class DataFetch {
    
    
    static var identifier = 0
    static var tempmovieid:Int = 0

    func getJSONData(completionHandler: (NSDictionary?, NSError?) -> ()){
        
        
        var requestURL: NSURL
        requestURL=NSURL()
        print(DataFetch.identifier)
        if DataFetch.identifier == 1{
      
            requestURL = NSURL(string: "http://api.themoviedb.org/3/movie/popular?api_key=00729d272a018e2277f8cab26d2c198c")!
            
        }else if DataFetch.identifier == 2{
     
            requestURL = NSURL(string: "http://api.themoviedb.org/3/movie/top_rated?api_key=00729d272a018e2277f8cab26d2c198c")!
          
            
        }else if DataFetch.identifier == 3{
            
            let url="http://api.themoviedb.org/3/movie/"
            let urlapi="/videos?api_key=00729d272a018e2277f8cab26d2c198c&language=en-US"
            let movieidstring = "\(DataFetch.tempmovieid)"
            let finalurl=url+movieidstring+urlapi
            requestURL = NSURL(string: finalurl)!
            
        }else if DataFetch.identifier == 4{
       
            let url="http://api.themoviedb.org/3/movie/"
            let urlapi="/reviews?api_key=00729d272a018e2277f8cab26d2c198c&language=en-US"
            let movieidstring = "\(DataFetch.tempmovieid)"
            let finalurl=url+movieidstring+urlapi
             requestURL = NSURL(string: finalurl)!
            
        }
        print(requestURL)
        self.fetchFromURL(requestURL,completionHandler: completionHandler)
        
    }
    
    
    func  fetchFromURL(requestURL: NSURL, completionHandler: (NSDictionary?, NSError?) -> ()){
        
        Alamofire.request(.GET, requestURL).responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                    let response = JSON as! NSDictionary
                    completionHandler(response , nil)
                
            case .Failure(let error):

                print("Request failed with error: \(error)")
                completionHandler(nil, error)
                }
            }
        
    }
    
    
}
