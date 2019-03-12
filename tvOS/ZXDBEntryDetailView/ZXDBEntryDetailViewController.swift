//
//  ZXDBEntryDetailViewController.swift
//  tvOS
//
//  Created by Thomas Ahn Kolbeck Kjær Heckmann on 3/8/19.
//  Copyright © 2019 -. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import XCDYouTubeKit

class ZXDBEntryDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var entryID: String?
    var titleLabel: UILabel!
    var machinetypeLabel: UILabel!
    var yearPublisherLabel: UILabel!
    var remarksLabel: UILabel!
    
    let safeAreaTop = 60
    let safeAreaSide = 90
    
    let debugBorder = CGFloat(0.0)
    
    // screen collectionview
    var scrCollectionview: UICollectionView!
    var scrCellId = "screenCell"
    var screenUrls: [[String: AnyObject]] = [[:]]
    
    // YouTube videos
    var ytCollectionview: UICollectionView!
    var ytCellId = "screenCell"
    var ytThumbnailUrls: [[String: AnyObject]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup view
        self.view.backgroundColor = .black
        
        // Title
        let titleLabelWidth = 2 * self.view.frame.size.width / 3
        
        titleLabel = UILabel(frame: CGRect(x: safeAreaSide, y: safeAreaTop, width: Int(titleLabelWidth), height: 200))
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont.systemFont(ofSize: 56)
        titleLabel.textColor = .white
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        titleLabel.layer.shadowOpacity = 2.0
        titleLabel.layer.shadowRadius = 2.0
        var titleFrame: CGRect = titleLabel.frame
        titleFrame.origin.y = 208.0 - titleLabel.frame.size.height
        titleLabel.frame = titleFrame
        titleLabel.layer.borderWidth = debugBorder
        titleLabel.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(titleLabel)
        
        // Machine, Year & Publisher offset
        let metaData1YOffset = Int(titleLabel.frame.origin.y + titleLabel.frame.size.height)
        machinetypeLabel = UILabel(frame: CGRect(x: safeAreaSide, y: metaData1YOffset, width: 400, height: 50))
        machinetypeLabel.textColor = .white
        machinetypeLabel.numberOfLines = 0
        machinetypeLabel.lineBreakMode = .byWordWrapping
        machinetypeLabel.font = UIFont.systemFont(ofSize: 36)
        machinetypeLabel.textColor = .white
        machinetypeLabel.layer.borderWidth = debugBorder
        machinetypeLabel.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(machinetypeLabel)
        
        // Release year + Publisher
        let metaData2XOffset = Int(machinetypeLabel.frame.origin.x + machinetypeLabel.frame.size.width)
        let metaData2Width = Int(titleLabel.frame.size.width - machinetypeLabel.frame.size.width)
        yearPublisherLabel = UILabel(frame: CGRect(x: metaData2XOffset, y: metaData1YOffset, width: metaData2Width, height: 50))
        yearPublisherLabel.textColor = .white
        yearPublisherLabel.numberOfLines = 0
        yearPublisherLabel.lineBreakMode = .byClipping
        yearPublisherLabel.font = UIFont.systemFont(ofSize: 36)
        yearPublisherLabel.layer.borderWidth = debugBorder
        yearPublisherLabel.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(yearPublisherLabel)
        
        // screenCollection
        let scrLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        scrLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrLayout.itemSize = CGSize(width: ZXDBEntryCell.imageWidth, height: ZXDBEntryCell.imageHeight)
        
        let metaData8YOffset = Int(titleLabel.frame.origin.y)
        let metaData8XOffset = Int(self.view.frame.width) - ZXDBEntryCell.imageWidth - safeAreaSide
        let metaData8Width = ZXDBEntryCell.imageWidth
        
        // screens
        scrCollectionview = UICollectionView(frame: CGRect(x: metaData8XOffset, y: metaData8YOffset, width: metaData8Width, height: 750), collectionViewLayout: scrLayout)
        
        scrCollectionview.dataSource = self
        scrCollectionview.delegate = self
        scrCollectionview.register(ZXDBEntryCell.self, forCellWithReuseIdentifier: scrCellId)
        scrCollectionview.showsVerticalScrollIndicator = false
        scrCollectionview.backgroundColor = .clear
        
        self.view.addSubview(scrCollectionview)
        
        // YT
        let ytLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        ytLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        ytLayout.itemSize = CGSize(width: YTScreenCell.cellWidth, height: YTScreenCell.cellHeight)
        ytLayout.scrollDirection = .horizontal
        ytLayout.minimumInteritemSpacing = 10.0
        
        let ytFrameX = safeAreaSide
        let ytFrameY = 9 + Int(scrCollectionview.frame.height) - YTScreenCell.cellHeight
        let ytFrameW = Int(YTScreenCell.cellWidth * 2) + 2 * safeAreaSide
        
        let ytFrameH = YTScreenCell.cellHeight
        ytCollectionview = UICollectionView(frame: CGRect(x: ytFrameX, y: ytFrameY, width: ytFrameW, height: ytFrameH), collectionViewLayout: ytLayout)
        
        ytCollectionview.dataSource = self
        ytCollectionview.delegate = self
        ytCollectionview.register(YTScreenCell.self, forCellWithReuseIdentifier: ytCellId)
        ytCollectionview.showsVerticalScrollIndicator = false
        ytCollectionview.backgroundColor = .clear
        
        // logo image
        if let logoImage = UIImage(named: "stribes") {
            let logoImageView = UIImageView(frame: CGRect(x:self.view.frame.width - logoImage.size.width, y:self.view.frame.height - logoImage.size.height, width: logoImage.size.width, height: logoImage.size.height))
            logoImageView.image = logoImage
            
            self.view.addSubview(logoImageView)
        }

        
        self.view.addSubview(ytCollectionview)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let id = entryID else {
            return
        }
        getZXDBEntryDetail(id: id)
    }
    
    @objc func playMovie() {
        print("playMovie()")
    }
    
    func getZXDBEntryDetail(id: String) {
        //Implementing URLSession
        let urlString = "https://api.zxinfo.dk/api/zxinfo/games/\(id)?mode=full"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard
                let data = data
                else {
                    return
            }
            
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data) as! [String: AnyObject]
                guard
                    let source = resultsDictionary["_source"]
                    else {
                        print("ZXDBEntry - something is missng: \(String(describing: resultsDictionary))")
                        return
                }
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    let fulltitle = source["fulltitle"] as! String
                    self.titleLabel.text = fulltitle
                    
                    if let machinetype = source["machinetype"] as? String {
                        self.machinetypeLabel.text = machinetype
                    }
                    
                    // TODO: Handle multiple publishers
                    var yearPublisher: String = ""
                    if let year = source["yearofrelease"] as? Int{
                        yearPublisher = "\(year) - "
                    } else {
                        yearPublisher = "N/A - "
                    }
                    
                    if let publisher = source["publisher"] as? [[String: AnyObject]], publisher.count > 0, let pub = publisher[0]["name"] as? String {
                        yearPublisher += pub
                    }else {
                        yearPublisher += "N/A"
                    }
                    self.yearPublisherLabel.text = yearPublisher
                    
                    //                    if let remarks = source["remarks"] as? String {
                    //                        self.remarksLabel.text = remarks
                    //                        self.remarksLabel.sizeToFit()
                    //                    }
                    
                    // Screen URLS
                    if let screens = source["screens"] as? [[String: AnyObject]], screens.count > 0 {
                        self.screenUrls = screens
                    } else {
                        self.screenUrls = [[:]]
                    }
                    self.scrCollectionview.reloadData()
                    
                    // Youtube URLS
                    if let ytlinks = source["youtubelinks"] as? [[String: AnyObject]], ytlinks.count > 0 {
                        self.ytThumbnailUrls = ytlinks
                    } else {
                        self.ytThumbnailUrls = [[:]]
                    }
                    self.ytCollectionview.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    //
    // CollectionView stuff for screens
    func collectionView(_ collectionView: UICollectionView,
                        didUpdateFocusIn context: UICollectionViewFocusUpdateContext,
                        with coordinator: UIFocusAnimationCoordinator) {
        
        if (collectionView == self.ytCollectionview) {
            if let previousIndexPath = context.previouslyFocusedIndexPath,
                let cell = collectionView.cellForItem(at: previousIndexPath) as? YTScreenCell {
                
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
            if let indexPath = context.nextFocusedIndexPath,
                let cell = collectionView.cellForItem(at: indexPath) as? YTScreenCell {
                collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
                cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.scrCollectionview) {
            return screenUrls.count
        } else {
            return ytThumbnailUrls.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == self.scrCollectionview) {
            let cell = scrCollectionview.dequeueReusableCell(withReuseIdentifier: scrCellId, for: indexPath) as! ZXDBEntryCell
            
            cell.backgroundColor = .clear
            
            if let screenTitle = screenUrls[indexPath.row]["title"] as? String {
                cell.labelTitle.text = screenTitle
                cell.labelTitle.textColor = .white
            }
            
            guard
                let path = screenUrls[indexPath.row]["url"] as? String
                
                else {
                    cell.imageView.image = UIImage()
                    cell.activityView.stopAnimating()
                    return cell
            }
            
            cell.activityView.startAnimating()
            if path.starts(with: "/zxscreen/") {
                if let url = URL(string: "https://zxinfo.dk/media\(path)"),
                    let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                    cell.imageView.image = image
                } else {
                    print("NOT FOUND \(String(describing: path))")
                }
            } else {
                let newpath = path.replacingOccurrences(of: "/pub/sinclair/", with: "/thumbs/")
                if let url = URL(string: "https://zxinfo.dk/media\(newpath)"),
                    let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                    cell.imageView.image = image
                    cell.activityView.stopAnimating()
                } else {
                    print("NOT FOUND \(String(describing: path))")
                }
            }
            
            return cell
        } else {
            let cell = ytCollectionview.dequeueReusableCell(withReuseIdentifier: scrCellId, for: indexPath) as! YTScreenCell
            
            cell.backgroundColor = .clear
            guard
                let path = ytThumbnailUrls[indexPath.row]["link"] as? String
                else {
                    cell.screenView.image = UIImage()
                    return cell
            }
            
            cell.startActivityAnimating()
            // get cover image....
            XCDYouTubeClient.default().getVideoWithIdentifier(path.youtubeID) { (video, error) in
                if let ytThumbUrl = URL(string: "https://i.ytimg.com/vi/\(path.youtubeID!)/hqdefault.jpg"),
                    let imageData = try? Data(contentsOf: ytThumbUrl), let image = UIImage(data: imageData) {
                    print(ytThumbUrl)
                    let ytTitle: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: image.size.width, height: 50))
                    ytTitle.lineBreakMode = .byTruncatingTail
                    ytTitle.font = UIFont.systemFont(ofSize: 32)
                    ytTitle.text = video?.title
                    ytTitle.textColor = .white
                    
                    cell.screenView.image = UIImage.createImageWithLabelOverlay(label: ytTitle, imageSize: CGSize(width: image.size.width, height: image.size.height), image: image)
                    
                    let imgXOffset = (YTScreenCell.cellWidth - Int(390)) / 2
                    let imgYOffset = (YTScreenCell.cellHeight - Int(300)) / 2
                    cell.screenView.frame = CGRect(x: imgXOffset, y: imgYOffset, width: 390, height: 300)
                    cell.stopActivityAnimating()
                } else {
                    print("NOT FOUND \(String(describing: path.youtubeID))")
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == self.ytCollectionview) {
            if let path = ytThumbnailUrls[indexPath.row]["link"] as? String {
                playVideo(videoIdentifier: path.youtubeID)
            }
        }
    }
    
    struct YouTubeVideoQuality {
        static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
        static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
        static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
    }
    
    let playerViewController = AVPlayerViewController()
    func playVideo(videoIdentifier: String?) {
        playerViewController.modalPresentationStyle = .overCurrentContext
        playerViewController.modalTransitionStyle = .crossDissolve
        self.present(playerViewController, animated: true, completion: nil)
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoIdentifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
            if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
                playerViewController?.player = AVPlayer(url: streamURL)
                playerViewController?.player?.play()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
}

extension UIImage {
    
    class func createImageWithLabelOverlay(label: UILabel,imageSize: CGSize, image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageSize.width, height: imageSize.height), false, 2.0)
        let currentView = UIView.init(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let currentImage = UIImageView.init(image: image)
        currentImage.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        currentView.addSubview(currentImage)
        currentView.addSubview(label)
        currentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
}
