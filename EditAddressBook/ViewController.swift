//
//  ViewController.swift
//  EditAddressBook
//
//  Created by Steven Xie on 2019/1/15.
//  Copyright © 2019 Steven Xie. All rights reserved.
//

import UIKit

let kScreenW  = UIScreen.main.bounds.width
let kScreenH  = UIScreen.main.bounds.height

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var testArray = ["王老二", "谢老三", "李老四", "徐老五", "张老六", "鲁老七", "陈老八", "习老九", "武老十", "赵十一", "周十二", "吴十三", "孔十四", "韦十五", "任十六", "花十七", "宋十八", "杜十九", "丁二十", "叶二一", "艾二二", "苗二三"]
    
    private var keysArray:[String]?

    private var objectsArray : [[AddressBookModel]]?
    
    private var isAllSelected: Bool = false
    
    var tableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabView()
    }
    
    func createData(data: Array<Any>) {
        UILocalizedIndexedCollation.getSortAddressBookData(originalArray: data) { (dataArray,titleArray) in
            self.objectsArray = dataArray
            self.keysArray = titleArray
            self.tableView?.reloadData()
        }
    }
    
    func setUpTabView() {
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH), style: .plain)
        tableView?.tableFooterView = UIView.init()
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(tableView!)
        
        self.tableView?.allowsMultipleSelectionDuringEditing = true
        
        addGestureToTableView()
        
        createData(data: testArray)
    }
    
    func addGestureToTableView() {
        let longPress = UILongPressGestureRecognizer(target:self, action:#selector(self.tableviewCellLongPressed(gestureRecognizer:)))
        longPress.delegate = self
        longPress.minimumPressDuration = 1.0
        self.tableView!.addGestureRecognizer(longPress)
    }
    
    /// 单元格长按事件
    @objc func tableviewCellLongPressed(gestureRecognizer:UILongPressGestureRecognizer){
        if (gestureRecognizer.state == .ended) {
            print("UIGestureRecognizerStateEnded");
            editHandle()
        }
    }
    
    /// 删除
    @IBAction func deleteAction(_ sender: Any) {
        if let selectedItems = tableView!.indexPathsForSelectedRows {
            let deleteArr = selectedItems.compactMap { indexPath -> String? in
                return objectsArray![indexPath.section][indexPath.row ].name
            }
            
            _ = deleteArr.map({
                testArray.remove($0)
            })
            
            createData(data: testArray)
        }
        
        self.tableView?.reloadData()
        self.tableView!.setEditing(false, animated:true)
    }
    
    /// 编辑
    @IBAction  func editHandle() {
        //在正常状态和编辑状态之间切换
        if(self.tableView!.isEditing == false) {
            self.tableView!.setEditing(true, animated:true)
        }
        else {
            self.tableView!.setEditing(false, animated:true)
        }
    }
    
    /// 全选
    @IBAction  func allSelectedItem() {
        for i in 0..<keysArray!.count {
            for j in 0..<objectsArray![i].count {
                let indexPath = IndexPath(item: j, section: i)
                if isAllSelected {
                    tableView?.deselectRow(at: indexPath, animated: false)
                } else {
                    tableView?.selectRow(at: indexPath, animated: false, scrollPosition: .top)
                }
            }
        }
        isAllSelected = !isAllSelected
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysArray!.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray![section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keysArray?[section]
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keysArray
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = objectsArray![indexPath.section][indexPath.row].name
        cell?.selectionStyle = .blue
        return cell!
    }
}
