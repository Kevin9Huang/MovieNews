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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        tableView.bounds = view.bounds
        
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        let request = APIRequest()
        let result : Observable<[MovieModel]> = self.apiCalling.send(apiRequest: request)
        _ = result.bind(to: tableView.rx.items(cellIdentifier: "MovieTableViewCell")) { [weak self] ( row, model, cell) in
            guard let cell = cell as? MovieTableViewCell else {
                return
            }
            cell.titleLabel.text = model.title
            cell.descriptionLabel.text = model.description
            cell.directedByLabel.text = model.director
            cell.yearLabel.text = model.release_date
        }
        .disposed(by: disposeBag)
    }


}

