//
//  ViewController.swift
//  ImageViewer
//
//  Created by Young on 9/8/18.
//  Copyright © 2018 Young. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    let imageView: UIImageView = UIImageView(image: nil)
    
    let imageManager = PHImageManager.default()
    
    var fetchResult: PHFetchResult<PHAsset> = PHFetchResult.init()
    
    var currentIndex: Int = 0
    {
        willSet
        {
            let asset = fetchResult.object(at: newValue)
            
            imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: nil) { (image, array) in
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
        loadPhotoAssets()
        
    }
    
    func loadPhotoAssets()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            print("request status->",status)
        }
        
        fetchResult = PHAsset.fetchAssets(with: PHFetchOptions.init())
        print("fetch result->",fetchResult.count)
        
        if fetchResult.count > 0
        {
            currentIndex = 0
        }
    }
    
    @objc func swipeImage(swipe: UISwipeGestureRecognizer) {
        
        var newIndex = currentIndex
        
        switch swipe.direction {
        case .left:
            newIndex += 1
            break
        case .right:
            newIndex -= 1
            break
        default:
            
            break
        }
        
        /** make sure not out of bounds */
        newIndex = newIndex<0 ? newIndex+fetchResult.count : newIndex
        
        currentIndex = newIndex % fetchResult.count
        
    }
    
    
    func render()
    {
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        imageView.isUserInteractionEnabled = true
        
        let directions = [UISwipeGestureRecognizerDirection.left, UISwipeGestureRecognizerDirection.right]
        
        for dir in directions{
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeImage(swipe:)))
            swipe.direction = dir
            imageView.addGestureRecognizer(swipe)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.frame = view.bounds
    }

}

