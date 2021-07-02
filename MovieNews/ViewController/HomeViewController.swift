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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextView: UITextView!
    @IBOutlet weak var searchContainerView: UIView!

    //Private var
    private var homeViewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    private var movieModels = PublishSubject<[MovieModel]>()
    
    required init(viewModel: HomeViewModel) {
        self.homeViewModel = viewModel
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.onViewDidLoad()
        
        setUpContainerView()
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        setUpBinding()
    }
    
    func setUpContainerView() {
        self.searchContainerView.layer.borderWidth = 1.0
        self.searchContainerView.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        self.searchContainerView.layer.cornerRadius = 12
        self.searchContainerView.layer.masksToBounds = true
    }
    
    func setUpBinding() {
        homeViewModel
            .moviePublishArr
            .observe(on: MainScheduler.instance)
            .bind(to: self.movieModels)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(movieModels, searchTextView.rx.text)
            .map { (list,query) -> [MovieModel] in
                guard let query = query,
                      !query.isEmpty else {
                    return list
                }
                return list.filter {
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

