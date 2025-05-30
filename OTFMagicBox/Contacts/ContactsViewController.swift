/*
 Copyright (c) 2024, Hippocrates Technologies Sagl. All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.

 3. Neither the name of the copyright holder(s) nor the names of any contributor(s) may
 be used to endorse or promote products derived from this software without specific
 prior written permission. No license is granted to the trademarks of the copyright
 holders even if such marks are included in this software.

 4. Commercial redistribution in any form requires an explicit license agreement with the
 copyright holder(s). Please contact support@hippocratestech.com for further information
 regarding licensing.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 OF SUCH DAMAGE.
 */

import OTFCareKitStore
import OTFCareKit
import Foundation
import UIKit
import SwiftUI

struct ContactsViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = OCKContactsListViewController
    @State private var contactsListViewController: OCKContactsListViewController
    private var viewModel = UpdateUserViewModel()
    var syncStoreManager: OCKSynchronizedStoreManager
    let queue = OperationQueue()

    init(storeManager: OCKSynchronizedStoreManager) {
        self.syncStoreManager = storeManager
        let viewController = OCKContactsListViewController(storeManager: storeManager)
        contactsListViewController = viewController
        viewController.title = Constants.CustomiseStrings.careTeam
        
        let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: 200, height: 20))
        label.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2.5)
        label.textAlignment = .center
        label.text = Constants.CustomiseStrings.noContacts
        
        viewModel.fetchContactsCount { result in
            switch result {
            case .success(let contacts):
                if contacts == 0 {
                    viewController.view.addSubview(label)
                } else {
                    label.removeFromSuperview()
                }
            case .failure(let error):
                print(error)
            }
        }

        NotificationCenter.default.addObserver(forName: .deleteUserAccount, object: nil, queue: queue) { _ in
            DispatchQueue.main.async {
                viewController.alertWithAction(title: Constants.CustomiseStrings.accountDeleted, message: Constants.deleteAccount) { _ in
                    OTFTheraforgeNetwork.shared.moveToOnboardingView()
                }
            }
        }

        NotificationCenter.default.addObserver(forName: .databaseSuccessfllySynchronized, object: nil, queue: queue) { _ in
            viewController.fetchContacts()
            DispatchQueue.main.async {
                label.removeFromSuperview()
            }
        }
    }

    func updateUIViewController(_ taskViewController: OCKContactsListViewController, context: Context) {}

    func makeUIViewController(context: Context) -> OCKContactsListViewController {
        return contactsListViewController
    }
}

struct ContactsNavigationView: View {
    let syncStoreManager: OCKSynchronizedStoreManager
    @State private var isPresenting = false

    var body: some View {
        NavigationView {
            ContactsViewController(storeManager: syncStoreManager)
                .navigationTitle(Text(Constants.CustomiseStrings.careTeam))
        }
    }
}
