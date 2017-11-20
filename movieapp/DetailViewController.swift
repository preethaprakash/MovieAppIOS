//
//  DetailViewController.swift
//  movieapp
//
//  Created by preetha on 30/09/16.
//  Copyright © 2016 preetha. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let progressIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var overviewText: UITextView!
    @IBOutlet weak var addFavButton: UIButton!
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var movieObject = MovieData()
    let favimage = UIImage(named: "fav.png")
    let favclickedimage = UIImage(named: "favclicked.png")
    let imageURL="http://image.tmdb.org/t/p/w500/"
    var emptyReviewJSONResponse = 1
    var emptyTrailerJSONResponse = 1
    var checkConnectivityFlag = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setImageAndInitialData()
        self.loadMovieDetails()
        emptyTrailerJSONResponse=1
        emptyReviewJSONResponse=1
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title="Details"
        loadMovieDetails()
        if movieObject.reviews.count > 0{
            emptyReviewJSONResponse=0
        }
        if movieObject.trailers.count > 0{
            emptyTrailerJSONResponse=0
        }
        if emptyReviewJSONResponse==1 && movieObject.reviews.count==0{
            self.checkConnectivityAndLoadJSONData(4)
        }
        if emptyTrailerJSONResponse == 1 && movieObject.trailers.count==0{
            self.checkConnectivityAndLoadJSONData(3)
        }
        
        
    }
    
    func checkConnectivityAndLoadJSONData(identifier:Int){
        
            self.progressIndicator.backgroundColor = UIColor(white: 0, alpha: 1)
            self.view.addSubview(self.progressIndicator)
            self.progressIndicator.frame = self.view.frame
            self.progressIndicator.startAnimating()
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
                Reachability.alertShown=1
             }
    
        if (self.checkConnectivityFlag==1 && self.emptyReviewJSONResponse==1) || (self.checkConnectivityFlag==1 && self.emptyTrailerJSONResponse==1){
            let tempDataObject=DataFetch()
            DataFetch.identifier=identifier
            DataFetch.tempmovieid = movieObject.movieidData
        
            tempDataObject.getJSONData() { responseObject, error in
                    //print("responseObject = \(responseObject); error = \(error)")
                    if responseObject != nil{
                        if identifier==3 && self.emptyTrailerJSONResponse==1{
                            self.emptyTrailerJSONResponse=0
                            self.parseTrailerData(responseObject!)
                       
                        }
                        else if identifier==4 && self.emptyReviewJSONResponse==1{
                            self.emptyReviewJSONResponse=0
                            self.parseReviewData(responseObject!)

                        }
                    }
                    else{
                        if identifier==3{
                            self.emptyTrailerJSONResponse=1
                        }
                        else if identifier==4{
                            self.emptyReviewJSONResponse=1
                        }
                   }
                return
            }
           
            
        }
        
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.progressIndicator.stopAnimating()
                })
            })
    }
    
    func trailerTableAutoHeight()
    {
            tableViewHeightConstraint.constant = self.tableView.contentSize.height
            self.tableView.layoutIfNeeded()
            self.tableView.layoutSubviews()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TrailerCell", forIndexPath: indexPath) as! TrailerTableViewCell
        cell.WatchTrailerButton.setTitle("\(movieObject.trailers[indexPath.row][0])", forState: UIControlState.Normal)
        cell.WatchTrailerButton.titleLabel?.text = "\(movieObject.trailers[indexPath.row][0])"
        cell.playImageView.roundCorners([.TopLeft, .BottomLeft] , radius: 5)
        cell.WatchTrailerButton.roundCorners([.TopRight, .BottomRight] , radius: 5)
        cell.WatchTrailerButton.addTarget(self, action: #selector(DetailViewController.watchTrailerButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.selectionStyle = .None
        return cell
        
    }
    
    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieObject.trailers.count
    }
 
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func setImageAndInitialData()
    {
        self.addFavButton.enabled=true
        self.titleText.text=movieObject.titleData
        self.overviewText.text = "Released On :   " + movieObject.releaseData+"\n\nOverview :\n\n"+movieObject.overviewData
        let tempURL=self.imageURL+movieObject.imageData
        let tempUrl=NSURL(string: tempURL)
        self.imageView.kf_setImageWithURL(tempUrl!,placeholderImage: nil)
        self.tableView.hidden=true
       
    }
    
    
    func loadMovieDetails(){
        
        var favListArray = [MovieData]()
        let decoded  = defaults.objectForKey("favMovieList") as? NSData
        if decoded != nil{
            favListArray = (NSKeyedUnarchiver.unarchiveObjectWithData(decoded!) as? [MovieData])!
        }
       if favListArray.contains(movieObject) {
            self.addFavButton.setImage(favclickedimage, forState: UIControlState.Normal)
            self.favLabel.text="Favourite"
        }
        else{
            self.addFavButton.setImage(favimage, forState: UIControlState.Normal)
            self.favLabel.text="Mark As Favourite"
        }
        self.overviewText.text=""
        overviewText.superview?.layoutSubviews()
        overviewText.layer.cornerRadius = 5
        overviewText.layer.borderColor = UIColor.purpleColor().CGColor
        overviewText.layer.borderWidth = 1
        trailerButton.backgroundColor = UIColor.grayColor()
        reviewsButton.backgroundColor = UIColor.grayColor()
        detailsButton.backgroundColor = UIColor(red: 34/255.0, green: 139/255.0, blue: 34/255.0, alpha: 1.0)
        self.tableView.hidden=true
        self.overviewText.hidden=false
        self.overviewText.text = "\nReleased On :   " + movieObject.releaseData+"\n\nOverview :\n\n"+movieObject.overviewData
        overviewText.layer.borderColor = UIColor.purpleColor().CGColor
        overviewText.layoutIfNeeded()
        
    }
    
    
    
    @IBAction func addFavButtonClick(sender: UIButton) {
      
            var favListArray = [MovieData]()
            let decoded  = defaults.objectForKey("favMovieList") as? NSData
            if decoded != nil{
                favListArray = (NSKeyedUnarchiver.unarchiveObjectWithData(decoded!) as? [MovieData])!
            }
            if favListArray.contains(movieObject) {
                        self.favLabel.text="Mark As Favourite"
                        self.addFavButton.setImage(favimage, forState: UIControlState.Normal)
                        let index1 = favListArray.indexOf({$0.titleData == movieObject.titleData})
                        favListArray.removeAtIndex(index1!)
                        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(favListArray)
                        defaults.setObject(encodedData, forKey: "favMovieList")
                        defaults.synchronize()
            }
            else{
                        self.favLabel.text="Favourite"
                        self.addFavButton.setImage(favclickedimage, forState: UIControlState.Normal)
                        favListArray.append(movieObject)
                        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(favListArray)
                        defaults.setObject(encodedData, forKey: "favMovieList")
                        defaults.synchronize()
            }
        
    }
    
    
    @IBAction func detailsButtonClick(sender: UIButton) {
        
        tableViewHeightConstraint.constant = 0
        self.overviewText.text=""
        overviewText.superview?.layoutSubviews()
        trailerButton.backgroundColor = UIColor.grayColor()
        reviewsButton.backgroundColor = UIColor.grayColor()
        detailsButton.backgroundColor = UIColor(red: 34/255.0, green: 139/255.0, blue: 34/255.0, alpha: 1.0)
        self.tableView.hidden=true
        self.overviewText.hidden=false
        self.overviewText.text = "\nReleased On :   " + movieObject.releaseData+"\n\nOverview :\n\n"+movieObject.overviewData
        overviewText.layer.borderColor = UIColor.purpleColor().CGColor
        overviewText.layoutIfNeeded()
       
    }
    
    @IBAction func reviewButtonClick(sender: UIButton) {
        
        tableViewHeightConstraint.constant = 0
        var reviewText=""
        trailerButton.backgroundColor = UIColor.grayColor()
        detailsButton.backgroundColor = UIColor.grayColor()
        reviewsButton.backgroundColor = UIColor(red: 34/255.0, green: 139/255.0, blue: 34/255.0, alpha: 1.0)
        
        if emptyReviewJSONResponse==1{
            reviewText = "Couldn't load review details due to Internet connection problem"
            overviewText.layer.borderColor = UIColor.whiteColor().CGColor
        }
        else if movieObject.reviews.count==0{
              reviewText = "No reviews available"
              overviewText.layer.borderColor = UIColor.whiteColor().CGColor
        }
        else {
               for mov in movieObject.reviews{
                        var newString1 = mov[1].stringByReplacingOccurrencesOfString("Watch and download", withString: "")
                        newString1 = newString1.stringByReplacingOccurrencesOfString("movies watch free", withString: "")
                        newString1 = newString1.stringByReplacingOccurrencesOfString("**", withString: "")
                        newString1 = newString1.stringByReplacingOccurrencesOfString("here __", withString: " ")
                        reviewText+="\nAuthor :     "+mov[0]+"\n\n"+newString1+"\n\n"
                }
                overviewText.layer.borderColor = UIColor.purpleColor().CGColor
        }
        print(movieObject.reviews)
        self.tableView.hidden=true
        self.overviewText.hidden=false
        self.overviewText.text=reviewText
        self.overviewText.layoutIfNeeded()
        self.scrollView.layoutSubviews()
        
    }
    
    
    @IBAction func trailerButtonClick(sender: UIButton) {
        
        self.tableView.reloadData()
        
        if emptyTrailerJSONResponse == 1{
            self.overviewText.hidden=false
            self.tableView.hidden=true
            self.overviewText.text="Couldn't load trailer details due to Internet connection problem"
            overviewText.layer.borderColor = UIColor.whiteColor().CGColor
        }
        else if movieObject.trailers.count==0{
            self.overviewText.hidden=false
            self.tableView.hidden=true
            self.overviewText.text="No trailers available"
            overviewText.layer.borderColor = UIColor.whiteColor().CGColor
        }
        else if movieObject.trailers.count != 0{
            self.overviewText.hidden=true
            self.tableView.hidden=false
            self.overviewText.text=""
        }
        detailsButton.backgroundColor = UIColor.grayColor()
        reviewsButton.backgroundColor = UIColor.grayColor()
        trailerButton.backgroundColor = UIColor(red: 34/255.0, green: 139/255.0, blue: 34/255.0, alpha: 1.0)
        self.trailerTableAutoHeight()
        
    }
    
    
    func watchTrailerButtonClick(sender:UIButton!){
        if sender.titleLabel?.text != nil {
                for x in 0..<movieObject.trailers.count{
                    let name=sender.titleLabel?.text
                    if movieObject.trailers[x][0]==name{
                            let tempvar=movieObject.trailers[x][1]
                            if let url = NSURL(string: tempvar) {
                                    UIApplication.sharedApplication().openURL(url)
                             }
                    }
                }
        }
    }
    
    func parseTrailerData(data: NSDictionary){
        
          let youtubeUrl="http://www.youtube.com/watch?v="
          let results = data["results"] as? [[String: AnyObject]]
          for movie in results!{
                var trailer = [String]()
                if let name = movie["name"] as? String {
                    trailer.append(name)
                }
                if let key = movie["key"] as? String {
                    trailer.append(youtubeUrl+key)
                }
                movieObject.trailers.append(trailer)
           }
        
    }
    
    func parseReviewData(data: NSDictionary){
        
          let results = data["results"] as? [[String: AnyObject]]
          for movie in results!{
                var review = [String]()
                if let authorname = movie["author"] as? String {
                      review.append(authorname)
                }
                if let authorcontent = movie["content"] as? String {
                        do{
                                let encodedData = authorcontent.dataUsingEncoding(NSUTF8StringEncoding)!
                                let attributedOptions : [String: AnyObject] = [
                        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                        NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                    ]
                                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                                let decodedString = attributedString.string
                                review.append(decodedString)
                          } catch let error as NSError {
                                print(error.localizedDescription)
                            }
                
                }
                movieObject.reviews.append(review)
         }
        
    }

}

