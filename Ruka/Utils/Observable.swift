//
//  Observable.swift
//  Ruka
//
//  Created by George on 2018/03/17.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import Foundation


class Observable<T> {
    typealias Observer = (T) -> Void
    var observer: Observer?
    
    func observe(_ observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
    
    var value: T {
        didSet {
            observer?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}
