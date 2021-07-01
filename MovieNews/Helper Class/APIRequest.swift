//
//  APIRequest.swift
//  MovieNews
//
//  Created by Kevin Huang on 01/07/21.
//

import Foundation
import RxSwift

public enum RequestType: String {
    case GET, POST, PUT, DELETE
}

class APIRequest {
    let baseURL = URL(string: "https://ghibliapi.herokuapp.com/films")!
    var method = RequestType.GET
    var parameters = [String: String]()
    
    func request(with baseURl: URL) -> URLRequest {
        var request = URLRequest(url: baseURl)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

class APICalling {
    var models = [MovieModel]()
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: apiRequest.baseURL)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                do {
                    let models: [MovieModel] = try JSONDecoder().decode([MovieModel].self, from: data ?? Data())
                    self?.models = models
                    observer.onNext( self?.models as! T)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            })
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func filterBy<T: Codable>(query: String) -> Observable<T> {
        return Observable<T>.create { observer in
            do {
                self.models = self.models.filter { model in
                    model.release_date == query
                }
                observer.onNext( self.models as! T)
            }
            observer.onCompleted()
            
            return Disposables.create {
                
            }
        }
    }
}
