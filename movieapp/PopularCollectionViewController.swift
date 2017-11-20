//
//  PopularCollectionViewController.swift
//  movieapp
//
//  Created by preetha on 29/09/16.
//  Copyright © 2016 preetha. All rights reserved.
//

import UIKit
import Kingfisher

let defaults = NSUserDefaults.standardUserDefaults()

class PopularCollectionViewController: UICollectionViewController {
  
   
    @IBOutlet var popularMovieCollectionView: UICollectionView!
   
    let imageURL="http://image.tmdb.org/t/p/w500/"
    var moviecount: Int = 0
    private let reuseIdentifier = "Cell"
    let progressIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    var movieDataArray = [MovieData]()
    let label = UILabel()
    var emptyJSONresponse=1
    var checkConnectivityFlag=0
    static var loaded = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Popular"
        progressIndicator.backgroundColor = UIColor(white: 0, alpha: 1)
        self.view.addSubview(progressIndicator)
        progressIndicator.frame = self.view.frame
        progressIndicator.startAnimating()
        PopularCollectionViewController.loaded=1
        
        }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Popular"
        if emptyJSONresponse==1{
            
            progressIndicator.backgroundColor = UIColor(white: 0, alpha: 1)
            self.view.addSubview(progressIndicator)
            progressIndicator.frame = self.view.frame
            progressIndicator.startAnimating()
            self.checkConnectivityAndGetData()

                    }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("ttt")
        if PopularCollectionViewController.loaded==1{
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
                self.popularMovieCollectionView.reloadData()
        } else {
                self.popularMovieCollectionView.reloadData()
        }
        }
    }
    
    func checkConnectivityAndGetData()
    {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            self.checkConnectivityFlag=1
            Reachability.alertShown=0
            
        } else {
            
            print("Internet connection FAILED")
            if Reachability.alertShown==0{
                let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
           
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("OK")
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            self.checkConnectivityFlag=0
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.progressIndicator.stopAnimating()
                })
            })
            
            self.label.textAlignment = NSTextAlignment.Center
            self.label.text = "Internet Connection Problem"
            self.label.textColor=UIColor.whiteColor()
            self.label.frame=self.view.frame
            self.view.addSubview(self.label)
            self.label.hidden=false
            emptyJSONresponse=1
            Reachability.alertShown=1
            
        }
        
        if self.checkConnectivityFlag==1{
            let tempDataObject=DataFetch()
            DataFetch.identifier=1
            tempDataObject.getJSONData() { responseObject, error in
            //print("responseObject = \(responseObject); error = \(error)")
                if responseObject != nil{
                    self.parseData(responseObject!)
                    self.label.hidden=true
                    self.emptyJSONresponse=0
                }
                else{
                
                    let qualityOfServiceClass = QOS_CLASS_BACKGROUND
                    let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                    dispatch_async(backgroundQueue, {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.progressIndicator.stopAnimating()
                        })
                    })
                    self.label.textAlignment = NSTextAlignment.Center
                    self.label.text = "Data unavailable"
                    self.label.textColor=UIColor.whiteColor()
                    self.label.frame=self.view.frame
                    self.view.addSubview(self.label)
                    self.label.hidden=false
                    self.emptyJSONresponse=1
                }
                return
            }
        
        }
 
        
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return moviecount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageViewCell
        let tempBackdropPath=self.movieDataArray[indexPath.row].imageData as String
        let tempURL=self.imageURL+tempBackdropPath
        let tempUrl=NSURL(string: tempURL)
        cell.imageVar.kf_setImageWithURL(tempUrl!,placeholderImage: nil)
        cell.alpha = 0.3
        UIView.animateWithDuration(1, animations: {
            cell.alpha = 1
            
        })
        return cell
        
    }
    
  
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
            let nextScene = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
            nextScene.movieObject=self.movieDataArray[indexPath.row]
            self.navigationController!.pushViewController(nextScene, animated: true)
    
    }
    
    
    func collectionView(collctionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let cellSquareSize: CGFloat = screenWidth / 2.0
        return CGSizeMake(cellSquareSize-5, cellSquareSize-5)
        
    }
    
    

    func parseData(data: NSDictionary)
    {
        
        let results = data["results"] as? [[String: AnyObject]]
        var titleData=""
        var imageData=""
        var releaseData=""
        var overviewData=""
        var movieidData=0
        for movie in results!{
                if let title = movie["title"] as? String {
                    titleData = title
                
                }
                if let imagePath = movie["backdrop_path"] as? String {
                    imageData = imagePath
                   
                }
                if let releaseDate = movie["release_date"] as? String {
                    releaseData = releaseDate
                    
                }
                if let overview = movie["overview"] as? String {
                    overviewData = overview
                    
                }
                if let movieid = movie["id"] as? Int {
                    movieidData = movieid
                }
            
                moviecount+=1
                movieDataArray.append(MovieData(image: "\(imageData)", title: "\(titleData)", release: "\(releaseData)", overview: "\(overviewData)", movieid: movieidData))
                             
        }
        dispatch_async(dispatch_get_main_queue()){
          self.popularMovieCollectionView.reloadData()
        }
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.progressIndicator.stopAnimating()
            })
        })

    }
   
  
}






