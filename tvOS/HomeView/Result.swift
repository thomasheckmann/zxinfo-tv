//
//  AboutViewController.swift
//  tvOS
//
//  Created by Thomas Ahn Kolbeck Kjær Heckmann on 3/8/19.
//  Copyright © 2019 -. All rights reserved.
//

import Foundation

enum Result<ResultType> {
    case results(ResultType)
    case error(Error)
}
