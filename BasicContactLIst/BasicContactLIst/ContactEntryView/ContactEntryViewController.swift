//
//  ContactEntryViewController.swift
//  BasicContactLIst
//
//  Created by Krishna on 09/06/23.
//

import Foundation
import UIKit

class ContactEntryViewController: UIViewController {
    
    @IBOutlet weak var nameInputField: UITextField!
    
    @IBOutlet weak var primaryPhInputField: UITextField!
    
    @IBOutlet weak var secondaryPhInputField: UITextField!
    
    @IBOutlet weak var emailInputField: UITextField!
    
    
    var name: String?
    var primaryNumber: Int64?
    var secondaryNumber: Int64?
    var email: String?
    var uuid: UUID?
    var fetchedContact: Contact?
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uuid = uuid {
            fetchRecord(id: uuid)
        }else {
            uuid = UUID()
        }
    }
    
    func fetchRecord(id uuid: UUID) {
        let fetchreq = Contact.fetchRequest()
        
        fetchreq.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        
        
        do {
            let fetchedArray =  try PersistanceManager.shared.context.fetch(fetchreq)
            if let unwrappedContact = fetchedArray.first {
                fetchedContact = unwrappedContact
            }
            
        }catch(let err) {
            print(err.localizedDescription)
        }
        
       
    }
    
    func saveToPersistanceStore() {
        
        
//        let contact = Contact(context: PersistanceManager.shared.context)
//        contact.name = name
//        contact.id = uuid!
//        contact.primaryNumber = primaryNumber ?? <#default value#>
//        contact.secondaryNumber = secondaryNumber
//        contact.email = email
        
    }
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
    }
    
    
    
    
}
