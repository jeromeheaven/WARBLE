//
//  ParentPlayerCellView.swift
//  Tempo
//
//  Created by Jesse Chen on 11/25/16.
//  Copyright © 2016 CUAppDev. All rights reserved.
//

import UIKit

class ParentPlayerCellView: UIView {

	var playerCenter: PlayerCenter!
	var songStatus: SavedSongStatus = .notSaved
	var post: Post?
	var postsLikable: Bool?
	
	weak var delegate: PlayerDelegate? {
		didSet {
			postsLikable = delegate is FeedViewController || delegate is PostHistoryTableViewController
		}
	}
	
	//Initial setup
	func setup() {
		preconditionFailure("This method must be overridden")
	}
	
	//Responsible for updating the post, labels, images, etc.
	func updateCellInfo(newPost: Post) {
		preconditionFailure("This method must be overridden")
	}
	
	//Responsible for updating saved status (saved vs. notSaved)
	func updateSavedStatus() {
		preconditionFailure("This method must be overridden")
	}
	
	//Responsible for checking whether the song is playing, calls updatePlayToggleButton()
	func updatePlayingStatus() {
		preconditionFailure("This method must be overridden")
	}
	
	//Visual update for playToggleButton, based on whether the song is playing or not
	func updatePlayToggleButton() {
		preconditionFailure("This method must be overridden")
	}
	
	//Switches saved to notSaved, or notSaved to saved, and calls updateAddButton()
	func toggleAddButton() {
		if let post = post {
			toggleAddButton(post: post)
		}
	}
	
	func toggleAddButton(post: Post, completion: (() -> Void)? = nil) {
		if let _ = User.currentUser.currentSpotifyUser {
			SpotifyController.sharedController.spotifyIsAvailable { success in
				let songStatus = SpotifyController.sharedController.getSongStatus(post: post)
				if success && songStatus == .notSaved {
					SpotifyController.sharedController.saveSpotifyTrack(post) { success in
						if success {
							self.playerCenter.updateAddButton()
							self.delegate?.didToggleAdd?()
							completion?()
						}
					}
				} else if success && songStatus == .saved {
					SpotifyController.sharedController.removeSavedSpotifyTrack(post) { success in
						if success {
							self.playerCenter.updateAddButton()
							self.delegate?.didToggleAdd?()
							completion?()
						}
					}
				}
			}
		} else {
			(TabBarController.sharedInstance.currentlyPresentedViewController as? UINavigationController)?.pushViewController(SettingsScrollViewController.sharedInstance, animated: true)
		}
	}
	
	//Visual update for add button, based on whether the song is saved or notSaved
	func updateAddButton() {
		preconditionFailure("This method must be overriden")
	}
	
	//Clears any playing song, resets all labels to default state
	func resetPlayerCell() {
		post = nil
	}
}
