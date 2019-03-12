//
//  HomeViewController.swift
//  tvOS
//
//  Created by Thomas Ahn Kolbeck Kjær Heckmann on 3/8/19.
//  Copyright © 2019 -. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private let reuseIdentifier = "ZXDBEntryCell"
    private var searches: [ZXDBSearchResults] = []
    private let zxdbService = ZXDBRandom()
    
    var collectionView: UICollectionView!
    
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func loadView() {
        super.loadView()
    }
    
    private func getRandomFromZXDB() {
        self.spinner.startAnimating()
        // get data from API
        searches = []
        self.collectionView.reloadData()
        zxdbService.zxdbGetRandom(for: "") { searchResults in
            switch searchResults {
            case .error(let error) :
                print("Error Searching: \(error)")
            case .results(let results):
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                self.searches.insert(results, at: 0)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.spinner.stopAnimating()
                }
            }
        }
    }
    
    @objc func refreshColletion() {
        getRandomFromZXDB()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCollectionView()
        
        // setup spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // setup tv-remote play/pause
        let playPauseRecognizer = UITapGestureRecognizer(target: self, action: #selector(refreshColletion))
        playPauseRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        
        view.addGestureRecognizer(playPauseRecognizer)
        
        // get data from API
        getRandomFromZXDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30.0
        layout.minimumInteritemSpacing = 10.0
        layout.itemSize = CGSize(width: 500, height:450)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right:90)
        
        collectionView = UICollectionView(frame:self.view.frame, collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.remembersLastFocusedIndexPath = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // register collection view elements
        collectionView.register(ZXDBEntryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searches.count == 0 {
            return 0
        }
        return searches[section].searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ZXDBEntryCell
        
        let item = searches[0].searchResults[indexPath.item]
        let thumbnail = searches[0].searchResults[indexPath.item].thumbnail
        
        cell.tag = indexPath.item
        cell.isSelected = false
        cell.isHighlighted = false
        cell.entryId = item.entryID
        
        cell.labelTitle.text = item.fulltitle
        
        cell.imageView.image = thumbnail
        
        return cell
    }
    
    let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
    let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
    
    func collectionView(_ collectionView: UICollectionView,
                        didUpdateFocusIn context: UICollectionViewFocusUpdateContext,
                        with coordinator: UIFocusAnimationCoordinator) {
        
        horizontalMotionEffect.minimumRelativeValue = -10
        horizontalMotionEffect.maximumRelativeValue = 10
        verticalMotionEffect.minimumRelativeValue = -10
        verticalMotionEffect.maximumRelativeValue = 10
        
        if let previousIndexPath = context.previouslyFocusedIndexPath,
            let cell = collectionView.cellForItem(at: previousIndexPath) as? ZXDBEntryCell {
            
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.contentView.layer.shadowOpacity = 0
            cell.contentView.layer.shadowRadius = 0.0
            
            cell.removeMotionEffect(horizontalMotionEffect)
            cell.removeMotionEffect(verticalMotionEffect)
        }
        
        if let indexPath = context.nextFocusedIndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? ZXDBEntryCell {
            
            collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
            cell.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 8
            
            cell.addMotionEffect(horizontalMotionEffect)
            cell.addMotionEffect(verticalMotionEffect)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = searches[0].searchResults[indexPath.item]
        let detailVC = ZXDBEntryDetailViewController()
        detailVC.entryID = item.entryID
        detailVC.modalPresentationStyle = .overCurrentContext
        detailVC.modalTransitionStyle = .crossDissolve
        self.present(detailVC, animated: true, completion: nil)
    }
}

