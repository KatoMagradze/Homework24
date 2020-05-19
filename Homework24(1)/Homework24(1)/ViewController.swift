//
//  ViewController.swift
//  Homework24(1)
//
//  Created by Kato on 5/19/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

struct NewBand: Codable {
    let bands: [Band]
    
    enum codingKets: String, CodingKey {
        case bands = "bands"
    }
}

struct Band: Codable {
    
    let name: String
    let img_url: String
    let thumb1: String
    let thumb2: String
    let thumb3: String
    let info: String
    let genre: String
    
}

class ViewController: UIViewController {
    
    
    var bands = [Band]()
    var selectedIndex = 0
    


    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.getBand()
    }
    
    
    func getBand() {
        let url = URL(string: "http://www.mocky.io/v2/5ec3e47a300000e4b039c515")!
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let newBand = try decoder.decode(NewBand.self, from: data)
                
                self.bands.append(contentsOf: newBand.bands)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch {print(error.localizedDescription)}
            
        }.resume()
    }
    
    
    




}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bands_cell", for: indexPath) as! BandCell
        
        cell.bandNameLabel.text = bands[indexPath.row].name
        
        bands[indexPath.row].img_url.downloadImage { (image) in
            DispatchQueue.main.async {
                cell.bandImageView.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let temp = storyboard.instantiateViewController(withIdentifier: "info_vc")
        
        if let vc = temp as? InfoViewController {
            vc.label = bands[indexPath.row].info
            //vc.songnames.append(songs[indexPath.row])
            vc.band = bands[indexPath.row].name
        }
        
        self.navigationController?.pushViewController(temp, animated: true)
        
    }
    
}

extension String {
    
    func downloadImage(completion: @escaping (UIImage?) -> ()) {

        guard let url = URL(string: self) else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            completion(UIImage(data: data))
        }.resume()
    }
    
}



extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWith = collectionView.frame.width / 2
        
        return CGSize(width: itemWith - 20 - 20, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 30, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}



