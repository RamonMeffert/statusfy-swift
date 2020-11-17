//
//  SwiftStatusfyApp.swift
//  SwiftStatusfy
//
//  Created by Ramon Meffert on 17/11/2020.
//

import SwiftUI

@main
struct MenuBarPopoverApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings{
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create statusbar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.button?.title = "♫" //TODO; change this to icon
        
        // Initialize menu
        let statusBarMenu = NSMenu(title: "Options Menu")
        statusBarItem?.menu = statusBarMenu
        
        statusBarMenu.addItem(
            withTitle: "Quit",
            action: #selector(AppDelegate.quit),
            keyEquivalent: "q")
        
        // this timer is the most important aspect of the application: it polls Spotify every couple of seconds to find what song / artist is currently playing.
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in self.setStatusItemTitle()
        }
    }
    
    // Apple script is needed to communicate with spotify
    @objc func executeAppleScript(_ command: String) throws -> String {
        // Add check to see if Spotify is running before executing the command
        let command = "if application \"Spotify\" is running then tell application \"Spotify\" to \(command)"
        
        // Try executing the command. Based on https://stackoverflow.com/a/50557481/4545692
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: command) {
            if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
                return outputString
            } else if let error = error {
                throw SwiftStatusfyError.spotifyCommunication(error: error)
            } else {
                throw SwiftStatusfyError.spotifyCommunication(error: nil)
            }
        }
        throw SwiftStatusfyError.appleScriptError
    }
    
    @objc func setStatusItemTitle() {
        
        let trackName: String? = try? executeAppleScript("get name of current track")
        let artistName: String? = try? executeAppleScript("get artist of current track")
        
        if let trackName = trackName, let artistName = artistName {
            let titleText = "\(trackName) – \(artistName)"
            
            statusBarItem?.button?.title = titleText
        } else {
            //TODO: set icon instead
            statusBarItem?.button?.title = "♫"
        }
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
}

enum SwiftStatusfyError: Error {
    case spotifyCommunication(error: NSDictionary?)
    case appleScriptError
}
