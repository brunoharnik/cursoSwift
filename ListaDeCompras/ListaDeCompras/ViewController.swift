//
//  ViewController.swift
//  ListaDeCompras
//
//  Created by Bruno on 15/07/20.
//  Copyright © 2020 Bruno. All rights reserved.
//
import RealmSwift
import UIKit

/*
 - Para mostrar a lista de produtos
 - para adiciionar novos itens à lista
 - Para mostrar produtos inseridos anteriormente
 
 - Produto
 - Data
 
 */

class Produto: Object {
    @objc dynamic var data: Date = Date()
    @objc dynamic var nome: String?
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    
    private let realm = try! Realm()
    private var data = [Produto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(Produto.self).map({ $0 })
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        table.delegate = self
        table.dataSource = self
    }

    // Mark: Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].nome
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let produto = data[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "view") as? ViewViewController else {
            return
        }
        
        vc.produto = produto
        vc.deletionHandler = { [weak self] in self?.refresh()}
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = produto.nome
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapAddButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else {
            return
        }
        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        vc.title = "Inserir produto"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refresh() {
        data = realm.objects(Produto.self).map({ $0 })
        table.reloadData()
    }
}

