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

import SwiftUI
import OTFCareKit

struct CareKitViews: View {
    var body: some View {
            VStack {
                Text("CareKit Views")
                    .foregroundColor(.otfTextColor)
                    .font(Font.otfscreenTitleFont)
                    .fontWeight(Font.otfscreenTitleFontWeight)
                    .padding(.top)
                List {
                    ContactsSection()
                    TaskSection()
                }
                .listStyle(GroupedListStyle())
            }
    }
}

struct ResearchKitViews: View {
    var body: some View {
        VStack {
            Text("ResearchKit Views")
                .foregroundColor(.otfTextColor)
                .font(Font.otfscreenTitleFont)
                .fontWeight(Font.otfscreenTitleFontWeight)
                .padding(.top)
            List {
                SurveysList()
                SurveyQuestionsList()
                OnboardingList()
                ActiveTasksList()
                MiscellaneousList()
            }
            .listStyle(GroupedListStyle())
        }

    }
}

struct StaticUI: View {

    @State private var isPresenting = false

    init() {
        UITableView.appearance().separatorColor = YmlReader().appStyle.separatorColor.color
        UITableView.appearance().backgroundColor = YmlReader().appStyle.backgroundColor.color
    }
    var body: some View {
            VStack {
                List {
                    NavigationLink(destination: CareKitViews().navigationTitle(Text(""))) {
                        Text(ModuleAppYmlReader().careKitModel?.careKit ?? "CareKit")
                            .fontWeight(Font.otfFontWeight)
                    }
                    .foregroundColor(.otfTextColor)
                    .listRowBackground(Color.otfCellBackground)

                    NavigationLink(destination: ResearchKitViews().navigationTitle(Text(""))) {
                        Text(ModuleAppYmlReader().researchKitModel?.researchKit ?? "ResearchKit")
                            .fontWeight(Font.otfFontWeight)
                    }
                    .foregroundColor(.otfTextColor)
                    .listRowBackground(Color.otfCellBackground)
                }
                .listStyle(GroupedListStyle())
                .onReceive(NotificationCenter.default.publisher(for: .deleteUserAccount)) { _ in
                    isPresenting = true
                }
                .alert(isPresented: $isPresenting) {

                    Alert(
                        title: Text(Constants.CustomiseStrings.accountDeleted)
                            .font(Font.otfAppFont)
                            .fontWeight(Font.otfFontWeight),
                        message: Text(Constants.deleteAccount),
                        dismissButton: .default(Text(Constants.CustomiseStrings.okay), action: {
                            OTFTheraforgeNetwork.shared.moveToOnboardingView()
                        })
                    )
                }
                .onDisappear {
                    NotificationCenter.default.removeObserver(self, name: .deleteUserAccount, object: nil)
                }
                .background(Color.otfCellBackground)
            }
        .font(Font.otfAppFont)
    }
}

struct StaticUI_Previews: PreviewProvider {
    static var previews: some View {
        StaticUI()
    }
}
