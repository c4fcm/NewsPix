//
//  ViewController.swift
//  NewsPix Beta
//
//  Created by UROP on 3/12/16.
//  Copyright © 2016 UROP. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var swipeRight: UISwipeGestureRecognizer!
    @IBOutlet var swipeLeft: UISwipeGestureRecognizer!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pictureTitle: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    //Sets status bar to white
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    var index: Int = 0
    var lastZoomScale: CGFloat = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial_frame = view.frame
        
        //Always make pictureTitle fit in one line
        self.pictureTitle.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel.adjustsFontSizeToFitWidth = true
                
        //Initialize Display
        self.pictureTitle.setTitle(names[index],for: UIControlState())
        self.titleLabel.text = names[index]
        self.imageView.image = images[index]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //scrollView Initialization settings
        scrollView.delegate = self
        updateZoom()
        updateConstraints()
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    //Function for activating hyperlink
    @IBAction func didPressTitle() {
        let url = urls[index];
        UIApplication.shared.openURL(url as URL);
    }
    
    //ScrollView Functions
    override func viewWillTransition(to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
            
            super.viewWillTransition(to: size, with: coordinator)
            
            coordinator.animate(alongsideTransition: { [weak self] _ in
                self?.updateZoom()
                }, completion: nil)
    }
    
    func updateConstraints() {
        if let _ = imageView.image {
            
            let imageWidth = imageSizeAfterAspectFit(imageView).width
            let imageHeight = imageSizeAfterAspectFit(imageView).height
            
            let viewWidth = scrollView.bounds.size.width
            let viewHeight = scrollView.bounds.size.height
            
            // center image if it is smaller than the scroll view
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            imageViewTrailingConstraint.constant = hPadding
            imageViewLeadingConstraint.constant = hPadding
            
            imageViewTopConstraint.constant = vPadding
            imageViewBottomConstraint.constant = vPadding
            
            imageViewHeight.constant = imageSizeAfterAspectFit(imageView).height
            
            view.layoutIfNeeded()
            
            //Disable scrolling if image is fully zoomed out
            if scrollView.zoomScale == 1.0 {
                scrollView.isScrollEnabled = false
            }
            else {
                scrollView.isScrollEnabled = true
            }
        }
        
    }
    
    fileprivate func updateZoom() {
        // Zoom to show as much image as possible unless image is smaller than the scroll view
            // **Called only upon view initialization and upon device rotation**
        if let image = imageView.image {
            var minZoom = min(scrollView.bounds.size.width / image.size.width,
                scrollView.bounds.size.height / image.size.height)

            if minZoom > 1 { minZoom = 1 }
            
            scrollView.minimumZoomScale = 1
            scrollView.maximumZoomScale = 6

            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            scrollView.zoomScale = minZoom
            lastZoomScale = scrollView.zoomScale
            
        }
    }
    
    // UIScrollViewDelegate
    // -----------------------
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let contentScale: CGFloat = scale * UIScreen.main.scale
        view!.contentScaleFactor = contentScale
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
        }
    
} //Do not delete! End of ViewController class
