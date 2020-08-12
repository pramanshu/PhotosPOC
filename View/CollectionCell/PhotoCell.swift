//
//  PhotoCell.swift
//  PhotosPOC
//
//  Created by Pramanshu Goel on 11/08/20.
//  Copyright © 2020 Pramanshu Goel. All rights reserved.
//  

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
     private var dataTask : URLSessionDataTask?
    //MARK: Configure Cell
           
       public func configure(with photoUrl:String,session: URLSession){
               
             
              
               
            let imgUrl = URL(string: photoUrl)
                      if let imgUrl = imgUrl{
                          
                        
                          // passed session is used for creating data task
                          let dataTask = session.dataTask(with: imgUrl) {[weak self] (data, _, _) in
                              
                              guard let data = data else{
                                   DispatchQueue.main.async {
                                       self?.photoImageView.image = UIImage(imageLiteralResourceName: "placeHolderImage")
                                  }
                                  return
                              }
                             
                              let image = UIImage(data: data)
                              
                              DispatchQueue.main.async {
                                  if((image) != nil){
                                   self?.photoImageView.image = image
                                  }
                                  else{
                                   self?.photoImageView.image = UIImage(imageLiteralResourceName: "placeHolderImage")
                                  }
                              }
                          }
                          self.dataTask = dataTask
                          dataTask.resume()
                      }
                      else{
                           self.photoImageView.image = UIImage(imageLiteralResourceName: "placeHolderImage")
                          
                  }
                      

                  }
    
    
    //MARK:  cancelling urlsession task instance while scrolling
      override func prepareForReuse() {
          
          self.dataTask?.cancel()
                 dataTask = nil
                 self.photoImageView.image = UIImage(imageLiteralResourceName: "placeHolderImage")
    }
           
}
