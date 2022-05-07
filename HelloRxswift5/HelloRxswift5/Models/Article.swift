//
//  Article.swift
//  HelloRxswift5
//
//  Created by 김희진 on 2022/03/28.
//

import Foundation

struct ArticleResponse: Decodable {
    let articles: [Article]
}


struct Article: Decodable {
    let title: String
    let description: String?
}
