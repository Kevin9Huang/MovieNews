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
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        let request = APIRequest()
//        self.result = self.apiCalling.send(apiRequest: request)
        
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
                    let pickerView = self.createPickerView()
                    self.textField.inputView = pickerView
                    self.configureTextField(pickerView: pickerView)
                    self.configureTableView(pickerView: pickerView)
                }
            }).disposed(by: disposeBag)
        
//        guard let result = result else {
//            return
//        }
//        _ = result.bind(to: tableView.rx.items(cellIdentifier: "MovieTableViewCell")) {( row, model, cell) in
//            guard let cell = cell as? MovieTableViewCell else {
//                return
//            }
//            cell.titleLabel.text = model.title
//            cell.descriptionLabel.text = model.description
//            cell.directedByLabel.text = model.director
//            cell.yearLabel.text = model.release_date
//        }
//        .disposed(by: disposeBag)
        
        //        searchTextView.rx.text
        //            .orEmpty
        //            .subscribe(onNext: {query in
        //
        //            }).disposed(by: disposeBag)
    }
    
    func configureTableView() {
        let movieList = Observable.just(self.posts)
        Observable.combineLatest(movieList, searchTextView.rx.text)
            .map { (list,query) -> [MovieModel] in
                return self.posts.filter {
                    $0.release_date == query
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
    func createPickerView() -> UIPickerView {
        let pickerView = UIPickerView()
        Observable.just(self.posts)
            .bind(to: pickerView.rx.itemTitles) { row, element in
                return element.release_date
            }
            .disposed(by: disposeBag)
        return pickerView
    }
    
    func configureTextField(pickerView: UIPickerView) {
        pickerView.rx.itemSelected
            .map { self.posts[$0.row].release_date }
            .bind(to: self.textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    func configureTableView(pickerView: UIPickerView) {
        let recipeList = Observable.just(self.posts)
        Observable.combineLatest(recipeList, pickerView.rx.itemSelected.map { $0.row })
            .map { (list, selected) -> [MovieModel] in
                guard selected != 0 else { return list }
                let movieSelected = self.posts[selected]
                
                return self.posts.filter {
                    $0.release_date == movieSelected.release_date
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
extension HomeViewController { //should be at view model
    
    
}

