//
//  ContactTableViewController.swift
//  BasicContactLIst
//
//  Created by Krishna on 25/05/23.
//

import UIKit

enum ContactEntryType {
    case newContact, editContact
}
var userSelectedContactID: UUID? = nil


class ContactTableViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    
    let cellIdentifier = "ContactTableViewCell"
    
    var contactList: [Contact] = []
    var persistentManager: PersistanceManager!
    
    init() {
      
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        persistentManager = PersistanceManager.shared
        // Do any additional setup after loading the view.
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.estimatedRowHeight = 50
        fetchContactList()
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        moveToContactEntryScreen(screenType: .newContact)
    }
    
    func moveToContactEntryScreen(screenType: ContactEntryType, index: IndexPath? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ContactEntryViewController") as? ContactEntryViewController {
            
            if screenType == .editContact {
                vc.uuid = userSelectedContactID
                vc.userSelectedIndexPath = index
            }
            vc.screenType = screenType
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func fetchContactList() {
       let fetchReq = Contact.fetchRequest()
        do {
            contactList = try persistentManager.context.fetch(fetchReq)
 
            tblView.reloadData()
        }catch(let err){
            print("fetch failed \(err.localizedDescription)")
        }
        
        
    }
    
    func addContact() {
        let contact = Contact(context: persistentManager.context)
        contact.name = "Kris"
        contact.primaryNumber = 8056061460
        contact.id = UUID()
        persistentManager.saveContext()
    }
    


}

extension ContactTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContactTableViewCell
        cell.setContactDetail(contact: contactList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        userSelectedContactID = contactList[index].id
        moveToContactEntryScreen(screenType: .editContact, index: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension ContactTableViewController: ContactEntryViewControllerDelegates {
    func removeContact(index: IndexPath?) {
        if let unwrappedIndex = index {
//            print(contactList.count)
//            contactList.remove(at: unwrappedIndex.row)
//            print(contactList.count)
//            tblView.reloadRows(at: [unwrappedIndex], with: .fade)
            
            tblView.performBatchUpdates {
                contactList.remove(at: unwrappedIndex.row)
                tblView.deleteRows(at: [unwrappedIndex], with: .automatic)
            }
        }
        
    }
    
  
    
    func updateContactList() {
        fetchContactList()
        tblView.reloadData()
    }
    
    
}
