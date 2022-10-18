//
//  FolerMemoViewController.swift
//  Memo
//
//  Created by J on 2022/10/18.
//

import UIKit

class FolderMemoViewController: BaseViewController{

    let viewModel = FolderMemoViewModel()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, UserMemo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.tasks.bind { _ in
            self.collectionView.reloadData()
        }
    }
    
    override func configureUI() {
        viewModel.fetch()
        view.addSubview(collectionView)
        collectionViewConfiguration()
    }
    
    func collectionViewConfiguration() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView.collectionViewLayout = layout
        
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier.memoTitle
            content.secondaryText = itemIdentifier.memoSubTitle
            
            cell.contentConfiguration = content
        })
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension FolderMemoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tasks.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.tasks.value[indexPath.row]
        guard let cellRegistration = cellRegistration else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        
        return cell
    }
    
    
}
