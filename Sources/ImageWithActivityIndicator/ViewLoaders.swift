//
//  File.swift
//  
//
//  Created by luca on 9/5/19.
//

@available(iOS 13.0, *)
@available(watchOS 6.0, *)
@available(OSX 10.15, *)
public struct ViewLoaders {
    var loaders: [ViewLoader] = []
    init(urls: [String]) {
        for url in urls {
            loaders.append(ViewLoader(url: url))
        }
    }
}
