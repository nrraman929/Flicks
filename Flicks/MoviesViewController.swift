//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Nishant Raman on 1/14/16.
//  Copyright © 2016 Nishant Raman. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    

    
    var movies: [NSDictionary]?
    var hud : MBProgressHUD?
    var refreshControl: UIRefreshControl!
    
    var endpoint : String!
    
    func networkCall() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let _ = error {
                    UIView.animateWithDuration(1.0, animations: {
                        self.errorView.alpha = 1
                        }, completion: nil)
                    self.hud!.hide(true)
                }
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.hud!.hide(true)
                            self.movies = (responseDictionary["results"] as! [NSDictionary])
                            UIView.animateWithDuration(1.0, animations: {
                                self.errorView.alpha = 0
                                }, completion: nil)
                            self.tableView.reloadData()
                            self.collectionView.reloadData()
                    }
                }
        });
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.alpha = 0
        
        errorView.alpha = 0
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        
        hud = MBProgressHUD.init(view: self.view)
        hud!.color = UIColor.whiteColor()
        hud!.activityIndicatorColor = UIColor.orangeColor()
        self.view.addSubview(hud!)
        hud?.show(true)
        
        let collectionLayout : UICollectionViewFlowLayout!
        collectionLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.collectionView.addSubview(refreshControl)
        self.collectionView.bringSubviewToFront(refreshControl)
        
        networkCall()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies{
            return movies.count
        } else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as? String
        
        var imageURL = NSURL(string: "")
        if posterPath != nil { imageURL = NSURL(string: baseURL
            + posterPath!)! }
        let request = NSURLRequest(URL: imageURL!)
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        /*if imageURL!.absoluteString != "" {cell.posterView.setImageWithURL(imageURL!)}
        else { cell.posterView.image = UIImage(named: "questionmark-512")}*/
        
        cell.posterView.setImageWithURLRequest(
            request,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    //print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                    })
                } else {
                    //print("Image was cached so just update the image")
                    cell.posterView.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
                cell.posterView.image = UIImage(named: "questionmark-512")
        })
        
        
        //cell.textLabel!.text = title //"row \(indexPath.row)"
        print("row \(indexPath.row)")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            if let mov = movies{
                return mov.count
            }
            return 0
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let colCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! MovieCollectionCell
            
            let movie = movies![indexPath.row]
            //let title = movie["title"] as! String
            //let overview = movie["overview"] as! String
            
            let baseURL = "http://image.tmdb.org/t/p/w500"
            let posterPath = movie["poster_path"] as? String
            
            var imageURL = NSURL(string: "")
            if posterPath != nil { imageURL = NSURL(string: baseURL
                + posterPath!)! }
            let request = NSURLRequest(URL: imageURL!)
            //cell.titleLabel.text = title
            //cell.overviewLabel.text = overview
            /*if imageURL!.absoluteString != "" {cell.posterView.setImageWithURL(imageURL!)}
            else { cell.posterView.image = UIImage(named: "questionmark-512")}*/
            
            colCell.imageView.setImageWithURLRequest(
                request,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        //print("Image was NOT cached, fade in image")
                        colCell.imageView.alpha = 0.0
                        colCell.imageView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            colCell.imageView.alpha = 1.0
                        })
                    } else {
                        //print("Image was cached so just update the image")
                        colCell.imageView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
                    colCell.imageView.image = UIImage(named: "questionmark-512")
            })
            
            
            //cell.textLabel!.text = title //"row \(indexPath.row)"
            //print("row \(indexPath.row)")
            return colCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width/2 - 10, height: collectionView.frame.size.width/2 - 10)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.networkCall()
            self.refreshControl.endRefreshing()
        })
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movies = movie
        
        
        
    }
    

}
