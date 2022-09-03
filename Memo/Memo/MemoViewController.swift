import UIKit

import SnapKit
import RealmSwift

class MemoViewController: BaseViewController {
    
    private let repository = UserMemoRepository()
    
    
    private var memoTasks: Results<UserMemo>? {
        didSet {
            memoTableView.reloadData()
            navigationItem.title = "\(countFormat())개의 메모"
        }
    }
    
    private var fixedMemoTasks: Results<UserMemo>? {
        didSet {
            memoTableView.reloadData()
            navigationItem.title = "\(countFormat())개의 메모"
        }
    }
    
    var tasks: Results<UserMemo>? {
        didSet {
            memoTableView.reloadData()
            navigationItem.title = "\(countFormat())개의 메모"
        }
    }
    
    var isFilter: Bool {
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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        
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
    
    func countFormat() -> String {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        return numberFormat.string(for: (memoTasks?.count ?? 0) + (fixedMemoTasks?.count ?? 0)) ?? "0"
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
        if isFilter {
            return 1
        } else {
            if fixedMemoTasks?.isEmpty == true {
                return 1
            } else {
                return 2
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter {
            return tasks?.count ?? 0
        } else {
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
       
    }
    
    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "a hh:mm"
        } else if Calendar.current.isDateInWeekend(date) {
            formatter.dateFormat = "EEEE"
        } else {
            formatter.dateFormat = "yyyy.MM.dd a hh:mm"
        }
        
        return formatter.string(from: date)
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseableIdentifier, for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        let attributedStr = NSMutableAttributedString(string: cell.memoTitleLabel.text ?? "")
//        attributedStr.addAttribute(.foregroundColor, value: UIColor.orange, range: ((cell.memoTitleLabel.text ?? "") as NSString).range(of: memoSearchController.searchBar.text ?? ""))
    
        
        
        if isFilter {
            
            
            cell.memoTitleLabel.text = tasks?[indexPath.row].memoTitle
//            cell.memoTitleLabel.attributedText = attributedStr
            
            cell.memoTitleLabel.text = tasks?[indexPath.row].memoTitle
            cell.memoDateLabel.text = dateFormatter(date: tasks?[indexPath.row].memoDate ?? Date())
            cell.memoSubTitleLabel.text = tasks?[indexPath.row].memoSubTitle
            
            
        } else {
            // 매개변수에 클로저를 넣은 함수로 중복코드 없애자
            if fixedMemoTasks?.isEmpty == true {
                cell.memoTitleLabel.text = memoTasks?[indexPath.row].memoTitle
                cell.memoDateLabel.text = dateFormatter(date: memoTasks?[indexPath.row].memoDate ?? Date())
                cell.memoSubTitleLabel.text = memoTasks?[indexPath.row].memoSubTitle
            } else {
                if indexPath.section == 0 {
                    cell.memoTitleLabel.text = fixedMemoTasks?[indexPath.row].memoTitle
                    cell.memoDateLabel.text = dateFormatter(date: fixedMemoTasks?[indexPath.row].memoDate ?? Date())
                    cell.memoSubTitleLabel.text = fixedMemoTasks?[indexPath.row].memoSubTitle
                } else {
                    cell.memoTitleLabel.text = memoTasks?[indexPath.row].memoTitle
                    cell.memoDateLabel.text = dateFormatter(date: memoTasks?[indexPath.row].memoDate ?? Date())
                    cell.memoSubTitleLabel.text = memoTasks?[indexPath.row].memoSubTitle

                }
            }
            
        }
        
        
       
        
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
        if isFilter {
            label.text = "\(tasks?.count ?? 0)개 찾음"
        } else {
            if fixedMemoTasks?.isEmpty == true {
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
          
            self.showAlertHandlingMessage(title: "메모를 삭제 하시겠습니까?") { _ in
                
                if self.isFilter {
                    self.repository.updateFix(item: self.tasks![indexPath.row])
                } else {
                    if self.fixedMemoTasks?.isEmpty == true {
                        self.repository.deleteMemo(item: self.memoTasks![indexPath.row])
                    } else {
                        if indexPath.section == 0 {
                            self.repository.deleteMemo(item: self.fixedMemoTasks![indexPath.row])
                        } else {
                            
                            self.repository.deleteMemo(item: self.memoTasks![indexPath.row])
                            
                        }
                    }
                }
                self.memoTasks = self.repository.fetchMemoFilter()
                self.fixedMemoTasks = self.repository.fetchFixedMemoFilter()
                
            }
            
            
            
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let fix = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            if self.isFilter {
                self.repository.updateFix(item: self.tasks![indexPath.row])
            } else {
                if self.fixedMemoTasks?.isEmpty == true {
                    self.repository.updateFix(item: self.memoTasks![indexPath.row])
                } else {
                    if indexPath.section == 0 {
                        self.repository.updateFix(item: self.fixedMemoTasks![indexPath.row])
                    } else {
                        if (self.fixedMemoTasks?.count ?? 0) < 5 {
                            self.repository.updateFix(item: self.memoTasks![indexPath.row])
                        } else {
                            self.showAlertMessage(title: "메모 고정은 5개가 최대입니다.")
                        }
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
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        tasks = repository.fetch().where {
            $0.memoTitle.contains(text, options: .caseInsensitive) || $0.memoSubTitle.contains(text, options: .caseInsensitive)
        }
        

        memoTableView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        view.endEditing(true)
        return true
    }
    
}



