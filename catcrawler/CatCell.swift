//
//  CatCell.swift
//  catcrawler
//
//  Created by 김혜주 on 2023/02/17.
//

import Foundation
import UIKit

final class CatCell: UICollectionViewCell {
    
    private let imageView = UIImageView() //이미지뷰 만들기
    
    private let service = ImageService.shared
    
    private var task: URLSessionDataTask? //현재 다운받고 있는 task를 셀에 저장
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() { //View를 셋업하는 함수
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false //cyan으로 안되서 수정
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
            
        ])
        
        self.imageView.contentMode = .scaleAspectFill//이미지가 꽉 차게 보임
        self.imageView.clipsToBounds = true //이미지가 나눈 클립의 크기에 맞춤
        
    }
    
    func setupData(urlString: String, detail: Bool = false) {
        task?.cancel() //이전에 받아온 task가 있다면 cancel하고
        self.imageView.image = nil //이전에 담아두었던 이미지를 nil처리로 비움
        if detail {
            self.imageView.contentMode = .scaleAspectFit//디테일뷰에서 화면에 이미지가 크기 맞추는거
        }
        task = service.setImage(view: self.imageView, urlString: urlString)
        //오토레이아웃을 설정하는 코드
    }
}
