//
//  SafariExtensionViewController.swift
//  Safari
//
//  Copyright © 2019 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import TrackerBlocking
import SafariServices
import Statistics

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = SafariExtensionViewController()

    @IBOutlet weak var backgroundEffectView: NSVisualEffectView!
    @IBOutlet weak var dashboardHolder: NSView!
    @IBOutlet weak var menuButton: NSButton!
    @IBOutlet weak var titleLabel: NSTextField!

    weak var navigationController: NavigationController!

    /// Always  dispatch to the main thread
    var pageData: PageData? {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }

    var currentWindow: SFSafariWindow?
    
    private let pixel: Pixel = Dependencies.shared.pixel

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredContentSize = NSSize(width: 310, height: 498)

        initTitle()
        initButton(menuButton)
        installPageController()
        initBackgroundEffectView()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        DefaultStatisticsLoader.shared.refreshAppRetentionAtb(atLocation: AtbLocations.safariExtensionViewController, completion: nil)
    }
    
    @IBAction func openMenu(sender: Any) {
        pixel.fire(.dashboardMenuOpened)
        NSWorkspace.shared.open(URL(string: AppLinks.home)!)
    }
    
    @IBAction func showHomePage(sender: Any) {
        pixel.fire(.dashboardHomePageOpened)
        self.currentWindow?.openTab(with: URL(string: "https://duckduckgo.com")!, makeActiveIfPossible: true) { _ in
            self.dismissPopover()
        }
    }

    private func initButton(_ button: NSButton) {
        let cell = button.cell as? NSButtonCell
        cell?.backgroundColor = NSColor.clear
    }
    
    private func installPageController() {
        guard let navigationController = NSViewController.loadController(named: "NavController",
                                                                         fromStoryboardNamed: "Dashboard") as? NavigationController else {
            fatalError("failed to load \(NavigationController.self)")
        }
        
        navigationController.view.frame = dashboardHolder.frame
        navigationController.view.autoresizingMask = [.width, .height]
        
        dashboardHolder.addSubview(navigationController.view)
        addChild(navigationController)
        
        navigationController.pageData = pageData
        self.navigationController = navigationController
    }

    private func updateUI() {
        navigationController?.pageData = pageData
    }
    
    private func initTitle() {
        titleLabel.attributedStringValue = NSAttributedString(string: titleLabel.stringValue, kern: NSAttributedString.headerKern)
    }

    private func initBackgroundEffectView() {
        backgroundEffectView.material = .underWindowBackground
    }
}
