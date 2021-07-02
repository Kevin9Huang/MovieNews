//
//  HomeViewModel.swift
//  MovieNews
//
//  Created by Kevin Huang on 02/07/21.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    //Private var
    private let apiCalling = APICalling()
    private let disposeBag = DisposeBag()
    private var posts: [MovieModel] = []
    
    //Public var
    public var moviePublishArr : PublishSubject<[MovieModel]> = PublishSubject()
    
    public func onViewDidLoad() {
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
                self.moviePublishArr.onNext(self.posts)
            }).disposed(by: disposeBag)
    }
}
