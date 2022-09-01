import UIKit

import SnapKit
import RealmSwift

class MemoViewController: BaseViewController {
    
    let repository = UserMemoRepository()
    
    var memoTasks: Results<UserMemo>? {
        didSet {
            memoTableView.reloadData()
        }
    }
    
    var fixedMemoTasks: Results<UserMemo>? {
        didSet {
            memoTableView.reloadData()
        }
    }
    
    private lazy var memoTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.delegate = self
        view.dataSource = self
        view.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.reuseableIdentifier)
        
        return view
    }()
    
    private lazy var memoSearchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memoTasks = repository.fetchMemoFilter()
        fixedMemoTasks = repository.fetchFixedMemoFilter()
    }
    override func configureUI() {
        view.addSubview(memoTableView)
        navigationItem.searchController = memoSearchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "1개의 메모"
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonClicked))
        
        toolbarItems = [flexSpace, writeButton]
        
        navigationController?.toolbar.tintColor = .orange
        
        navigationController?.isToolbarHidden = false
        
    }
    
    @objc func writeButtonClicked() {
        let vc = WriteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func setConstraints() {
        memoTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension MemoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if fixedMemoTasks?.isEmpty == true {
            return 1
        } else {
            return 2
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fixedMemoTasks?.isEmpty == true {
            return memoTasks?.count ?? 0
        } else {
            if section == 0 {
                return fixedMemoTasks?.count ?? 0
            } else {
                return memoTasks?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseableIdentifier, for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        cell.memoTitleLabel.text = "Ss"
        cell.memoDateLabel.text = "df"
        cell.memoSubTitleLabel.text = "df"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 70)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 10, width: tableView.bounds.width, height: header.frame.height - 20)
        
        label.font = .boldSystemFont(ofSize: 24)
        if fixedMemoTasks?.isEmpty == true {
            label.text = "메모"
        } else {
            if section == 0 {
                label.text = "고정된 메모"
            } else {
                label.text = "메모"
            }
        }
        
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
            
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let fix = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            
            if self.fixedMemoTasks?.isEmpty == true {
                self.repository.updateFix(item: self.memoTasks![indexPath.row])
            } else {
                if indexPath.section == 0 {
                    self.repository.updateFix(item: self.fixedMemoTasks![indexPath.row])
                } else {
                    if (self.fixedMemoTasks?.count ?? 0) < 5 {
                        self.repository.updateFix(item: self.memoTasks![indexPath.row])
                    }
                }
            }
            
            
            
            
            self.memoTasks = self.repository.fetchMemoFilter()
            self.fixedMemoTasks = self.repository.fetchFixedMemoFilter()
        }
        
        if fixedMemoTasks?.isEmpty == true {
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
        
    }
    
}
