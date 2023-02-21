//
//  CatService.swift
//  catcrawler
//
//  Created by 김혜주 on 2023/02/17.
//



import Foundation


struct CatResponse: Codable {
    let id: String
    let url: String
    let width: Int
    let height: Int
} //Codable 구조체 생성

final class CatService {
    
    
    enum RequestError: Error {
        case networkError
    }
    
    func getCats(
        page: Int,
        limit: Int,
        completion: @escaping (Result<[CatResponse], RequestError>) -> Void
        // @escaping은 이 콜백이 함수 밖의 나중에 어딘가 가져다가 쓴다는 것을 나타냄
        // Result를 인자로 받아,void를 리턴하는 콜백으로 클로저를 만들었음
    ) {
        
        var components = URLComponents(string: "https://api.thecatapi.com/v1/images/search")!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard error == nil else {
                completion(.failure(.networkError))
                return
                //error가 nil이 아닌지 검사
            }
            
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            
            
            guard let response = try? JSONDecoder().decode([CatResponse].self, from: data) else {
                completion(.failure(.networkError))
                return
            }
            print(response)
            
            
            completion(.success(response))
        }
        task.resume() //task를 돌림
        
    }
}
