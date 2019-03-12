//
//  YTScreenCell.swift
//  tvOS
//
//  Created by Thomas Ahn Kolbeck Kjær Heckmann on 3/8/19.
//  Copyright © 2019 -. All rights reserved.
//

import UIKit
import Foundation

class YTScreenCell: UICollectionViewCell {
    // 1.3 ration
    static let imageWidth = 480
    static let imageHeight = 360
    
    static let cellWidth = 480
    static let cellHeight = 360
    
    let screenView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width:imageWidth, height:imageHeight))
        imageView.image = UIImage()
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let activityView: UIActivityIndicatorView = {
        let acView = UIActivityIndicatorView(style: .white)
        acView.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight)
        acView.hidesWhenStopped = true
        acView.color = .white
        
        return acView
    }()
    
    let playButton: UIButton = {
        let playImage = UIImage(named: "play.png")
        let playButton   = UIButton(type: UIButton.ButtonType.system) as UIButton
        playButton.frame = CGRect(x: (cellWidth - 125) / 2, y: (cellHeight - 75) / 2, width: 125, height:75)
        playButton.setImage(playImage, for: .normal)
        playButton.isHidden = true
        
        return playButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        backgroundColor = UIColor.black
        addSubview(screenView)
        addSubview(activityView)
        addSubview(playButton)
    }
    
    func startActivityAnimating() {
        playButton.isHidden = true
        activityView.startAnimating()
    }
    
    func stopActivityAnimating() {
        playButton.isHidden = false
        activityView.stopAnimating()
    }
}
