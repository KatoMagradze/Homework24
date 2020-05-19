//
//  LyricsViewController.swift
//  Homework24(1)
//
//  Created by Kato on 5/19/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class LyricsViewController: UIViewController {
    
    struct Lyrics: Codable {
        let lyrics: String
    }

    
    @IBOutlet weak var lyricsLabel: UITextView!
    var artistName = ""
    var artistSong = ""
    
    var songLyrics = [Lyrics]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchLyrics()
        // Do any additional setup after loading the view.
    }
    
    func searchLyrics() {
        
        let artist = artistName.replacingOccurrences(of: "/", with: "")
        
        let encodedURLString = "https://api.lyrics.ovh/v1/" + artist.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + "/" + self.artistSong.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let url = URL(string: encodedURLString)!
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let newLyrics = try decoder.decode(Lyrics.self, from: data)
                
                self.songLyrics.append(newLyrics)
                
                DispatchQueue.main.async {
                    self.lyricsLabel.text = self.songLyrics[0].lyrics
                }
                
            } catch {print(error.localizedDescription)}
            
        }.resume()
    }
}
