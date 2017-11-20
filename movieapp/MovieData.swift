//
//  MovieData.swift
//  movieapp
//
//  Created by preetha on 21/10/16.
//  Copyright © 2016 preetha. All rights reserved.
//

import UIKit

class MovieData: NSObject,NSCoding{
    
    var imageData: String = ""
    var titleData: String = ""
    var releaseData: String = ""
    var overviewData: String = ""
    var movieidData: Int = 0
    var trailers = [[String]]()
    var reviews = [[String]]()
    
    override init() {
        super.init()
        
    }
    init (image: String?, title: String?, release: String?, overview: String?, movieid: Int?) {
        
        if let aimage = image{
            self.imageData = aimage
        }
        if let atitle = title{
            self.titleData = atitle
        }
        if let arelease = release{
            self.releaseData = arelease
        }
        
        if let overvi = overview{
            self.overviewData = overvi
        }
        if let amovie = movieid{
            self.movieidData = amovie
        }
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let titleData = aDecoder.decodeObjectForKey("titleData") as? String
        let imageData = aDecoder.decodeObjectForKey("imageData") as? String
        let releaseData = aDecoder.decodeObjectForKey("releaseData") as? String
        let overviewData = aDecoder.decodeObjectForKey("overviewData") as? String
        let movieidData = aDecoder.decodeIntegerForKey("movieidData")
        self.init(image: imageData, title: titleData, release: releaseData, overview: overviewData, movieid: movieidData)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(imageData, forKey: "imageData")
        aCoder.encodeObject(titleData, forKey: "titleData")
        aCoder.encodeObject(releaseData, forKey: "releaseData")
        aCoder.encodeObject(overviewData, forKey: "overviewData")
        aCoder.encodeInteger(movieidData, forKey: "movieidData")
        
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        if object?.titleData == titleData{
            return true
        }
        return false
        
    }
    
}



