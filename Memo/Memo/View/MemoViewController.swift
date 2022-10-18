import UIKit

import SnapKit
import RealmSwift

class MemoViewController: BaseViewController {
    

    let viewModel = MemoViewModel()
    
let folderRepo = FolderRepository()
    let repository = UserMemoRepository()
    private var isFilter: Bool {
        let searchContoller = navigationItem.searchController
        let isActive = searchContoller?.isActive ?? false
        let isSearchBarHasText = searchContoller?.searchBar.text?.isEmpty == false
        
        return isActive && isSearchBarHasText
    }

    
    
    private lazy var memoTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.delegate = self
        view.dataSource = self
        view.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.reuseableIdentifier)
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    private lazy var memoSearchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        search.searchBar.setValue("취소", forKey: "cancelButtonText")
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFixed()
        viewModel.fetchNonFixed()
        
        
        viewModel.allMemo.bind { _ in
            self.memoTableView.reloadData()
        }
        
        viewModel.fixedMemo.bind { _ in
            self.memoTableView.reloadData()
        }
        
        viewModel.nonFixedMemo.bind { _ in
            self.memoTableView.reloadData()
        }
//        let list = ["고정된 메모", "메모"]
//        print("FileURL: \(repository.localRealm.configuration.fileURL!)")
//        for i in list {
//            let folder = Folder(folderName: i)
//            try! folderRepo.addFolder(item: folder)
//            if i == "고정된 메모" {
//                for i in viewModel.fixedMemo.value {
//                    try! folderRepo.appendMemo(folder: folder, item: i)
//                }
//            } else {
//                for i in viewModel.nonFixedMemo.value {
//                    try! folderRepo.appendMemo(folder: folder, item: i)
//                }
//            }
//        }
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "pop") == false {
            let vc = PopupViewController()
            vc.modalPresentationStyle = .overFullScreen
            
            present(vc, animated: true)
        }
    }
    
    override func configureUI() {
        view.addSubview(memoTableView)
        
        navigationItem.searchController = memoSearchController
        memoSearchController.obscuresBackgroundDuringPresentation = false
        
        navigationSetting()
 
    }
    override func setConstraints() {
        memoTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func navigationSetting() {
        navigationController?.navigationBar.backgroundColor = .systemGray6
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
       
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .orange
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonClicked))
        let folderButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(folderButtonClicked))
        toolbarItems = [folderButton, flexSpace, writeButton]
        
        navigationItem.backButtonTitle = "메모"
    }
    
    @objc func folderButtonClicked() {
        let vc = FolderViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func writeButtonClicked() {
        let vc = WriteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func titleCountFormat() -> String {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        return numberFormat.string(for: viewModel.nonFixedMemo.value.count + viewModel.fixedMemo.value.count) ?? "0"
    }
}

extension MemoViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFilter {
            return 1
        } else {
            return viewModel.numberOfSections
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter {
            return viewModel.filterNumberOfRowsInSection
        } else {
            return viewModel.numberofRowsInSection(tableView, numberOfRowsInSection: section)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseableIdentifier, for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
           
        if isFilter {
            cell.memoTitleLabel.attributedText = nil
            cell.memoSubTitleLabel.attributedText = nil
            cell.memoTitleLabel.text = nil
            cell.memoSubTitleLabel.text = nil
            
            let titles = viewModel.filterTitle(index: indexPath.row)
            var subTitles = viewModel.filterSubTitle(index: indexPath.row)
            
            if subTitles.count != 0 {
                subTitles.removeFirst(1)
            }
            
            let attributedTitle = NSMutableAttributedString(string: titles)
            let attributedSubTitle = NSMutableAttributedString(string: subTitles)
            
            if let textRange = titles.range(of: memoSearchController.searchBar.text ?? "", options: .caseInsensitive) {
                // lowerbound: 찾고자하는 값의 처음 나오는 인덱스
                let textIndex = titles.distance(from: titles.startIndex, to: textRange.lowerBound)
                // NSRange: NSString의 서브스트링 영역을 표시하기 위해 정의된 구조체
                // location: 시작점 length: range의 길이
                attributedTitle.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(location: textIndex, length: memoSearchController.searchBar.text?.count ?? 0))
                cell.memoTitleLabel.attributedText = attributedTitle
            } else {
                cell.memoTitleLabel.text = titles
            }
            
            if let textRange = subTitles.range(of: memoSearchController.searchBar.text ?? "" , options: .caseInsensitive) {
                let textIndex = subTitles.distance(from: subTitles.startIndex, to: textRange.lowerBound)
                attributedSubTitle.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(location: textIndex, length: memoSearchController.searchBar.text?.count ?? 0))
                cell.memoSubTitleLabel.attributedText = attributedSubTitle
            } else {
                cell.memoSubTitleLabel.text = subTitles
            }
  
            cell.memoDateLabel.text = viewModel.filterMemoDate(index: indexPath.row)
       
        } else {
            
            cell.memoTitleLabel.attributedText = nil
            cell.memoSubTitleLabel.attributedText = nil
            cell.memoTitleLabel.text = nil
            cell.memoSubTitleLabel.text = nil
            
            viewModel.notFilterCellForRowAtCondition(cell: cell,tableView, indexPath: indexPath)

            if cell.memoSubTitleLabel.text?.count != 0 {
                cell.memoSubTitleLabel.text?.removeFirst(1)
            }
        }
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WriteViewController()
        
        if memoSearchController.isActive {
            navigationItem.backButtonTitle = "검색"
            vc.memoTasks = viewModel.allMemo.value[indexPath.row]
        } else {
            if viewModel.fixedMemo.value.isEmpty == true {
                vc.memoTasks = viewModel.nonFixedMemo.value[indexPath.row]
            } else {
                vc.memoTasks = indexPath.section == 0 ? viewModel.fixedMemo.value[indexPath.row] : viewModel.nonFixedMemo.value[indexPath.row]
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 70)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 10, width: tableView.bounds.width, height: header.frame.height - 20)
        
        label.font = .boldSystemFont(ofSize: 24)
        if isFilter {
            label.text = "\(viewModel.filterNumberOfRowsInSection)개 찾음"
        } else {
            if viewModel.fixedMemo.value.isEmpty == true {
                label.text = "메모"
            } else {
                if section == 0 {
                    label.text = "고정된 메모"
                } else {
                    label.text = "메모"
                }
            }
        }
        header.addSubview(label)
        return header
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
          
            self.showAlertHandlingMessage(title: "메모를 삭제 하시겠습니까?") { _ in
                self.viewModel.deleteMemo(filter: self.isFilter, indexPath: indexPath)
                self.viewModel.fetchNonFixed()
                self.viewModel.fetchFixed()

            }
  
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let fix = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            self.viewModel.updateFixMemo(filter: self.isFilter, indexPath: indexPath, self)
            self.viewModel.fetchNonFixed()
            self.viewModel.fetchFixed()

        }
        
        if viewModel.fixedMemo.value.isEmpty {
            fix.image = UIImage(systemName: "pin.fill")
        } else {
            fix.image = indexPath.section == 0 ? UIImage(systemName: "pin.slash.fill") : UIImage(systemName: "pin.fill")
        }
        
        fix.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [fix])
    }

}

extension MemoViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        viewModel.fetchSearch(text: text)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        view.endEditing(true)
        return true
    }
}



