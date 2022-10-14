//
//  MemoViewModel.swift
//  Memo
//
//  Created by J on 2022/10/13.
//

import UIKit

class MemoViewModel {
    
    let repository = UserMemoRepository()
    
    var allMemo = Observable([UserMemo]())
    var fixedMemo = Observable([UserMemo]())
    var nonFixedMemo = Observable([UserMemo]())
    
}

extension MemoViewModel {
    func fetch() {
        allMemo.value.removeAll()
        
        let all = repository.fetch()
        
        all.forEach {
            allMemo.value.append($0)
        }
    }
    
    func fetchFixed() {
        
        fixedMemo.value.removeAll()
        let fix = repository.fetchFixedMemoFilter()
        
        fix.forEach {
            fixedMemo.value.append($0)
        }
    }
    
    func fetchNonFixed() {
        nonFixedMemo.value.removeAll()
        let nonFix = repository.fetchMemoFilter()
        
        nonFix.forEach {
            nonFixedMemo.value.append($0)
        }
    }
    
    func fetchSearch(text: String) {
        allMemo.value.removeAll()
        let all = repository.fetchSearchFilter(text: text)
        
        all.forEach {
            allMemo.value.append($0)
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
}

extension MemoViewModel: ShowAlertProtocol {
    var numberOfSections: Int {
        return fixedMemo.value.isEmpty == true ? 1 : 2
    }
    
    var filterNumberOfRowsInSection: Int {
        return allMemo.value.count
    }
    
    func numberofRowsInSection(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fixedMemo.value.isEmpty {
            return nonFixedMemo.value.count
        } else {
            return section == 0 ?
            fixedMemo.value.count : nonFixedMemo.value.count
        }
    }
    
    func filterTitle(index: Int) -> String {
        return allMemo.value[index].memoTitle
    }
    
    func filterSubTitle(index: Int) -> String {
        return allMemo.value[index].memoSubTitle ?? ""
    }
    
    func filterMemoDate(index: Int) -> String {
        return dateFormatter(date: allMemo.value[index].memoDate)
    }
    
    func notFilterCellForRowAt(cell: MemoTableViewCell,_ tableView: UITableView, indexPath: IndexPath, task: Observable<[UserMemo]>) {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseableIdentifier, for: indexPath) as? MemoTableViewCell else { return }
        cell.memoTitleLabel.text = task.value[indexPath.row].memoTitle
        cell.memoDateLabel.text = dateFormatter(date: task.value[indexPath.row].memoDate)
        cell.memoSubTitleLabel.text = task.value[indexPath.row].memoSubTitle
    }
    
    func notFilterCellForRowAtCondition(cell: MemoTableViewCell,_ tableView: UITableView, indexPath: IndexPath) {
        if fixedMemo.value.isEmpty {
            notFilterCellForRowAt(cell: cell, tableView, indexPath: indexPath, task: nonFixedMemo)
        } else {
            indexPath.section == 0 ?
            notFilterCellForRowAt(cell: cell, tableView, indexPath: indexPath, task: fixedMemo) :
            notFilterCellForRowAt(cell: cell, tableView, indexPath: indexPath, task: nonFixedMemo)
        }
    }
    
    func deleteMemo(filter: Bool, indexPath: IndexPath) {
        if filter {
            repository.deleteMemo(item: allMemo.value[indexPath.row])
        } else {
            if fixedMemo.value.isEmpty {
                repository.deleteMemo(item: nonFixedMemo.value[indexPath.row])
            } else {
                indexPath.section == 0 ? repository.deleteMemo(item: fixedMemo.value[indexPath.row]) : repository.deleteMemo(item: nonFixedMemo.value[indexPath.row])
            }
        }
    }
    
    func updateFixMemo(filter: Bool, indexPath: IndexPath, _ viewController: UIViewController) {
        if filter {
            repository.updateFix(item: allMemo.value[indexPath.row])
        } else {
            if fixedMemo.value.isEmpty {
                repository.updateFix(item: nonFixedMemo.value[indexPath.row])
            } else {
                if indexPath.section == 0 {
                    repository.updateFix(item: fixedMemo.value[indexPath.row])
                } else {
                    if fixedMemo.value.count < 5 { repository.updateFix(item: nonFixedMemo.value[indexPath.row])
                    } else {
                        viewController.present(showAlertMessage(title: "메모 고정은 5개가 최대입니다."), animated: true)
                    }
                }
            }
        }
    }
}
