//
//  ViewController.swift
//  PRD5
//
//  Created by Students on 20/03/2019.
//  Copyright © 2019 Students. All rights reserved.
//

import UIKit

struct GithubConnect{
    let name: String?
    let company: String?
    let bio: String?
    let imageUrl: String?
}

class ViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
        
    }
    
    func fetchUserData() -> Void {
        let url = URL (string: "https://api.github.com/users/ditapruse")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: urlRequest){
            (data, response, error) in
            if let data = data{
                do{
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    if let validDictionary = jsonSerialized{
                        let validName = validDictionary["name"] as? String
                        let validCompany = validDictionary ["company"] as? String
                        let validBio = validDictionary ["bio"] as? String
                        let validImageUrl = validDictionary ["avatar_url"] as? String
                        
                        DispatchQueue.main.async {  // kad dati ir saņemti un jāapdato uz UI
                            self.nameLabel.text = validName ?? "No name recieved"
                            self.companyLabel.text = validCompany ?? "No company recieved"
                            self.bioLabel.text = validBio ?? "No Bio recieved"
                            self.profileImage.downloaded(from: validImageUrl ?? "https://dummyimage.com/600x400/000/fff&text=Nav+att%C4%93la")
                        }
                    }else {
                        print("ERROR: Dati nav derīgi")
                    }
                    } catch let error as NSError{
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()   //izpildīs task
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
