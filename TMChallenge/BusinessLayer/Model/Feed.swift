//
//  Feed.swift
//  TMChallenge
//
//  Created by Jose Galindo Martinez on 02/11/21.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    let kind: String
    let data: T
}

struct  FeedResponseData: Codable {
    let after: String
    let dist: Int
    let children: [GenericResponse<FeedData>]
    // has more properties but we don't need it for this
}

struct FeedData: Codable {
    let title: String
    let numComments: Int
    let score: Int
    let thumbnail: String
    let thumbnailWidth: Int?
    let thumbnailHeight: Int?
}


