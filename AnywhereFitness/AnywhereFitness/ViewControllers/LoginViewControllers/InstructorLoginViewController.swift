//
//  InstructorLoginViewController.swift
//  AnywhereFitness
//
//  Created by Niranjan Kumar on 11/18/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import UIKit
import AuthenticationServices


enum LoginType {
    case signUp
    case signIn
}
class InstructorLoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var loginControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    // MARK: - Variables
    var classController: ClassController?
    var loginType: LoginType = .signUp

    override func viewDidLoad() {
        super.viewDidLoad()
        enterButton.layer.cornerRadius = 8.0
        setupProviderLoginView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performExistingAccountSetupFlows()
    }
    
    // MARK: - Methods & Functions
    @IBAction func loginSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            enterButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            enterButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func enterButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        if loginType == .signUp {
            
            }
        
            let alertController = UIAlertController(title: "Congrats on Signing Up", message: "Please Sign In", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true) {
                self.loginType = .signIn
                self.loginControl.selectedSegmentIndex = 1
                self.enterButton.setTitle("Sign In", for: .normal)
            }
            // End Alert Controller
    }
    
    //Apple Button
        func setupProviderLoginView() {
            let authorizationButton = ASAuthorizationAppleIDButton()
            authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
            
            self.stackView.addArrangedSubview(authorizationButton)
        }
        
        /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
        func performExistingAccountSetupFlows() {
            // Prepare requests for both Apple ID and password providers.
            let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                            ASAuthorizationPasswordProvider().createRequest()]
            
            // Create an authorization controller with the given requests.
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }

        
        @objc
        func handleAuthorizationAppleIDButtonPress() {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }

    extension InstructorLoginViewController: ASAuthorizationControllerDelegate {
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                // Create an account in your system.
                // For the purpose of this demo app, store the userIdentifier in the keychain.
                do {
                    try KeychainItem(service: "com.NarJesse.AnywhereFitness", account: "userIdentifier").saveItem(userIdentifier)
                } catch {
                    print("Unable to save userIdentifier to keychain.")
                }
                
                UserDefaults.standard.set(true, forKey: "instructorHasLoggedIn")
                dismiss(animated: true, completion: nil)
                
            } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
                // Sign in using an existing iCloud Keychain credential.
                let username = passwordCredential.user
                let password = passwordCredential.password
                
                // For the purpose of this demo app, show the password credential as an alert.
                DispatchQueue.main.async {
                    let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                    let alertController = UIAlertController(title: "Keychain Credential Received",
                                                            message: message,
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            // Handle error.
        }
    }


    extension InstructorLoginViewController: ASAuthorizationControllerPresentationContextProviding {
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return self.view.window!
        }
}
