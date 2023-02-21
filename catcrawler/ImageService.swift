//
//  ImageService.swift
//  catcrawler
//
//  Created by 김혜주 on 2023/02/22.
//

import Foundation
import UIKit

class ImageService {
    
    static let shared = ImageService() //어디서나 쓸 수 있도록(싱글톤)
    
    enum Network: Error {
        case networkError //
    }
    
    private let cash = NSCache<NSString, UIImage>() //NSCache는 담아두었다가 메모리가 부족해지면 내부적으로 날림
    
    func setImage(view: UIImageView, urlString: String) -> URLSessionDataTask? {
        if let image = cash.object(forKey: urlString as NSString) { //만약 캐시가 오브젝트를 이미 가지고 있다면
            view.image = image //그것을 그냥 세팅하고
            return nil
        }
        
        return self.downloadImage(urlString: urlString) { [weak self] result in //순환 참조를 회피하기 위해 [weak self]를 집어 넣음
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case .failure(let error):
                    return
                case .success(let image):
 
                    self.cash.setObject(image, forKey: urlString as NSString)
                    UIView.transition(with: view, duration: 1, options: .transitionCrossDissolve) { //샤라락 눈속임
                        
                        view.image = image //성공을 한다면 View에 이미지를 넣음
                    } completion: { _ in
                        
                    }

                }
            }
        }
    }
    
    
    func downloadImage(urlString: String, completion: @escaping (Result<UIImage, Network>) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {
            data, request, error in
            
            guard error == nil else  {
                completion(.failure(.networkError))
                return
                //실패할 때
            }
            
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.networkError)) //혹시 못하면 실패 처리
                return
                //성공할 때
            }
            
            completion(.success(image)) //성공처리. 가져온 이미지를 받음
        }
        
        task.resume()
    
        
        return task
    } // 다운로드 하는 기능
}
