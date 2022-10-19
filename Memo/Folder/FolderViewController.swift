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
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Folder>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        viewModel.fetch()
        view.addSubview(collectionView)
    
        createLayout()
        configureDataSource()
    }
 
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension FolderViewController {
    private func createLayout() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView.collectionViewLayout = layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Folder>(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier.folderName
            content.secondaryText = "\(itemIdentifier.memo.count)개"
            
            cell.contentConfiguration = content
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Folder>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.tasks.value)
        dataSource?.apply(snapshot)
    }
}

extension FolderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else {return}
        let vc = FolderMemoViewController()
        
        vc.viewModel.folder = item
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
