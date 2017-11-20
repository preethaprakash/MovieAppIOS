//
//  UserCollectionViewController.swift
//  movieapp
//
//  Created by preetha on 03/10/16.
//  Copyright © 2016 preetha. All rights reserved.
//

import UIKit



class UserCollectionViewController: UICollectionViewController {
    
    @IBOutlet var UserCollectionViewController: UICollectionView!
    
private let reuseIdentifier = "UserCell"
   let imageURL="http://image.tmdb.org/t/p/w500/"
    var cache:NSCache?
    
  /*  override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
 */
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.cache = NSCache()
        
        //DataStore.controller=self
       // self.sendData()
        //self.UserCollectionViewController.reloadData()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.sendData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //print(DataStore.favListTitle.count)
        return DataStore.favListTitle.count
        //return 20
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
       // print(DataStore.favListTitle)
        //print("image")
        print(DataStore.favListImageURL[indexPath.row])
        //print("over")
        //print(DataStore.favListOverview)
 
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UserFavViewCell
        //cell.backgroundColor = UIColor.redColor()
        //cell.backgroundColor = UIColor.blueColor()
        //task.resume()
        
      /*  if let url = NSURL(string: "http://image.tmdb.org/t/p/w500//g54J9MnNLe7WJYVIvdWTeTIygAH.jpg") {
         if let data = NSData(contentsOfURL: url) {
         cell.userFavImageVar.image = UIImage(data: data)
         }
         }*/
        
        // Configure the cell
        dispatch_async(dispatch_get_main_queue()){
            
            if (self.cache?.objectForKey(indexPath.row) != nil){
                // 2
                cell.userFavImageVar.image = self.cache?.objectForKey(indexPath.row) as? UIImage
            }else{
                
            
           // for list in DataStore.favListImageURL{
                
            //   print(list)
                //var tempBackdropPath=self.imageData[indexPath.row] as String
                let tempImagePath=DataStore.favListImageURL[indexPath.row] as String

                let tempURL=self.imageURL+tempImagePath
                //print(tempURL)
                if let url = NSURL(string : tempURL)
                {
                    if let data = NSData(contentsOfURL: url) {
                        let img:UIImage! = UIImage(data: data)

                        //dispatch_async(dispatch_get_main_queue()){
                            cell.userFavImageVar.image = UIImage(data: data)
                        self.cache?.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                        
                        }
                    }
                }
            }
        
        
        return cell
        
    }
    
    // MARK: UICollectionViewDelegate
    
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //addToList.append(objectsArray[indexPath.row])
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        /*cell!.layer.borderWidth = 2.0
         cell!.layer.borderColor = UIColor.grayColor().CGColor*/
        self.performSegueWithIdentifier("userFavSegue", sender: cell)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "userFavSegue" {
            
            let nextScene =  segue.destinationViewController as! DetailViewController
            
            // Pass the selected object to the new view controller.
            
            
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPathForCell(cell)
            
            
            //DataStore.viewDetail?.setData(titleData[indexPath.row],aRelease: releaseData[indexPath.row],aOverview: overviewData[indexPath.row])
            nextScene.aTitle=DataStore.favListTitle[indexPath!.row] as String
            nextScene.aRelease=DataStore.favListReleaseDate[indexPath!.row] as String
            nextScene.aOverview=DataStore.favListOverview[indexPath!.row] as String
            nextScene.aImageURL=DataStore.favListImageURL[indexPath!.row] as String
            
            
            
            // nextScene.setData(titleData[indexPath.row],aRelease: releaseData[indexPath.row],aOverview: overviewData[indexPath.row])
            
            
        }
    }
    

    
    func sendData(){
        dispatch_async(dispatch_get_main_queue()){
            
            self.UserCollectionViewController.reloadData()
        }
        
    }

    

}
