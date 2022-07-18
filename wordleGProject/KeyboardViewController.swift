//
//  KeyboardViewController.swift
//  wordleGProject
//
//  Created by Viren Rakholiya on 22/06/22.
//

import UIKit


protocol KeyboardViewControllerDelegate: AnyObject {
    func keyboardViewController(
        _ vc: KeyboardViewController,
        didTapKey letter: Character
    )
}

class KeyboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//q
//    }
    
    
    let lettersForKeyboard = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]
    var keys: [[Character]] = []
    weak var delegate: KeyboardViewControllerDelegate?

    let collectionViewForKeyboard: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        
        // Need to refactor this code
        let collectionVIew = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVIew.translatesAutoresizingMaskIntoConstraints = false
        collectionVIew.backgroundColor = .clear
        collectionVIew.register(KeyCollectionViewCell.self, forCellWithReuseIdentifier: KeyCollectionViewCell.identifier)
                return collectionVIew
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewForKeyboard.delegate = self
        collectionViewForKeyboard.dataSource = self
        view.addSubview(collectionViewForKeyboard)
        NSLayoutConstraint.activate([
            collectionViewForKeyboard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewForKeyboard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionViewForKeyboard.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collectionViewForKeyboard.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        view.backgroundColor = .lightGray
        
        for row in lettersForKeyboard {
            let chars = Array(row)
            keys.append(chars)
        }
    }
    
}

extension KeyboardViewController{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCollectionViewCell.identifier, for: indexPath) as? KeyCollectionViewCell else {
                fatalError()
            }
            let letter = keys[indexPath.section][indexPath.row]
            cell.configure(with: letter)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width-margin)/10

        return CGSize(width: size, height: size*1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var left: CGFloat = 1
        var right: CGFloat = 1

        // Centering the item
        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width-margin)/10
        let count: CGFloat = CGFloat(collectionView.numberOfItems(inSection: section))

        let inset: CGFloat = (collectionView.frame.size.width - (size * count) - (2 * count))/2
        left = inset
        right = inset
        
        return UIEdgeInsets(
            top: 2,
            left: left,
            bottom: 2,
            right: right
        )
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      // When key is pressed
        collectionView.deselectItem(at: indexPath, animated: true)
        let letter = keys[indexPath.section][indexPath.row]
//        print("Pressed: ", letter.uppercased())
        delegate?.keyboardViewController(self, didTapKey: letter)
    }
    
}
