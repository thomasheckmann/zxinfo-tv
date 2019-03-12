//
//  ZXDBRandom.swift
//  tvOS
//
//  Created by Thomas Ahn Kolbeck Kjær Heckmann on 3/8/19.
//  Copyright © 2019 -. All rights reserved.
//

import UIKit

let number_of_items = 33

class ZXDBRandom {
    enum Error: Swift.Error {
        case unknownAPIResponse
        case generic
    }
    
    func zxdbGetRandom(for searchTerm: String, completion: @escaping (Result<ZXDBSearchResults>) -> Void) {
        guard let searchURL = zxdbRandomURL(for: searchTerm) else {
            completion(Result.error(Error.unknownAPIResponse))
            return
        }
        
        let searchRequest = URLRequest(url: searchURL)
        
        // disable cache for NSUrlSessionTask
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession.init(configuration: config)
        session.dataTask(with: searchRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.error(error))
                }
                return
            }
            
            guard
                let _ = response as? HTTPURLResponse,
                let data = data
                else {
                    DispatchQueue.main.async {
                        completion(Result.error(Error.unknownAPIResponse))
                    }
                    return
            }
            
            do {
                // check if response is recognized, must contains the "hits" propery
                guard
                    let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject]
                    else {
                        DispatchQueue.main.async {
                            print("Error in returned JSON")
                            completion(Result.error(Error.unknownAPIResponse))
                        }
                        return
                }
                
                guard
                    let hitsContainer = resultsDictionary["hits"] as? [String: AnyObject],
                    let hitsReceived = hitsContainer["hits"] as? [[String: AnyObject]]
                    else {
                        DispatchQueue.main.async {
                            print("Error in hits returned #2")
                            completion(Result.error(Error.unknownAPIResponse))
                        }
                        return
                }
                
                let zxdbEntries: [ZXDBEntry] = hitsReceived.compactMap { zxdbObject in
                    guard
                        let source = zxdbObject["_source"],
                        let entryID = zxdbObject["_id"] as? String,
                        let fulltitle = source["fulltitle"] as? String,
                        let machinetype = source["machinetype"] as? String,
                        let genre = source["type"] as? String,
                        let subgenre = source["subtype"] as? String,
                        let screens = source["screens"] as? [[String: Any]],
                        let publisher = source["publisher"] as? [[String: Any]]
                        else {
                            print("ZXDBEntry - something is missng: \(String(describing: zxdbObject))")
                            return nil
                    }
                    
                    var yofl: Int
                    if let yearofrelease = source["yearofrelease"] as? Int {
                        yofl = yearofrelease
                    } else {
                        yofl = 0
                    }
                    
                    let zxdbEntry = ZXDBEntry(entryID: entryID, fulltitle: fulltitle, yearofrelease: yofl, machinetype: machinetype, genre: genre, subgenre: subgenre, screens: screens, publisher: publisher)
                    
                    guard
                        let url = zxdbEntry.loadingScreenURL(),
                        let imageData = try? Data(contentsOf: url as URL)
                        else {
                            return nil
                    }
                    
                    if let image = UIImage(data: imageData) {
                        zxdbEntry.thumbnail = image
                        return zxdbEntry
                    } else {
                        return nil
                    }
                }
                
                let searchResults = ZXDBSearchResults(searchTerm: searchTerm, searchResults: zxdbEntries)
                DispatchQueue.main.async {
                    completion(Result.results(searchResults))
                }
            } catch {
                completion(Result.error(error))
                return
            }
            }.resume()
    }
    
    private func zxdbRandomURL(for searchTerm:String) -> URL? {
        let URLString = "https://api.zxinfo.dk/api/zxinfo/games/randomwithvideos/\(number_of_items)?mode=tiny"
        print("URL: \(URLString)")
        return URL(string:URLString)
    }
}
