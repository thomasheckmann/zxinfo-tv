//
//  ZXDBEntry.swift
//  tvOS
//
//  Created by Thomas Ahn Kolbeck Kjær Heckmann on 3/8/19.
//  Copyright © 2019 -. All rights reserved.
//

import UIKit

class ZXDBEntry: Equatable {
    var thumbnail: UIImage?
    var largeImage: UIImage?
    
    let entryID: String
    let fulltitle: String
    let yearofrelease: Int
    let publisher: [[String: Any]]
    let machinetype: String
    let genre: String
    let subgenre: String
    let screens: [[String: Any]]
    
    init (entryID: String, fulltitle: String, yearofrelease: Int, machinetype: String, genre: String, subgenre: String, screens:[[String: Any]], publisher: [[String: Any]]) {
        self.entryID = entryID
        self.fulltitle = fulltitle
        self.yearofrelease = yearofrelease
        self.publisher = publisher
        self.machinetype = machinetype
        self.genre = genre
        self.subgenre = subgenre
        self.screens = screens
    }
    
    func loadingScreenURL(_ size: String = "m") -> URL? {
        if let loadingScreenURL = screens[0]["url"]
        {
            let url = URL(string: "https://zxinfo.dk/media\(loadingScreenURL)")
            return url
        }
        return nil
    }
    
    func runningScreenURL(_ size: String = "m") -> URL? {
        
        return nil
    }
    
    enum Error: Swift.Error {
        case invalidURL
        case noData
    }
    
    static func ==(lhs: ZXDBEntry, rhs: ZXDBEntry) -> Bool {
        return lhs.entryID == rhs.entryID
    }
}
