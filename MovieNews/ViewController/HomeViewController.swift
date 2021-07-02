//
//  ViewController.swift
//  MovieNews
//
//  Created by Kevin Huang on 01/07/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    private let apiCalling = APICalling()
    private let disposeBag = DisposeBag()
    private var result : Observable<[MovieModel]>?
    var posts: [MovieModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextView: UITextView!
    @IBOutlet weak var searchContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpContainerView()
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        let request = APIRequest()
        self.apiCalling.send(apiRequest: request).subscribe(
            onNext: {[weak self] result in
                self?.posts = result
            },
            onError: { error in
                print(error.localizedDescription)
            },
            onCompleted: {
                print("Completed")
                DispatchQueue.main.async {
                    self.setUpBinding()
                }
            }).disposed(by: disposeBag)
    }
    
    func setUpContainerView() {
        self.searchContainerView.layer.borderWidth = 1.0
        self.searchContainerView.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        self.searchContainerView.layer.cornerRadius = 12
        self.searchContainerView.layer.masksToBounds = true
    }
    
    func setUpBinding() {
        let movieList = Observable.just(self.posts)
        Observable.combineLatest(movieList, searchTextView.rx.text)
            .map { (list,query) -> [MovieModel] in
                guard let query = query,
                      !query.isEmpty else {
                    return self.posts
                }
                return self.posts.filter {
                    $0.release_date.hasPrefix(query)
                }
            }
            .bind(to: tableView.rx.items(cellIdentifier: "MovieTableViewCell",
                                         cellType: MovieTableViewCell.self)) { row, model, cell in
                cell.titleLabel.text = model.title
                cell.descriptionLabel.text = model.description
                cell.directedByLabel.text = model.director
                cell.yearLabel.text = model.release_date
            }
            .disposed(by: disposeBag)
    }
}

