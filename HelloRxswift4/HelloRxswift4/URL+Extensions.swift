//
//  URL+Extensions.swift
//  HelloRxswift4
//
//  Created by 김희진 on 2022/03/27.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(to city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=ae81a7694bd7e08f52fe5e78fc0a04d6&units=imperial")
    }
}
