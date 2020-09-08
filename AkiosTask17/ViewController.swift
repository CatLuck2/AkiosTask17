//
//  ViewController.swift
//  AkiosTask17
//
//  Created by Nekokichi on 2020/09/05.
//  Copyright © 2020 Nekokichi. All rights reserved.
//
/*
 インスタンスで初期化しないと、nilになる
 realmをprivateではなく、fileprivateに
 エラー：Attempting to modify object outside of a write transaction - call beginWriteTransaction on an RLMRealm instance first.
 エラー：Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<RLM 0x759a870> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the ke
      realm.setValueを削除したら解消した
      checkList内の値を更新すると、Realm内のデータも更新された！？
 　　　値を変更するたびにtransactionのエラーが出る
 エラー：Terminating app due to uncaught exception 'RLMException', reason: 'Object has been deleted or invalidated.'
        Realmのトランザクション内でRealm().delete()を実行し、tableViewを更新すると出る
        削除後に、0からRealmのデータを取得すると解消した
        削除後のデータが[invalid object]と表示されるが、0からRealmのデータを取得すると、無くなっている
 エラー:'Invalid update: invalid number of rows in section 0. The number of rows contained in an existing section after the update (8) must be equal to the number of rows contained in that section before the update (4), plus or minus the number of rows inserted or deleted from that section (1 inserted, 1 deleted) and plus or minus the number of rows moved into or out of that section (0 moved in, 0 moved out).
 エラー：Property 'rDJ98hwMi' not found in object of type 'CheckItemModel
        results.filter("identifier == \(checkList[indexPath.row].identifier)")
        identifierを指定してるのに、エラーが出る
 Realmのデータを削除する方法は、①データ表示に使用している配列やリスト内のデータを直接削除、②Realm内に該当するデータを参照して削除する
 */
/*
 ？required init()とは？
 ？なぜソートする必要がある？
 モデル定義の時点で乱数を入れる
 */

import UIKit
import RealmSwift

class CheckItemModel: Object {
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var title      = String()
    @objc dynamic var isChecked  = Bool()
    @objc dynamic var createdAt  = Date()
    
    init(title:String, isChecked:Bool) {
        self.title      = title
        self.isChecked  = isChecked
    }
    
    required init() {
        self.title      = ""
        self.isChecked  = false
    }
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet private weak var checkListTableView: UITableView!
    
    // Realm
    private let realm     = try! Realm()
    // チェックリスト（保存用）
    private var checkListInRealm:Results<CheckItemModel>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkListInRealm = realm.objects(CheckItemModel.self).sorted(byKeyPath: "createdAt")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkListTableView.delegate   = self
        checkListTableView.dataSource = self
        checkListTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customcell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkListInRealm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomCell
        //CustomCell内の各UIに値をセット
        cell.configure(checkItem: checkListInRealm[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Realm-Update
        // Rerference of selectedCheckItem
        let selectedCheckItem = checkListInRealm[indexPath.row]
        try! realm.write {
            selectedCheckItem.isChecked.toggle()
        }

        
        checkListTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Realm-Delete
            let selectedCheckItem = checkListInRealm[indexPath.row]
            try! realm.write {
                realm.delete(selectedCheckItem)
            }
            
            checkListTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "editItemSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editItemSegue" {
            let nvc                = segue.destination as! UINavigationController
            let editCheckItemVC    = nvc.viewControllers[0] as! EditCheckItemViewController
            guard let indexpathrow = sender as? Int else { return }
            editCheckItemVC.selectedIndexPathRow = indexpathrow
            editCheckItemVC.selectedCheckItemText = checkListInRealm[indexpathrow].title
        }
    }
    
    @IBAction func unwindToVC(_ unwindSegue: UIStoryboardSegue) {
        // AddCheckItemで入力したデータを追加
        if unwindSegue.identifier == "addItemUnWind" {
            let addCheckItemVC = unwindSegue.source as! AddCheckItemViewController
            
            // Realm-Add
            try! realm.write{
                realm.add(addCheckItemVC.checkItem)
            }
            
            checkListTableView.reloadData()
        }
        // EditCheckItemで編集したデータを更新
        if unwindSegue.identifier == "editItemUnWind" {
            let editCheckItemVC = unwindSegue.source as! EditCheckItemViewController
            let indexPathRow    = editCheckItemVC.selectedIndexPathRow
            
            // Realm-Update
            let selectedCheckItem = checkListInRealm[indexPathRow!]
            try! realm.write {
                selectedCheckItem.title = editCheckItemVC.selectedCheckItemText
            }
            
            checkListTableView.reloadData()
        }
    }
    
}

