//
//  FolerMemoViewController.swift
//  Memo
//
//  Created by J on 2022/10/18.
//

import UIKit

class FolderMemoViewController: BaseViewController {
    
    let viewModel = FolderMemoViewModel()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        return view
    }()
    lazy var searchController: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchResultsUpdater = self
        return view
    }()

    var dataSource: UICollectionViewDiffableDataSource<Int, UserMemo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        viewModel.fetch()
        
        navigationSet()
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

extension FolderMemoViewController {
    
    private func navigationSet() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    private func createLayout() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView.collectionViewLayout = layout
        
        
    }
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UserMemo>(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier.memoTitle
            content.secondaryText = itemIdentifier.memoSubTitle
            
            cell.contentConfiguration = content
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, UserMemo>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.tasks.value)
        dataSource?.apply(snapshot)
    }
}

extension FolderMemoViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else {return}
        let ss = viewModel.tasks.value.filter {
            $0.memoTitle.contains(text) || ($0.memoSubTitle?.contains(text) == true)
        }
        if let dataSource = dataSource {
            var snapshot = dataSource.snapshot()
            if text.isEmpty {
                snapshot.appendItems(viewModel.tasks.value)
            } else {
                snapshot.deleteAllItems()
                snapshot.appendSections([0])
                snapshot.appendItems(ss)
            }
            dataSource.apply(snapshot)
        }
    }
}
