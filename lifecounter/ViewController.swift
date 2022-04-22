//
//  ViewController.swift
//  lifecounter
//
//  Created by stlp on 4/21/22.
//

import UIKit

class ViewController: UIViewController {

    private var player1_life = 20
    private var player2_life = 20
    
    private let player1 = "Player 1"
    private let player2 = "Player 2"
    
    @IBOutlet weak var life1: UILabel!
    @IBOutlet weak var life2: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    
    @IBAction func plus1(_ sender: UIButton) {
        if sender.tag == 1 {
            player1_life += 1
            setLabel(life1, player1_life)
        } else {
            player2_life += 1
            setLabel(life2, player2_life)
        }
    }
    
    @IBAction func minus1(_ sender: UIButton) {
        if sender.tag == 1 {
            player1_life -= 1
            setLabel(life1, player1_life)
            if player1_life <= 0 {
                lose(player1)
            }
        } else {
            player2_life -= 1
            setLabel(life2, player2_life)
            if player2_life <= 0 {
                lose(player2)
            }
        }
    }
    
    @IBAction func plus5(_ sender: UIButton) {
        if sender.tag == 1 {
            player1_life += 5
            setLabel(life1, player1_life)
        } else {
            player2_life += 5
            setLabel(life2, player2_life)
        }
    }
    
    @IBAction func minus5(_ sender: UIButton) {
        if sender.tag == 1 {
            player1_life -= 5
            setLabel(life1, player1_life)
            if player1_life <= 0 {
                lose(player1)
            }
        } else {
            player2_life -= 5
            setLabel(life2, player2_life)
            if player2_life <= 0 {
                lose(player2)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loseLabel.isHidden = true
    }

    private func setLabel(_ label: UILabel, _ life: Int) {
        label.text = "Life: \(life)"
    }
    
    private func lose(_ player: String) {
        loseLabel.text = "\(player) LOSES!"
        loseLabel.isHidden = false
    }

}

