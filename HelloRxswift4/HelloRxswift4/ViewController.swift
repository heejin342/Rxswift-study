//
//  ViewController.swift
//  HelloRxswift4
//
//  Created by 김희진 on 2022/03/27.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextFiled: UITextField!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var humadityLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameTextFiled.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map{ self.cityNameTextFiled.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    }else {
                        self.fetchWeather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
        
//        cityNameTextFiled.rx.value
//            .subscribe(onNext: { city in
//
//                if let city = city {
//                    if city.isEmpty {
//                        self.displayWeather(nil)
//                    }else {
//                        self.fetchWeather(by: city)
//                    }
//                }
//
//            }).disposed(by: disposeBag)
    }

    private func fetchWeather(by city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL.urlForWeatherAPI(to: cityEncoded) else {
            return
        }
        
        let resource = Resource<WearherResult>(url:url)

        /* 이부분이 아래 내용으로 비뀔거임
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: WearherResult.empty)
//            .catchErrorJustReturn(WearherResult.empty)
//            .subscribe(onNext: {result in
//
//                let weather = result.main
//                self.displayWeather(weather)
//
//            }).disposed(by: disposeBag)
         */
        
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .retry(3) // 3번만 시도. 와이파이끄고 하면 3번까지 시도하게 됨
            .catchError {error in
                print(error.localizedDescription)
                return Observable.just(WearherResult.empty)
            }.asDriver(onErrorJustReturn: WearherResult.empty)
        
        search.map { "\($0.main.temp) F" }
//            .bind(to: tempratureLabel.rx.text) // catchErrorJustReturn 없애고 asDriver 을 쓴이상 바꿔줘야함
            .drive(self.tempratureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map { "\($0.main.humidity) ...ㅠ" }
            .drive(humadityLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func displayWeather(_ weather: Weather?) {
        if let weather = weather {
            self.tempratureLabel.text = "\(weather.temp) F"
            self.humadityLabel.text = "\(weather.humidity) ...ㅠ "
        }else { // nil 일때
            self.tempratureLabel.text = "히히"
            self.humadityLabel.text = "없어요"
        }
    }
}
