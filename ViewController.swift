//
//  ViewController.swift
//  PhotosPOC
//
//  Created by Pramanshu Goel on 11/08/20.
//  Copyright © 2020 Pramanshu Goel. All rights reserved.
//

import UIKit
import SwiftyPickerPopover

class ViewController: UIViewController {
    
    @IBOutlet weak var photosCollection: UICollectionView!
    var photoArray : [Photo]?
    var button: UIButton?
    var selectedLayout:Int = 2
    var pageNo = 1
     var searchBar = UISearchBar()
    var isLoading = false
    var loadingView: LoadingReusableView?

    private lazy var session : URLSession = {
         let configuration = URLSessionConfiguration.default
         configuration.requestCachePolicy = .returnCacheDataElseLoad
         return URLSession(configuration: configuration)
         
     }()
    
    var noPhotosLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
   
         
        
         button = UIButton(type: UIButton.ButtonType.custom) as! UIButton
              //set image for button
        button!.setImage(UIImage(named: "option"), for: .normal)
              //add function for button
        button!.addTarget(self, action:  #selector(optionClicked), for: UIControl.Event.touchUpInside)
              //set frame
        button!.translatesAutoresizingMaskIntoConstraints = false
        button!.widthAnchor.constraint(equalToConstant: 30).isActive = true; button!.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
              let barButton = UIBarButtonItem(customView: button!)
        
    
       
        
        navigationItem.titleView = searchBar
           
              //assign button to navigationbar
        navigationItem.leftBarButtonItem = barButton
  
       
        
      
        
        
        
        photosCollection.delegate = self
        photosCollection.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "Search Photos"
        
       //Register Loading Reuseable View
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        photosCollection.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")

        
        
        

    
              
             
              }
    
    
    func callAPI()  {
        
        self.loadingView?.activityIndicator.color = .black
        self.loadingView?.activityIndicator.startAnimating()
        if !self.isLoading{
            self.isLoading = true
        NetworkService.request(router:  .getFlickrPhotos(method: "flickr.photos.search", api_key: "f6bb977b702cd9cf8da782c3d27637bb", text: searchBar.text ?? "", format: "json",page:String(pageNo), nojsoncallback: "1")) { (result:  Result<PhotosModel,NetworkError>) in
                          switch result {
                          case .success(let posts):
                            if let photosArray = self.photoArray{
                                 
                                self.photoArray! += ((posts.photos?.photo)!)
                            }
                            else{
                                self.photoArray = ((posts.photos?.photo)!)
                                
                            }
                            DispatchQueue.main.async{
                            self.photosCollection.reloadData()
                                self.isLoading = false
                                self.loadingView?.activityIndicator.stopAnimating()
                            }
                            
        
                            
                            print(self.photoArray)
                              print(posts)
                              
                              
                              
                              
                          case .failure:
                              print("FAILED")
                          }
                      }
        }
    }
    @objc func optionClicked()  {
        
        
        
        
        
        let p = StringPickerPopover(title: "Select Layout", choices: ["2","3","4"])
        .setSelectedRow(1)
        .setDoneButton(title:"Done", action: { (popover, selectedRow, selectedString) in
            
            print("done row \(selectedRow) \(selectedString)")
            self.selectedLayout = Int(selectedString)!
            self.photosCollection.reloadData()
        })
        
            
        .setCancelButton(title:"Cancel", action: { (_, _, _) in print("cancel")} )
            
        p.appear(originView: button!, baseViewController: self)
        p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )
    }
    }

extension ViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         print("searchText \(searchText)")
     }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         print("searchText \(searchBar.text)")
        pageNo = 1
        callAPI()
        searchBar.resignFirstResponder()
     }
}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.photoArray?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
     

        
        
        
        guard let farmId = photoArray?[indexPath.row].farm, let server = photoArray?[indexPath.row].server,let id = photoArray?[indexPath.row].id,let secret = photoArray?[indexPath.row].secret
            else{
                print("")
                
               return cell
        }
        let photoString = "https://farm\(farmId).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
        
        cell.configure(with: photoString, session: session)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
}

extension ViewController: UICollectionViewDelegate {

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let cell = collectionView.cellForItem(at: indexPath)  as! PhotoCell

        var detail = DetailImageController()
        detail.mediumImage = cell.photoImageView.image
        
        
        guard let farmId = photoArray?[indexPath.row].farm, let server = photoArray?[indexPath.row].server,let id = photoArray?[indexPath.row].id,let secret = photoArray?[indexPath.row].secret
            else{
                print("")
                
               return
        }
        let photoString = "https://farm\(farmId).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
        
        cell.configure(with: photoString, session: session)
        detail.photo = photoArray![indexPath.row]

        self.navigationController?.pushViewController(detail, animated: true)
    }
  
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if (indexPath.row == photoArray!.count - 1  && !self.isLoading) { //it's your last cell
           //Load more data & reload your collection view
            pageNo = pageNo + 1
            self.callAPI()
            print("reached end")
            
         }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        

            
            let width = (collectionView.bounds.width - CGFloat((selectedLayout*10)+10))/CGFloat(selectedLayout)
            let height = (collectionView.bounds.width - CGFloat((selectedLayout*10)+10))/CGFloat(selectedLayout)
            
            
            return CGSize(width: width, height: height)
            

    }

   

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    
   

}
