//
//  ViewController.swift
//  lifecounter
//
//  Created by stlp on 4/25/22.
//

import UIKit

class ViewController: UIViewController {
    private let defaultPlayerLabel = "Player"
    private let defaultLifeLabel = "Life: 20"
    private var numberOfPlayer = 0
    private var playersLife : [Int] = []
    private var history : [String] = []
    
    @IBOutlet weak var btnAddPlayer: UIButton!
    @IBOutlet weak var btnRemovePlayer: UIButton!
    @IBOutlet weak var viewholder: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialization()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Optional("toHistory"):
            let historyVC = segue.destination as! HistoryViewController
            historyVC.history = self.history
            break
        default:
            print("invalid Segue")
        }
    }
    
    @IBAction func addplayer(_ sender: Any) {
        addPlayer()
    }
    
    @IBAction func removePlayer(_ sender: Any) {
        removePlayer()
    }
    
    @IBAction func reset(_ sender: Any) {
        reset()
    }
    
    private func initialization() {
        numberOfPlayer = 0
        playersLife = []
        for _ in 1...4 {
            addPlayer()
        }
        history = []
        btnAddPlayer.isEnabled = true
        btnRemovePlayer.isEnabled = true
    }
    
    private func addPlayer() {
        if numberOfPlayer >= 8 {
            return
        }
        numberOfPlayer += 1
        playersLife.append(20)
        
        if let playerView =
          Bundle.main.loadNibNamed("PlayerView",
                                   owner: self,
                                   options: nil)?.first! as? PlayerView {
          playerView.frame = viewholder.frame
          playerView.frame.origin.y += CGFloat(80.0 * CGFloat(numberOfPlayer - 1))
          playerView.frame.size.height = CGFloat(80.0)
            
            playerView.playerLabel.text = "\(defaultPlayerLabel) \(numberOfPlayer)"
            playerView.playerLabel.tag = numberOfPlayer
            playerView.playerLabel.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeName(tapGestureRecognizer:)))
            playerView.playerLabel.addGestureRecognizer(tapGesture)
            playerView.lifeLabel.text = defaultLifeLabel
            playerView.btnPlus1.tag = numberOfPlayer
            playerView.btnPlus1.addTarget(self, action: #selector(plus1(_:)), for: .touchUpInside)
            playerView.btnMinus1.tag = numberOfPlayer
            playerView.btnMinus1.addTarget(self, action: #selector(minus1(_:)), for: .touchUpInside)
            playerView.btnPlus.tag = numberOfPlayer
            playerView.btnPlus.addTarget(self, action: #selector(plus(_:)), for: .touchUpInside)
            playerView.btnMinus.tag = numberOfPlayer
            playerView.btnMinus.addTarget(self, action: #selector(minus(_:)), for: .touchUpInside)
          viewholder.addSubview(playerView)
        }
    }
    
    @objc private func changeName(tapGestureRecognizer: UITapGestureRecognizer) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Change Name", message: "Enter a name", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            let playerIndex = tapGestureRecognizer.view!.tag
            let playerView = self.viewholder.subviews[playerIndex - 1] as! PlayerView
            playerView.playerLabel.text = textField.text!
            
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    private func removePlayer() {
        if numberOfPlayer > 2 {
            numberOfPlayer -= 1
            playersLife.remove(at: numberOfPlayer)
            viewholder.subviews[numberOfPlayer].removeFromSuperview()
        }
    }
    
    @objc func plus1(_ sender: UIButton) {
        disableButtons()
        playersLife[sender.tag - 1] += 1
        updateLife(sender.tag - 1)
        let playerView = viewholder.subviews[sender.tag - 1] as! PlayerView
        history.append("\(playerView.playerLabel.text!) gained 1 life.")
    }
    
    @objc func minus1(_ sender: UIButton) {
        disableButtons()
        playersLife[sender.tag - 1] -= 1
        updateLife(sender.tag - 1)
        let playerView = viewholder.subviews[sender.tag - 1] as! PlayerView
        history.append("\(playerView.playerLabel.text!) lost 1 life.")
        if playersLife[sender.tag - 1] <= 0 {
            endGame(playerView.playerLabel.text!)
        }
        
    }
    
    @objc func plus(_ sender: UIButton) {
        disableButtons()
        let playerView = viewholder.subviews[sender.tag - 1] as! PlayerView
        let input = playerView.input.text
        if input != "" {
            disableButtons()
            playersLife[sender.tag - 1] += Int(input!) ?? 0
            updateLife(sender.tag - 1)
            history.append("\(playerView.playerLabel.text!) gained \(Int(input!) ?? 0) life.")
        }
    }
    
    @objc func minus(_ sender: UIButton) {
        let playerView = viewholder.subviews[sender.tag - 1] as! PlayerView
        let input = playerView.input.text
        if input != "" {
            disableButtons()
            playersLife[sender.tag - 1] -= Int(input!) ?? 0
            updateLife(sender.tag - 1)
            history.append("\(playerView.playerLabel.text!) lost \(Int(input!) ?? 0) life.")
        }
        if playersLife[sender.tag - 1] <= 0 {
            endGame(playerView.playerLabel.text!)
        }
    }
    
    private func updateLife(_ index: Int) {
        let playerView = viewholder.subviews[index] as! PlayerView
        playerView.lifeLabel.text = "Life: \(playersLife[index])"
    }
    
    private func disableButtons() {
        btnAddPlayer.isEnabled = false
        btnRemovePlayer.isEnabled = false
    }
    
    private func reset() {
        for playerView in viewholder.subviews {
            playerView.removeFromSuperview()
        }
        initialization()
    }
    
    private func endGame(_ loser: String) {
        let alert = UIAlertController(title: "Game Over!", message: "\(loser) LOST!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: { _ in
                self.reset()
            }))
            self.present(alert, animated: true, completion: {
              NSLog("The completion handler fired")
            })
    }
}

