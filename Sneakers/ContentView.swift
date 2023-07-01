//
//  ContentView.swift
//  Sneakers
//
//  Created by Балауса Косжанова on 29.05.2023.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var shouldShowOnboarding:Bool = true
    var body: some View {
        NavigationView {
           WelcomePageView()
        }
        .fullScreenCover(isPresented:$shouldShowOnboarding) {
            OnboardingView(showOnboarding: $shouldShowOnboarding)
        }
        .navigationBarBackButtonHidden()
    }
}
struct PageView: View {
    var page: Page
    @State private var pageIndex = 0
    var body: some View {
        ZStack {
            Image("\(page.imageURL)")
                .resizable()
             
           
    
        }
    }
    
}
struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var pageIndex = 0
    private let pages:[Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()
    var body: some View {
        ZStack {
            TabView(selection:$pageIndex) {
                ForEach(pages) { page in
                    PageView(page: page)
                        .background(Color.white)
                        .tag(page.tag)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .animation(.easeOut, value: pageIndex)
            .onAppear {
                dotAppearance.currentPageIndicatorTintColor = .black
                dotAppearance.pageIndicatorTintColor = .gray
                

                    }
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 400,height: 288)
                        
                        .foregroundColor(.black)
                        .opacity(0.3)
                    VStack {
                        Text("Fast shipping")
                            .foregroundColor(.white)
                            .font(.system(size: 28))
                            .fontWeight(.semibold)
                            .padding(.bottom)
                        Text("Get all of your desired sneakers in one place.")
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                        
                        
                        Button {
                            
                            incrementPage()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(.black)
                                    .frame(width: 358,height: 54)
                                Text( pageIndex == 2 ? "Finish" : "Next" )
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                        }

                    }
                }
            }
            .ignoresSafeArea()

        }
    }
    
    func incrementPage() {
        if pageIndex == 2 {
            showOnboarding = false
            
        } else {
            pageIndex += 1
        }
     }
     
     func goToZero() {
         pageIndex = 0
     }
    
  
 
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
