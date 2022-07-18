//
//  ViewController.swift
//  wordleGProject
//
//  Created by Viren Rakholiya on 22/06/22.
//

import UIKit

class ViewController: UIViewController {
    
    let answers = ["viren", "chris", "wordle", "guest"]
    var answer = ""
    private var guesses: [[Character?]] = Array(
        repeating: Array(repeating: nil, count: 5),
        count: 6
    )
    
    let keyboardViewC = KeyboardViewController()
    let WordleBoardViewC = WordleBoardViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        answer = answers.randomElement() ?? "setup"
        addChildrenControllers()
    }
    
    private func addChildrenControllers(){
        addChild(keyboardViewC)
        keyboardViewC.didMove(toParent: self)
        keyboardViewC.delegate = self
        keyboardViewC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardViewC.view)
        
        addChild(WordleBoardViewC)
        WordleBoardViewC.didMove(toParent: self)
        WordleBoardViewC.view.translatesAutoresizingMaskIntoConstraints = false
        WordleBoardViewC.datasource = self
        view.addSubview(WordleBoardViewC.view)
        
        addConstriantsToChildrenControllers()
    }
    
    private func addConstriantsToChildrenControllers(){
        NSLayoutConstraint.activate([
            WordleBoardViewC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            WordleBoardViewC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            WordleBoardViewC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            WordleBoardViewC.view.bottomAnchor.constraint(equalTo: keyboardViewC.view.topAnchor),
            WordleBoardViewC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),

            keyboardViewC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardViewC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardViewC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
}

extension ViewController: KeyboardViewControllerDelegate {
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {
        print("Letter Back: ", letter.uppercased())
        var stop = false

        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }

            if stop {
                break
            }
        }
        
        WordleBoardViewC.reloadWordleBoard()
        print("After loading Board: ", letter.uppercased())
    }
}

extension ViewController: WordleBoardViewControllerDatasource {
    var currentGuesses: [[Character?]]{
        return guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowWordleIndex = indexPath.section
        let counter = guesses[rowWordleIndex].compactMap({$0}).count
        guard counter == 5 else {
            return nil
        }
        let charOfLetter = Array(answer)
        guard let letter = guesses[indexPath.section][indexPath.row],
              charOfLetter.contains(letter) else {
            return nil
        }
        
        if charOfLetter[indexPath.row] == letter{
            return .systemBlue
        }
        return .systemOrange
    }
}
