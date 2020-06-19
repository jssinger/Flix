//
//  MovieDetailsViewController.swift
//  flix
//
//  Created by Jonathan Singer on 6/12/20.
//  Copyright © 2020 Jonathan Singer. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    var movie: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as? String
        if let posterPath = posterPath {
            let posterURL = URL(string: baseURL + posterPath)!
            posterView.af_setImage(withURL: posterURL)
            posterView.backgroundColor = nil
        } else {
            posterView.image = nil
        }
        
        let backdropPath = movie["backdrop_path"] as? String
        if let backdropPath = backdropPath {
            let backdropURL = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)!
            backdropView.af_setImage(withURL: backdropURL)
        } else {
            backdropView.image = nil
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
