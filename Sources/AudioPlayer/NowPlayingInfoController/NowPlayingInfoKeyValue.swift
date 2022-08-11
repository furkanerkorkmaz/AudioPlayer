//
//  NowPlayingInfoKeyValue.swift
//  AudioPlayer
//
//  Created by Furkan Erkorkmaz on 28/02/2019.
//

import Foundation


public protocol NowPlayingInfoKeyValue {
    func getKey() -> String
    func getValue() -> Any?
}
