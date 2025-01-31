//
//  SwiftUIView.swift
//  testswiftui
//
//  Created by Ali Adam on 6/12/19.
//  Copyright © 2019 AliAdam. All rights reserved.
//

import SwiftUI


@available(iOS 13.0, *)
@available(watchOS 6.0, *)
@available(OSX 10.15, *)
public struct ViewWithActivityIndicator<Content:View> : View {
    #if !os(watchOS)
    private let style: UIActivityIndicatorView.Style = .medium
    #endif

    @ObservedObject private var viewLoader:ViewLoader
    private var content: () -> Content
    private let placeHolder:String
    private let aspectRatioHint:CGFloat
    private let showActivityIndicator:Bool

    public init(placeHolder: String = "", aspectRatioHint: CGFloat = 1, showActivityIndicator:Bool = true, viewLoader:ViewLoader, @ViewBuilder _ content: @escaping () -> Content){
        self.placeHolder = placeHolder
        self.aspectRatioHint = aspectRatioHint
        self.showActivityIndicator = showActivityIndicator
        self.viewLoader = viewLoader
        self.content = content
    }
    
    public var body: some View {
            ZStack(){
                if  (viewLoader.data.isEmpty) {
                    if (placeHolder == "") {
                        Rectangle()
                            .fill(Color.white)
                            .aspectRatio(self.aspectRatioHint, contentMode: .fit)
                    }
                    else {
                        Image(placeHolder)
                            .resizable()
                            .scaledToFit()
                    }
                    
                    if showActivityIndicator {
                        #if !os(watchOS)
                        ActivityIndicator(style: .large)
                        #endif
                    }
                }
                else {
                    content()
                }
            }
                .onAppear(perform: loadImage)
    }
    
    private  func loadImage() {
        self.viewLoader.loadData()
    }

}

#if DEBUG

struct ImageWithActivityIndicator_Previews: PreviewProvider {
    static let loader = ViewLoader(url: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/300px-Apple_logo_black.svg.png")
    
    @available(iOS 13.0, *)
    @available(watchOS 6.0, *)
    @available(OSX 10.15, *)
    static var previews: some View {
        VStack {
            ViewWithActivityIndicator(aspectRatioHint: 300 / 356, viewLoader: loader) {
                Image(uiImage: UIImage(data: loader.getData()) ?? UIImage())
            }
            ViewWithActivityIndicator(viewLoader: ViewLoader(url: "foo")) {
                Image(uiImage: UIImage())
            }
        }
    }
}
#endif
