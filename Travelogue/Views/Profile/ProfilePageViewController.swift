//
//  ProfilePageViewController.swift
//  Travelogue
//
//  Created by kent daniel on 31/5/2023.
//

import UIKit

class ProfilePageViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBAction func logOut(_ sender: Any) {
        AuthController().signOut()
        // navigate to login view controller
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController")

        // Set the presentation style to full screen
        loginViewController.modalPresentationStyle = .fullScreen

        // Present the login view controller
        self.present(loginViewController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let currentUser = appDelegate?.currentUser
        // Do any additional setup after loading the view.
        profileImage.applyBorderRadius(radius: 80)
        username.text = currentUser?.name
        userEmail.text = currentUser?.email
        
        if currentUser?.profileImgUrl == nil{
            profileImage.image = UIImage(systemName: "person.fill")
        }else{
            // download image
            ImageManager.downloadImage(from: (currentUser?.profileImgUrl)!){image,error in
                self.profileImage.image = image
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
