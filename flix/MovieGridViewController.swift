//
//  MovieGridViewController.swift
//  flix
//
//  Created by Jonathan Singer on 6/17/20.
//  Copyright © 2020 Jonathan Singer. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fetchingMore = false
    let urlBase = "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page="
    var pageNum = 1
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let cellsPerLine: CGFloat = 3
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = layout.minimumInteritemSpacing

        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let cellWidth = (collectionView.frame.size.width - interItemSpacingTotal) / cellsPerLine
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 3 / 2)
        collectionView.collectionViewLayout = layout
        getAllMovies()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return movies.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        cell.posterView.image = nil
        let movie = movies[indexPath.item]
        
        let baseURL = "https://image.tmdb.org/t/p/w342"
        let posterPath = movie["poster_path"] as? String
        if let posterPath = posterPath {
            let posterURL = URL(string: baseURL + posterPath)!
            cell.posterView.af_setImage(withURL: posterURL)
        } else {
            cell.posterView.image = nil
        }
        cell.layoutIfNeeded()
        return cell
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let offsetY = scrollView.contentOffset.y
         let contentHeight = scrollView.contentSize.height

         if offsetY > contentHeight - scrollView.frame.height{
             if(!fetchingMore){
                 beginBatchFetch()
             }
         }
     }

     func beginBatchFetch(){
         fetchingMore = true
         pageNum += 1
         getAllMovies()
     }
     
     func getAllMovies(){
         fetchingMore = true
         let fullUrl = urlBase + String(pageNum)
         let url = URL(string: fullUrl)!
         let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
         let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
         let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
               print(error.localizedDescription)
            } else if let data = data {
               let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

             self.movies = self.movies + (dataDictionary["results"] as! [[String:Any]])
             self.collectionView.reloadData()
             
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data

            }
             self.fetchingMore = false
         }
         task.resume()
     }
}
