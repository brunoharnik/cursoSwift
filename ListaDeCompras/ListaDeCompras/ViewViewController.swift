//
//  ViewViewController.swift
//  ListaDeCompras
//
//  Created by Bruno on 15/07/20.
//  Copyright © 2020 Bruno. All rights reserved.
//
import RealmSwift
import UIKit

class ViewViewController: UIViewController {
    
    public var produto: Produto?
    public var deletionHandler: (() -> Void)?
    
    @IBOutlet var produtoLabel: UILabel!
    @IBOutlet var dataLabel: UILabel!
    
    private let realm = try! Realm()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        produtoLabel.text = produto?.nome
        dataLabel.text = Self.dateFormatter.string(from: produto!.data)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
    }
    
    @objc private func didTapDelete(){
        guard let item = self.produto else {
            return
        }
        realm.beginWrite()
        realm.delete(item)
        try! realm.commitWrite()
        
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
    }
}
