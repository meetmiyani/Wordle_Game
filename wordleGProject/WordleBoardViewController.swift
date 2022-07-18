//
//  WordleBoardViewController.swift
//  wordleGProject
//
//  Created by Viren Rakholiya on 22/06/22.
//

import UIKit

protocol WordleBoardViewControllerDatasource: AnyObject {
    var currentGuesses: [[Character?]] { get }
    func boxColor(at indexPath: IndexPath) -> UIColor?
}

class WordleBoardViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        
    
    
    weak var datasource: WordleBoardViewControllerDatasource?

        private let collectionViewForKeyboard: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 4
            
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
                collectionViewForKeyboard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                collectionViewForKeyboard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                collectionViewForKeyboard.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
                collectionViewForKeyboard.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            view.backgroundColor = .lightGray
        }
    
        public func reloadWordleBoard(){
            print("Reload Data--1")
            collectionViewForKeyboard.reloadData()
            print("Reload Data--2")
        }
        
    }

    extension WordleBoardViewController{
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return datasource?.currentGuesses.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            let guesses = datasource?.currentGuesses ?? []
            return guesses[section].count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCollectionViewCell.identifier, for: indexPath) as? KeyCollectionViewCell else {
                    fatalError()
                }
            
            cell.backgroundColor = datasource?.boxColor(at: indexPath)
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.systemGray3.cgColor
            
            let guesses = datasource?.currentGuesses ?? []
            if let letter = guesses[indexPath.section][indexPath.row] {
//                print("cellForItemAt", letter)
                cell.configure(with: letter)
            }
            
            return cell
        }
        

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let margin: CGFloat = 20
            let size: CGFloat = (collectionView.frame.size.width-margin)/5

            return CGSize(width: size, height: size)
        }

        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            
            return UIEdgeInsets(
                top: 2,
                left: 2,
                bottom: 2,
                right: 2
            )
        }
        
        
    }
