//
//  FolderViewController.swift
//  Memo
//
//  Created by J on 2022/10/18.
//

import UIKit

import SnapKit
 
class FolderViewController: BaseViewController {
    
    let viewModel = FolderViewModel()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Folder>?
    
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
            
            content.text = itemIdentifier.folderName
            content.secondaryText = "\(itemIdentifier.memo.count)개"
            
            cell.contentConfiguration = content
        })
    }
    
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension FolderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tasks.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.tasks.value[indexPath.item]
        guard let cellRegistration = cellRegistration else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FolderMemoViewController()
        
        vc.viewModel.folder = viewModel.tasks.value[indexPath.item]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
