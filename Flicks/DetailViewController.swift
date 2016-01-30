//
//  DetailViewController.swift
//  Flicks
//
//  Created by Nishant Raman on 1/30/16.
//  Copyright © 2016 Nishant Raman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailView: UIView!
    
    var movies : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width : scrollView.frame.size.width, height: detailView.frame.origin.y + detailView.frame.size.height)
        
        titleLabel.text = movies["title"] as? String
        overviewLabel.text = movies["overview"] as? String
        
        overviewLabel.sizeToFit()
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movies["poster_path"] as? String {
            let posterURL = NSURL(string : baseURL + posterPath)
            posterImageView.setImageWithURL(posterURL!)
            
        }
    }
    
    

}
