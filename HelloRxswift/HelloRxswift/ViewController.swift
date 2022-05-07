//
//  ViewController.swift
//  HelloRxswift
//
//  Created by 김희진 on 2022/03/25.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        _ = Observable.from([1,2,3,4,5])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? PhotoCollectionViewController else{
            fatalError("destination is not found")
        }
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }
    
    @IBAction func applyFilterButtonPressed(){
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filterdImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filterdImage
                }
            }).disposed(by: disposeBag)
        
//        FilterService().applyFilter(to: sourceImage){ filterImage in
//            DispatchQueue.main.async {
//                self.photoImageView.image = filterImage
//            }
//        }
    }

}

