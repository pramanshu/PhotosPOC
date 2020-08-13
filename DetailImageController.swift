
//
//  DetailImageViewController.swift
//  PhotosPOC
//
//  Created by Pramanshu Goel on 11/08/20.
//  Copyright © 2020 Pramanshu Goel. All rights reserved.
//

import UIKit

class DetailImageController: UIViewController {

    
    var imageView = UIImageView()
    var mediumImage: UIImage?
    var photo : Photo?
    var dataTask : URLSessionDataTask?
    var session : URLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        imageView.image = mediumImage
        self.view.addSubview(imageView)
        imageView.backgroundColor = UIColor.red
        imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        //MARK: make url
        guard let farmId = photo?.farm, let server = photo?.server,let id = photo?.id,let secret = photo?.secret
                   else{
                       print("")
                       return
                     
               }
               let photoString = "https://farm\(farmId).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
        print(photoString)
        self.configure(with: photoString, session: session!)

    }
    
    
    public func configure(with photoUrl:String,session: URLSession){
                  
                
                 
                  
               let imgUrl = URL(string: photoUrl)
                         if let imgUrl = imgUrl{
                             
                           
                             // passed session is used for creating data task
                             let dataTask = session.dataTask(with: imgUrl) {[weak self] (data, _, _) in
                               
                                
                                let image = UIImage(data: data!)
                                 
                                 DispatchQueue.main.async {
                                     if((image) != nil){
                                      self?.imageView.image = image
                                     }
                                    
                                 }
                             }
                             self.dataTask = dataTask
                             dataTask.resume()
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
