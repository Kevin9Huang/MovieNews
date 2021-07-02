//
//  HomeViewModelTest.swift
//  MovieNewsTests
//
//  Created by Kevin Huang on 02/07/21.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxBlocking

@testable import MovieNews

extension TestScheduler {
    /**
     Creates a `TestableObserver` instance which immediately subscribes to the `source`
     */
    func record<O: ObservableConvertibleType>(
        _ source: O,
        disposeBag: DisposeBag
    ) -> TestableObserver<O.Element> {
        let observer = self.createObserver(O.Element.self)
        source
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        return observer
    }
}


class HomeViewModelTest: XCTestCase {
    var viewModel: HomeViewModel!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        viewModel = HomeViewModel()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func testOnViewdidLoad() throws {
        
        let testModels = [MovieModel]()
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.moviePublishArr)
        
        let scheduler = TestScheduler(initialClock: 0)
        let movieObserver = scheduler.createObserver([MovieModel].self)
        var records : Observable<[MovieModel]>
        let output: () = viewModel.onViewDidLoad()
        let mockMovieModel = MovieModel(title: "Movie Title", description: "Movie title used for testing", release_date: "2021", director: "kevin")
        
        viewModel.moviePublishArr
            .bind(to: movieObserver)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(10) {
            self.viewModel.moviePublishArr.onNext([mockMovieModel, mockMovieModel])
        }
        
        scheduler.start()
        
        XCTAssertEqual(movieObserver.events, [.next(10, [mockMovieModel, mockMovieModel])])
    }
}

extension MovieModel: Equatable {
    public static func ==(lhs: MovieModel, rhs: MovieModel) -> Bool {
        return lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.release_date == rhs.release_date &&
            lhs.director == rhs.director
        
    }
}
