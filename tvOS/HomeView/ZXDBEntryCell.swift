//
//  ZXDBEntryCell.swift
//  tvOS
//
//  Created by Thomas Ahn Kolbeck Kjær Heckmann on 3/8/19.
//  Copyright © 2019 -. All rights reserved.
//

import UIKit

class ZXDBEntryCell: UICollectionViewCell {
    static let imageWidth = 480
    static let imageHeight = 360
    
    static let cellWidth = 480
    static let cellHeight = 360
    
    var entryId: String!
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        imageView.backgroundColor = .clear
        imageView.image = UIImage()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let labelTitle: UILabel = {
        let labelFrame:CGRect = CGRect(x: -40, y:Int(imageHeight + 15), width:imageWidth + 80, height: 40)
        let labelTitle = UILabel(frame: labelFrame)
        labelTitle.text = "..."
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont.boldSystemFont(ofSize: 32.0)
        labelTitle.textColor = UIColor.black
        
        return labelTitle
    }()
    
    let activityView: UIActivityIndicatorView = {
        let acView = UIActivityIndicatorView(style: .white)
        acView.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight)
        acView.hidesWhenStopped = true
        acView.color = .white
        acView.stopAnimating()
        
        return acView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        addSubview(imageView)
        addSubview(labelTitle)
        addSubview(activityView)
    }
}
