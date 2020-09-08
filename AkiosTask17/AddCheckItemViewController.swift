//
//  AddCheckItemViewController.swift
//  AkiosTask17
//
//  Created by Nekokichi on 2020/09/05.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit
import RealmSwift

class AddCheckItemViewController: UIViewController {
    
    @IBOutlet private weak var inputTextField: UITextField!
    
    private(set) var checkItem: CheckItemModel!
    
    @IBAction func addCheckItem(_ sender: Any) {
        // checkItemTextFieldに文字が入力されてるか
        if inputTextField.text == "" {
            let alertController  = UIAlertController(title: "エラー", message: "1文字以上の文字を入力してください", preferredStyle: .alert)
            let cancelAction     = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        } else {
            // 入力値を追加用のデータに代入
            checkItem = CheckItemModel(title: inputTextField.text!, isChecked: false)
            // ViewControllerに戻る
            performSegue(withIdentifier: "addItemUnWind", sender: nil)
        }
    }
    
    @IBAction func dismissCurrentVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
