//
//  Extension+.swift
//  EditAddressBook
//
//  Created by Steven Xie on 2019/1/15.
//  Copyright © 2019 Steven Xie. All rights reserved.
//

import UIKit

typealias successHandler = (_ dataArray : [[AddressBookModel]], _ sectionTitlesArray : [String]) -> Void

extension UILocalizedIndexedCollation {
    // MARK: 通讯录数组排序重组
    static func getSortAddressBookData(originalArray: Array<Any>, finishedCallback : @escaping successHandler) -> Void{
        
        var dataArray = [[AddressBookModel]]()
        var sectionTitleArray = [String]()
        let indexedCollation = self.current()
        
        var sortArray = [AddressBookModel]()
        for sortAny in originalArray {
            let sort = AddressBookModel()
            sort.name = sortAny as? String
            sortArray.append(sort)
        }
        
        // 索引数 26个字母 + #
        let indexCount = indexedCollation.sectionTitles.count
        
        for _ in 0..<indexCount {
            let array = [AddressBookModel]()
            dataArray.append(array)
        }
        
        for sortAny in sortArray {
            // 根据 name 归档分类
            let sectionNumber = indexedCollation.section(for: sortAny, collationStringSelector: #selector(getter: AddressBookModel.name))
            dataArray[sectionNumber].append(sortAny)
        }
        
        // 单个数组数据排序
        for i in 0..<indexCount {
            let sortedPersonArray = indexedCollation.sortedArray(from: dataArray[i], collationStringSelector: #selector(getter: AddressBookModel.name))
            dataArray[i] = sortedPersonArray as! [AddressBookModel]
        }
        
        // 空数据下标
        var tempArray = [Int]()
        
        for (i, array) in dataArray.enumerated() {
            if array.count == 0 {
                tempArray.append(i)
            } else {
                sectionTitleArray.append(indexedCollation.sectionTitles[i])
            }
        }
        
        // 删除空数据数组
        for i in tempArray.reversed() {
            dataArray.remove(at: i)
        }
        
        finishedCallback(dataArray, sectionTitleArray)
    }
}


extension Array where Element: Equatable {
    // MARK: 删除数组元素
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

