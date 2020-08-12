//
//  CollectionViewLoadingReusableView.swift
//  LoadMoreExample
//
//  Created by Pramanshu Goel on 11/08/20.
//  Copyright © 2020 Pramanshu Goel. All rights reserved.
//

import UIKit

class LoadingReusableView: UICollectionReusableView {

   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.color = UIColor.white
    }
}
