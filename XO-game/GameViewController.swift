//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet weak var playerControl: UISegmentedControl!
    
    private var counter: Int = 0
    private let gameboard = Gameboard()
    
    var selectPlayer: SelectPlayer {
        switch self.playerControl.selectedSegmentIndex {
        case 0:
            return .human
        case 1:
            return .computer
        default:
            return .human
        }
    }
    
    private var currentState: GameState! {
        didSet {            
            if selectPlayer == .computer {
                self.currentState.beginWithComp()
            } else {
                self.currentState.begin()
            }
        }
    }
    
    private lazy var referee = Referee(gameboard: self.gameboard)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            goToFirstState()
                        
            gameboardView.onSelectPosition = { [weak self] position in
                guard let self = self else { return }
                self.currentState.addMark(at: position)
                self.counter += 1
                if self.currentState.isCompleted {
                    self.goToNextState()
                }
            }

    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Log(.restartGame)

        gameboardView.clear()
        gameboard.clear()
        counter = 0
        goToFirstState()
    }
    
    private func goToFirstState() {
        let player = Player.first
        self.currentState = PlayerInputState(player: player, markViewPrototype: player.markViewPrototype, gameViewController: self, gameboard: gameboard, gameboardView: gameboardView)
    }

    private func goToNextState() {
        if let winner = self.referee.determineWinner() {
            self.currentState = GameEndedState(winner: winner, gameViewController: self)
            return
        }
        
        if counter >= 9 {
            self.currentState = GameEndedState(winner: nil, gameViewController: self)
        }
        
        if let playerInputState = currentState as? PlayerInputState { 
            let player = playerInputState.player.next
            self.currentState = PlayerInputState(player: player, markViewPrototype: player.markViewPrototype, gameViewController: self, gameboard: gameboard, gameboardView: gameboardView)
        }
        
        if selectPlayer == .computer {
            guard let computerInputState = currentState as? ComputerInputState else { return }
            let player = computerInputState.player.next
            self.currentState = ComputerInputState(player: player, markViewPrototype: player.markViewPrototype, gameViewController: self, gameboard: gameboard, gameboardView: gameboardView)
        }
    }

}

