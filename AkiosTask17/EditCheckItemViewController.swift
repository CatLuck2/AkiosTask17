//
//  EditCheckItemViewController.swift
//  AkiosTask17
//
//  Created by Nekokichi on 2020/09/05.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit

class EditCheckItemViewController: UIViewController {
    
    @IBOutlet private weak var editTextField: UITextField!
    
    var selectedIndexPathRow: Int!
    var selectedCheckItemText: String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        editTextField.text = selectedCheckItemText
    }
    
    @IBAction func updateCheckItem(_ sender: Any) {
        // 入力したテキストを選択されたチェック項目に代入
        guard let inputItemText = editTextField.text else { return }
        selectedCheckItemText = inputItemText
        // ViewControllerに戻る
        performSegue(withIdentifier: "editItemUnWind", sender: nil)
    }
    
    @IBAction func dismissCurrentVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


