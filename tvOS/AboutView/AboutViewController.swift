//
//  AboutViewController.swift
//  tvOS
//
//  Created by Thomas Ahn Kolbeck Kjær Heckmann on 3/8/19.
//  Copyright © 2019 -. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let zxdbImage = UIImage(named: "ZXDB_8.png") {
            let zxdbImageView = UIImageView(frame: CGRect(x:100, y:200, width: zxdbImage.size.width, height: zxdbImage.size.height))
            zxdbImageView.image = zxdbImage
            
            self.view.addSubview(zxdbImageView)
        }
        
        let zxdbLabel = UILabel(frame: CGRect(x: 300, y:200, width: 1200, height: 500))
        zxdbLabel.font = UIFont(name: (zxdbLabel.font?.fontName)!, size: 32)
        zxdbLabel.numberOfLines = 0
        zxdbLabel.backgroundColor = .clear
        zxdbLabel.lineBreakMode = .byWordWrapping
        zxdbLabel.text = NSLocalizedString("about_zxdb", comment: "")
        zxdbLabel.sizeToFit()
        self.view.addSubview(zxdbLabel)
    }
}

