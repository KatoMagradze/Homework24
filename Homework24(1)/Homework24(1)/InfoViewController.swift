//
//  InfoViewController.swift
//  Homework24(1)
//
//  Created by Kato on 5/19/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    struct BandSong: Codable {
        let data: [Band]
        
    }
    
    struct Band: Codable {
        let band : String
        let songs : [Song]
    }
    
    struct Song: Codable {
        let title: String
    }


//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var infoLabel: UILabel!
    
    
    @IBOutlet weak var infoLabel: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var label = ""
    var band = ""
    
    var songs = [Song]()
    
    var selectedRow = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel.text = self.label
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.getSong()
        
        self.title = band
        
    }
    
    func getSong() {
        let url = URL(string: "http://www.mocky.io/v2/5ec3ca1c300000e5b039c407")!
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let newSong = try decoder.decode(BandSong.self, from: data)
                
                for selectedBand in newSong.data {
                    if selectedBand.band == self.band {
                        self.songs.append(contentsOf: selectedBand.songs)
                        break
                    }
                }
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            catch{ print(error.localizedDescription)}
            
        }.resume()
    }
    

}
extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "info_cell", for: indexPath) as! InfoCell
        
        cell.songNameLabel.text = songs[indexPath.row].title

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let temp = storyboard.instantiateViewController(withIdentifier: "lyrics_vc")
        
        if let vc = temp as? LyricsViewController {
            vc.artistName = band
            vc.artistSong = songs[indexPath.row].title
        }
        
        self.navigationController?.pushViewController(temp, animated: true)
        
        
    }
    
}
