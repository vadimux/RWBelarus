//
//  SearchViewInteractor.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit
import FeedKit

class SearchViewInteractor: SearchViewControllerInteractor {
    
    var fromData: AutocompleteAPIElement?
    var toData: AutocompleteAPIElement?
    var newsItems: [RSSFeedItem]? {
        return configureNews()
    }
    
    func configureSearchButtonState(with elements: [AutocompleteAPIElement?]) -> Bool {
        let countEmpty = elements.reduce(0) { $1 == nil ? $0 + 1 : $0 }
        return countEmpty == 0
    }
    
    func configureNews() -> [RSSFeedItem]? {
        let feedURL = URL(string: "https://www.rw.by/rss/")!
        let parser = FeedParser(URL: feedURL)
        switch parser.parse() {
        case let .rss(feed):
            for i in feed.items! {
                print(i.title)
                print(i.description)
                print(i.link)
            }
            return feed.items
        default:
            return nil
        }
    }
}
