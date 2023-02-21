//
//  CatViewModel.swift
//  catcrawler
//
//  Created by 김혜주 on 2023/02/22.
//

import Foundation


protocol CatViewModelOutput: AnyObject {
    func loadComplete()
}//리스펀스를 가져 오는 게 비동기 작업이기 때문에 델리게이트 방식으로 뚫음


final class CatViewModel {
    
    private var currentPage = 0 //현재 페이지 값
    
    private var limit = 3 * 7 //한 번에 21장을 가져옴
    
    private let service = CatService()
    
    var data: [CatResponse] = []
    
    private var delegates: [CatViewModelOutput] = []
    
    func attach(delegate: CatViewModelOutput) {
        self.delegates.append(delegate)
    }
    
    func detach(delegate: CatViewModelOutput) {
        self.delegates = self.delegates.filter {
            $0 !== delegate
        }
    }
    
    var isLoading: Bool = false
    
    func loadMoreIfNeeded(index: Int) {
        if index > data.count - 6 {
            self.load()
        }// 더보기 API를 요청해서 새로운 데이터를 덧붙이는 형식(무한 스크롤)
        
    }
    
    func load() {
        guard !isLoading else { return }
        self.isLoading = true
        self.service.getCats(page: self.currentPage, limit: self.limit) { result in
               
            DispatchQueue.main.async {
                
                switch result {
                case .failure(let error):
                    break
                case .success(let response):
                    self.data.append(contentsOf: response)
                    self.currentPage += 1 //한 페이지씩 추가하는 작업
                    self.delegates.forEach { $0.loadComplete() }
                }
                self.isLoading = false
            }
                
        }
    }
    

}
