//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Boris Erceg on 14/06/2016.
//  Copyright © 2016 kviksilver. All rights reserved.
//

import UIKit
import Messages

enum State {
    case NewInvoice
    case ReadyForPayment
    case WaitingForPayment
    
    init(message: MSMessage?,with conversation: MSConversation?) {
        guard let message = message,
            let conversation = conversation else {
                self = .NewInvoice
                return
        }
        //Why no work this?
        self = conversation.localParticipantIdentifier == message.senderParticipantIdentifier ? .WaitingForPayment : .ReadyForPayment
    }
    
    var title: String {
        switch self {
        case .NewInvoice:        return "Charge 1$"
        case .WaitingForPayment: return "Waiting 1$"
        case .ReadyForPayment:   return "Pay 1$"
        }
    }
}


class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var controllButton: UIButton!
    var state = State.NewInvoice
    var sending = false
    
    @IBAction func buttonTapped(_ sender: AnyObject) {
        switch state {
            //TODO open url
        default:
            let message = MSMessage()
            //TODO: get paypal name from user
            message.url = URL(string: "https://www.paypal.me/kviksilver/1")
            activeConversation?.insert(message, localizedChangeDescription: nil, completionHandler: nil)
            sending = true
        }
    }

    
    // MARK: - Conversation Handling
//    
    
    //TODO file a radar
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        updateWithMessage(message: conversation.selectedMessage, conversation: activeConversation)
        
    }
    
    func updateWithMessage(message: MSMessage?, conversation: MSConversation?) {
        state = State(message: message, with: conversation)
        updateUI()
    }
    
    func updateUI() {
        controllButton.setTitle(state.title, for: [])

    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        updateWithMessage(message: message, conversation: conversation)
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
      //  updateWithMessage(message: message, conversation: conversation)
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        updateWithMessage(message: message, conversation: conversation)
    }
}
