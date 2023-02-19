//
//  AlbumsViewController.swift
//  lab-tunley
//
//  Created by Paul Leiva on 2/19/23.
//

import UIKit
import Nuke // helps load album images

class AlbumsViewController: UIViewController, UICollectionViewDataSource {
    
    // Tells the collectionView how many items to display
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // the number of items show should eb the number of albums we have
        albums.count
    }
    
    // Creates, configures and returns the cell to display for a given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a collection view cell (based in the identifier you set in storyboard) and cast it to our custom AlbumCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        // Use the indexPath.item to index into the albums array to get the corresponding album
        let album = albums[indexPath.item]
        
        // Get the artwork image URL
        let imageUrl = album.artworkUrl100
        
        // Set the image on the Image View of the cell
        Nuke.loadImage(with: imageUrl, into: cell.albumImageView)
        
        // return the cell
        return cell
    }
    

    // Outlet for CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Add property to hold array of albums we get back
    var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the delegate for the collection view
        collectionView.dataSource = self
        
        /// Create a searhc URL for fetching albums (`entity = album`)
        let url = URL(string: "https://itunes.apple.com/search?term=blackpink&attribute=artistTerm&entity=album&media=music")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            // Handle any errors
            if let error = error {
                print ("❌ Network error: \(error.localizedDescription)")
            }
            
            // Make sure we have data
            guard let data = data else {
                print("❌ Data is nil")
                return
            }
            
            // Create a JSON Decoder
            let decoder = JSONDecoder()
            do {
                // Try to parse the response into our custom model
                let response = try decoder.decode(AlbumSearchResponse.self, from: data)
                let albums = response.results
                
                print("\n\nAlbums:\n\n")
                print(albums)
                
                
                // Explicityly update the albums collection view in the main thread (UI updates not allowed in background threads)
                DispatchQueue.main.async {
                    self?.albums = albums
                    self?.collectionView.reloadData() // Reload data after we set the albums property
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
        }
        
        // Initiate the network request
        task.resume()
        
        /// Step 10: Updating the Collection View's Layout
        // Get a reference to the Collection View's layout
        // We want to dynamically size the cells for the available space and desired number of columns.
        // NOTE: This Collection View scrolls vertically, but Collection Views can alternatively scroll horizontally.
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // The minimum spacing between adjacent cells (left/right, in vertical scrolling collection)
        // Set this to taste.
        layout.minimumInteritemSpacing = 4
        
        // The minimum spacing between adjacent cells (top/bottom, in vertical scrolling collection)
        // Set this to taste
        layout.minimumLineSpacing = 4
        
        // Set this to however many columns you want to show in the collection.
        let numberOfColumns: CGFloat = 3
        
        // Calculate the width each cell needs to be to fit the number of columns, taking into account the spacing between cells.
        let width = (collectionView.bounds.width - layout.minimumInteritemSpacing * (numberOfColumns - 1)) / numberOfColumns
        
        // Set the size that each item/cell should display at
        layout.itemSize = CGSize(width: width, height: width)
        
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
