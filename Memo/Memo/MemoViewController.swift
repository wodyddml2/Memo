import UIKit

import SnapKit

class MemoViewController: BaseViewController {
    
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
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseableIdentifier, for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.textLabel?.text = "S"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 70)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 10, width: tableView.bounds.width, height: header.frame.height - 20)
        
        label.font = .boldSystemFont(ofSize: 24)
        
        if section == 0 {
            label.text = "고정된 메모"
        } else {
            label.text = "메모"
        }
        
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
            
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let fix = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
        }
        
        fix.image = UIImage(systemName: "pin.fill")
        fix.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [fix])
    }
    
}

extension MemoViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
 
}
