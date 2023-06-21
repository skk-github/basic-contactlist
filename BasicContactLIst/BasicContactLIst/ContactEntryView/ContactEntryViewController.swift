//
//  ContactEntryViewController.swift
//  BasicContactLIst
//
//  Created by Krishna on 09/06/23.
//

import Foundation
import UIKit

protocol ContactEntryViewControllerDelegates: AnyObject {
    func removeContact(index : IndexPath?)
    func updateContactList()
}

class ContactEntryViewController: UIViewController {
    
    weak var delegate: ContactEntryViewControllerDelegates?
    
    @IBOutlet weak var nameInputField: UITextField!
    
    @IBOutlet weak var primaryPhInputField: UITextField!
    
    @IBOutlet weak var secondaryPhInputField: UITextField!
    
    @IBOutlet weak var emailInputField: UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var name: String?
    var primaryNumber: Int64?
    var secondaryNumber: Int64?
    var email: String?
    var uuid: UUID?
    var userSelectedIndexPath: IndexPath?
    var fetchedContact: Contact?
    var screenType: ContactEntryType?
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uuid = uuid {
            fetchRecord(id: uuid)
        }else {
            uuid = UUID()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deleteButton.isHidden = screenType == .editContact ? false : true
    }
    
    func fetchRecord(id uuid: UUID) {
        let fetchreq = Contact.fetchRequest()
        
        fetchreq.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        
        
        do {
            let fetchedArray =  try PersistanceManager.shared.context.fetch(fetchreq)
            if let unwrappedContact = fetchedArray.first {
                fetchedContact = unwrappedContact
                setContactDetails(fetchedContact: fetchedContact)
            }
            
        }catch(let err) {
            print(err.localizedDescription)
        }
        
       
    }
    

    
    func setContactDetails(fetchedContact: Contact?) {
        guard let contact = fetchedContact else {return}
        nameInputField.text = contact.name ?? ""
        primaryPhInputField.text = String(contact.primaryNumber)
        secondaryPhInputField.text = String(contact.secondaryNumber)
        emailInputField.text = contact.email ?? ""
        uuid = contact.id
        
    }
    
    
    func setAndPersistContact(contact: Contact) {
        
        let contact = contact
        contact.name = nameInputField.text
        contact.id = uuid!
        contact.primaryNumber = Int64(primaryPhInputField.text ?? "") ?? 0
        contact.secondaryNumber = Int64(secondaryPhInputField.text ?? "") ?? 0
        contact.email = emailInputField.text
        PersistanceManager.shared.saveContext()
    }
    
    func deleteContact() {
        guard let contact = fetchedContact else {return}
  
        
        PersistanceManager.shared.context.delete(contact)
        PersistanceManager.shared.saveContext()
        delegate?.removeContact(index: userSelectedIndexPath)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if screenType == .editContact {
            guard let contact = fetchedContact else {return}
            setAndPersistContact(contact: contact)
        }else{
            setAndPersistContact(contact: Contact(context: PersistanceManager.shared.context))
        }
        delegate?.updateContactList()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        deleteContact()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
}
