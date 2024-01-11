//
//  AudioItem.swift
//  AudioPlayer
//
//  Created by Furkan Erkorkmaz on 18/03/2018.
//

import AVFoundation
import Foundation
import UIKit

// MARK: - SourceType

public enum SourceType {
    case stream
    case file
}

// MARK: - AudioItem

public protocol AudioItem {
    func getSourceUrl() -> String
    func getArtist() -> String?
    func getTitle() -> String?
    func getAlbumTitle() -> String?
    func getSourceType() -> SourceType
    func getArtworkURL() -> URL?
    func getArtwork(_ handler: @escaping (UIImage?) -> Void)
}

// MARK: - TimePitching

/// Make your `AudioItem`-subclass conform to this protocol to control which AVAudioTimePitchAlgorithm is used for each item.
public protocol TimePitching {
    func getPitchAlgorithmType() -> AVAudioTimePitchAlgorithm
}

// MARK: - InitialTiming

/// Make your `AudioItem`-subclass conform to this protocol to control enable the ability to start an item at a specific time of playback.
public protocol InitialTiming {
    func getInitialTime() -> TimeInterval
}

// MARK: - AssetOptionsProviding

/// Make your `AudioItem`-subclass conform to this protocol to set initialization options for the asset. Available keys available at [Apple Developer Documentation](https://developer.apple.com/documentation/avfoundation/avurlasset/initialization_options).
public protocol AssetOptionsProviding {
    func getAssetOptions() -> [String: Any]
}

// MARK: - DefaultAudioItem

open class DefaultAudioItem: AudioItem {
    public var audioUrl: String

    public var artist: String?

    public var title: String?

    public var albumTitle: String?

    public var sourceType: SourceType

    public var artwork: UIImage?

    public var artworkURL: URL?

    public init(audioUrl: String, artist: String? = nil, title: String? = nil, albumTitle: String? = nil, sourceType: SourceType, artwork: UIImage? = nil, artworkURL: URL? = nil) {
        self.audioUrl = audioUrl
        self.artist = artist
        self.title = title
        self.albumTitle = albumTitle
        self.sourceType = sourceType
        self.artwork = artwork
        self.artworkURL = artworkURL
    }

    public func getSourceUrl() -> String {
        return audioUrl
    }

    public func getArtist() -> String? {
        return artist
    }

    public func getTitle() -> String? {
        return title
    }

    public func getAlbumTitle() -> String? {
        return albumTitle
    }

    public func getSourceType() -> SourceType {
        return sourceType
    }

    public func getArtwork(_ handler: @escaping (UIImage?) -> Void) {
        handler(artwork)
    }

    public func getArtworkURL() -> URL? {
        return artworkURL
    }
}

// MARK: - DefaultAudioItemTimePitching

/// An AudioItem that also conforms to the `TimePitching`-protocol
public class DefaultAudioItemTimePitching: DefaultAudioItem, TimePitching {
    public var pitchAlgorithmType: AVAudioTimePitchAlgorithm

    override public init(audioUrl: String, artist: String?, title: String?, albumTitle: String?, sourceType: SourceType, artwork: UIImage?, artworkURL: URL?) {
        pitchAlgorithmType = AVAudioTimePitchAlgorithm.lowQualityZeroLatency
        super.init(audioUrl: audioUrl, artist: artist, title: title, albumTitle: albumTitle, sourceType: sourceType, artwork: artwork, artworkURL: artworkURL)
    }

    public init(audioUrl: String, artist: String?, title: String?, albumTitle: String?, sourceType: SourceType, artwork: UIImage?, artworkURL: URL?, audioTimePitchAlgorithm: AVAudioTimePitchAlgorithm) {
        pitchAlgorithmType = audioTimePitchAlgorithm
        super.init(audioUrl: audioUrl, artist: artist, title: title, albumTitle: albumTitle, sourceType: sourceType, artwork: artwork, artworkURL: artworkURL)
    }

    public func getPitchAlgorithmType() -> AVAudioTimePitchAlgorithm {
        return pitchAlgorithmType
    }
}

// MARK: - DefaultAudioItemInitialTime

/// An AudioItem that also conforms to the `InitialTiming`-protocol
public class DefaultAudioItemInitialTime: DefaultAudioItem, InitialTiming {
    public var initialTime: TimeInterval

    override public init(audioUrl: String, artist: String?, title: String?, albumTitle: String?, sourceType: SourceType, artwork: UIImage?, artworkURL: URL?) {
        initialTime = 0.0
        super.init(audioUrl: audioUrl, artist: artist, title: title, albumTitle: albumTitle, sourceType: sourceType, artwork: artwork, artworkURL: artworkURL)
    }

    public init(audioUrl: String, artist: String?, title: String?, albumTitle: String?, sourceType: SourceType, artwork: UIImage?, artworkURL: URL?, initialTime: TimeInterval) {
        self.initialTime = initialTime
        super.init(audioUrl: audioUrl, artist: artist, title: title, albumTitle: albumTitle, sourceType: sourceType, artwork: artwork, artworkURL: artworkURL)
    }

    public func getInitialTime() -> TimeInterval {
        return initialTime
    }
}

// MARK: - DefaultAudioItemAssetOptionsProviding

/// An AudioItem that also conforms to the `AssetOptionsProviding`-protocol
public class DefaultAudioItemAssetOptionsProviding: DefaultAudioItem, AssetOptionsProviding {
    public var options: [String: Any]

    override public init(audioUrl: String, artist: String?, title: String?, albumTitle: String?, sourceType: SourceType, artwork: UIImage?, artworkURL: URL?) {
        options = [:]
        super.init(audioUrl: audioUrl, artist: artist, title: title, albumTitle: albumTitle, sourceType: sourceType, artwork: artwork, artworkURL: artworkURL)
    }

    public init(audioUrl: String, artist: String?, title: String?, albumTitle: String?, sourceType: SourceType, artwork: UIImage?, options: [String: Any]) {
        self.options = options
        super.init(audioUrl: audioUrl, artist: artist, title: title, albumTitle: albumTitle, sourceType: sourceType, artwork: artwork)
    }

    public func getAssetOptions() -> [String: Any] {
        return options
    }
}
