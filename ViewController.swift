//
//  ViewController.swift
//  PhotosPOC
//
//  Created by Pramanshu Goel on 11/08/20.
//  Copyright © 2020 Pramanshu Goel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var photoArray : [Photo]?
//(method:"flickr.photos.search",api_key:"f6bb977b702cd9cf8da782c3d27637bb",text:"river",format:"json",nojsoncallback:"1"))
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
        
        
        
        
        
        NetworkService.request(router:  .getFacts(method: "flickr.photos.search", api_key: "f6bb977b702cd9cf8da782c3d27637bb", text: "river", format: "json", nojsoncallback: "1")) { (result:  Result<PhotosModel,NetworkError>) in
                  switch result {
                  case .success(let posts):
                    self.photoArray = posts.photos?.photo
                    
//                      self.blogModel = posts
//                      self.blogViewModel = BlogViewModel(blogModel:self.blogModel)
                    
                    print(self.photoArray)
                      print(posts)
                      
                      
                      
                      
                  case .failure:
                      print("FAILED")
                  }
              }
              
             
              }
        
    }




