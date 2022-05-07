//
//  NewsTableViewController.swift
//  HelloRxswift5
//
//  Created by 김희진 on 2022/03/28.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {

    let disposeBag = DisposeBag()
    private var articleListViewModel: ArticleListViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=5d33fcc1a29245a28058d949c7f6e964")!

        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        populateNews()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleListViewModel == nil ? 0 : articleListViewModel.articlesVM.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("not found")
        }
        
        let articleVM = self.articleListViewModel.articleAt(indexPath.row)
        articleVM.title.asDriver(onErrorJustReturn: "" )
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        articleVM.description.asDriver(onErrorJustReturn: "" )
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        return cell
        
    }
    
    private func populateNews(){
        
        let resource = Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=5d33fcc1a29245a28058d949c7f6e964")!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { articleResponse in
                let article = articleResponse.articles
                self.articleListViewModel = ArticleListViewModel(article)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag)
        
    }
    
}

