import UIKit

import SnapKit

class MemoViewController: BaseViewController {
    
    private lazy var memoTableView: UITableView = {
       let view = UITableView()
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
        
        
    }
    
    override func setConstraints() {
        memoTableView.snp.makeConstraints { make in
            make.trailing.leading.bottom.top.equalTo(view.safeAreaLayoutGuide)
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
        cell.textLabel?.text = "S"
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "고정된 메모"
        } else {
            return "메모"
        }
        
    }
}

extension MemoViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
 
}
