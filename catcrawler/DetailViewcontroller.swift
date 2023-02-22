//
//  DetailViewController.swift
//  catcrawler
//
//  Created by 김혜주 on 2023/02/22.
//
import UIKit

class DetailViewController: UIViewController, CatViewModelOutput {
    

    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        layout.minimumLineSpacing = .zero //간격을 0으로
        layout.minimumInteritemSpacing = .zero
        layout.scrollDirection = .horizontal //레이아웃 스크롤 방향
        cv.isPagingEnabled = true //콜렉션뷰가 페이지효과를 줄 수 있는 작업
        return cv
    }()
    
    private let viewModel: CatViewModel
    
    private let index: Int
    
    init(viewModel: CatViewModel, index: Int) {
        self.viewModel = viewModel
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.view.addSubview(self.collectionView)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.collectionView.register(CatCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        self.viewModel.attach(delegate: self)
        self.viewModel.load()
        
        self.collectionView.layoutIfNeeded()
        self.collectionView.scrollToItem(at: IndexPath(item: self.index, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func loadComplete() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.detach(delegate: self) //viewModel에서 현재 메모리를 해제시킴
    }


}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size //디테일뷰니까 콜렉션 뷰의 전체 프레임 사이즈를 가져옴
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewModel.loadMoreIfNeeded(index: indexPath.item)
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CatCell
        let data = self.viewModel.data[indexPath.item]
        cell.setupData(urlString: data.url, detail: true)
        return cell
    }
    
    
}
