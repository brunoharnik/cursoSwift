//
//  EntryViewController.swift
//  ListaDeCompras
//
//  Created by Bruno on 15/07/20.
//  Copyright © 2020 Bruno. All rights reserved.
//
import RealmSwift
import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    private let realm = try! Realm()
    public var completionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.becomeFirstResponder()
        textField.delegate = self
        
        datePicker.setDate(Date(), animated: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salvar", style: .done, target: self, action: #selector(didTapSaveButton))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func didTapSaveButton(){
        if let text = textField.text, !text.isEmpty {
            let date = datePicker.date
            realm.beginWrite()
            
            let novoProduto = Produto()
            novoProduto.data = date
            novoProduto.nome = text
            realm.add(novoProduto)
            
            try! realm.commitWrite()
            
            completionHandler?()
            navigationController?.popToRootViewController(animated: true)
        }
        else {
            print ("Adicione algo")
        }
        
    }
}
