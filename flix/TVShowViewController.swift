//
//  TVShowViewController.swift
//  flix
//
//  Created by Jonathan Singer on 6/24/20.
//  Copyright © 2020 Jonathan Singer. All rights reserved.
//

import UIKit

class TVShowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
     var fetchingMore = false
        let urlBase = "https://api.themoviedb.org/3/tv/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page="
        var pageNum = 1
        var tvShows = [[String:Any]]()
        //Creation of an array of dictionaries
        
        override func viewDidLoad() {
            super.viewDidLoad()

            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = 230
            getAllTVShows()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tvShows.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowCell") as! TVShowCell
            
            let tvShow = tvShows[indexPath.row]
            let title = tvShow["name"] as! String
            let synopsis = tvShow["overview"] as! String
            
            cell.TVShowTitle.text = title
            
            cell.TVShowSynopsis.text = synopsis
            
            let baseURL = "https://image.tmdb.org/t/p/w185"
            let posterPath = tvShow["poster_path"] as? String
            if let posterPath = posterPath {
                let posterURL = URL(string: baseURL + posterPath)!
                cell.posterView.af_setImage(withURL: posterURL)
            } else {
                cell.posterView.image = nil
            }
            
            return cell
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // PAss the selected object to the new view controller.
            
            // Find the selected movie
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let tvShow = tvShows[indexPath.row]
            
            
//            // Pass the selected movie to the details view controller
//            let detailsViewController = segue.destination as! MovieDetailsViewController
//            detailsViewController.movies = movie
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
//        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            let offsetY = scrollView.contentOffset.y
//            let contentHeight = scrollView.contentSize.height
//
//            if offsetY > contentHeight - scrollView.frame.height{
//                if(!fetchingMore){
//                    beginBatchFetch()
//                }
//            }
//        }

//        func beginBatchFetch(){
//            fetchingMore = true
//            pageNum += 1
//            spinner.startAnimating()
//            getAllMovies()
//        }
//
        func getAllTVShows(){
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

                self.tvShows = self.tvShows + (dataDictionary["results"] as! [[String:Any]])
                self.tableView.reloadData()
                
                  // TODO: Get the array of movies
                  // TODO: Store the movies in a property to use elsewhere
                  // TODO: Reload your table view data

               }
//                self.spinner.stopAnimating()
//                self.spinner.hidesWhenStopped = true
//                self.fetchingMore = false
            }
            task.resume()
        }
    }

