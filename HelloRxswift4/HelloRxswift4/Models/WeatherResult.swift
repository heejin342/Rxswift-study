//
//  WeatherResult.swift
//  HelloRxswift4
//
//  Created by 김희진 on 2022/03/27.
//

import Foundation

struct WearherResult: Decodable {
    let main: Weather
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}

extension WearherResult {
    static var empty: WearherResult {
        return WearherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}

