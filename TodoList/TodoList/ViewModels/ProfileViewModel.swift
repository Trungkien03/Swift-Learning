//
//  ProfileViewModel.swift
//  TodoList
//
//  Created by Trung Kiên Nguyễn on 19/4/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var user: User? = nil
    
    init() {
        
    }
    
    func fetchUser () {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument(completion: { [weak self] snapshot,  error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    fullName: data["fullName"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0
                )
            }
        })
    }
    
    func logOut () {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}
