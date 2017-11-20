//
//  FavouritesCollectionViewController.swift
//  movieapp
//
//  Created by preetha on 10/10/16.
//  Copyright © 2016 preetha. All rights reserved.
//

import UIKit

class FavouritesCollectionViewController: UICollectionViewController {
    
    
    @IBOutlet var FavouriteCollectionView: UICollectionView!
    
    private let reuseIdentifier = "FavouritesCell"
    let imageURL="http://image.tmdb.org/t/p/w500/"
    let progressIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    let label = UILabel()
    static var loaded=0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Favourites"
        progressIndicator.backgroundColor = UIColor(white: 0, alpha: 1)
        self.view.addSubview(progressIndicator)
        progressIndicator.frame = self.view.frame
        progressIndicator.startAnimating()
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.progressIndicator.stopAnimating()
            })
        })
        FavouritesCollectionViewController.loaded=1
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("vvv")
        if FavouritesCollectionViewController.loaded==1{
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            self.FavouriteCollectionView.reloadData()
        } else {
            self.FavouriteCollectionView.reloadData()
        }
        }
    }
    override func viewWillAppear(animated: Bool) {
        
        self.FavouriteCollectionView.reloadData()
        self.navigationController?.navigationBar.topItem?.title = "Favourites"
        label.textAlignment = NSTextAlignment.Center
        label.text = "No Favourites"
        label.textColor=UIColor.whiteColor()
        label.frame=self.view.frame
        self.view.addSubview(label)
        var favMovieListArray = [MovieData]()
        var count=0
        let decoded  = defaults.objectForKey("favMovieList") as? NSData
        if decoded != nil{
            favMovieListArray = (NSKeyedUnarchiver.unarchiveObjectWithData(decoded!) as? [MovieData])!
        }
        count=favMovieListArray.count
        if(count==0){
            label.hidden=false
        }
        else{
            label.hidden=true
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var favMovieListArray = [MovieData]()
        let decoded  = defaults.objectForKey("favMovieList") as? NSData
        if decoded != nil{
            print("aaa")
            favMovieListArray = (NSKeyedUnarchiver.unarchiveObjectWithData(decoded!) as? [MovieData])!
        }
        let count=favMovieListArray.count
        return count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageViewCell
        let decoded  = defaults.objectForKey("favMovieList") as! NSData
        let favMovieListArray = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as! [MovieData]
        let tempImagePath=favMovieListArray[indexPath.row].imageData as String
        let tempURL=self.imageURL+tempImagePath
        let tempUrl=NSURL(string: tempURL)
        cell.userFavImageVar.kf_setImageWithURL(tempUrl!,placeholderImage: nil)
        cell.alpha = 0.3
        UIView.animateWithDuration(1, animations: {
            cell.alpha = 1
            
        })
        return cell
        
    }
    
    // MARK: UICollectionViewDelegate
      override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let nextScene = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        let decoded  = defaults.objectForKey("favMovieList") as! NSData
        let favMovieListArray = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as! [MovieData]
        nextScene.movieObject=favMovieListArray[indexPath.row] as MovieData
                self.navigationController!.pushViewController(nextScene, animated: true)
        
    }
    
    func collectionView(collctionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
                let screenSize = UIScreen.mainScreen().bounds
                let screenWidth = screenSize.width
                let cellSquareSize: CGFloat = screenWidth / 2.0
                return CGSizeMake(cellSquareSize-5, cellSquareSize-5)
    }
    
    
}

