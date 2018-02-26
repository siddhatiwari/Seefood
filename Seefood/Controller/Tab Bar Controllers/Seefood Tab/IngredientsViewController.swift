//
//  IngredientsViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/10/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        if let nav = navigationController?.navigationBar {
            nav.prefersLargeTitles = true
            nav.barTintColor = .white//Constants.Colors().primaryColor
            nav.tintColor = Constants.Colors().secondaryColor
            nav.isTranslucent = true
            self.title = "Ingredients"
        }
        setupNavBarButtons()
        setupViews()
        ingredientsCollectionView.reloadData()
    }
    
    func setupViews() {
        view.addSubview(ingredientsCollectionView)
        view.addSubview(viewRecipesButton)
        
        let safeViewMargins = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            viewRecipesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewRecipesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewRecipesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -49),
            viewRecipesButton.heightAnchor.constraint(equalToConstant: 49),
            
            ingredientsCollectionView.topAnchor.constraint(equalTo: safeViewMargins.topAnchor),
            ingredientsCollectionView.leadingAnchor.constraint(equalTo: safeViewMargins.leadingAnchor),
            ingredientsCollectionView.trailingAnchor.constraint(equalTo: safeViewMargins.trailingAnchor),
            ingredientsCollectionView.bottomAnchor.constraint(equalTo: viewRecipesButton.topAnchor),
            ])
        
        viewRecipesButton.addTarget(self, action: #selector(viewRecipesButtonTapped), for: .touchUpInside)
        viewRecipesButton.addTarget(self, action: #selector(viewRecipesButtonTouchDown), for: .touchDown)
        viewRecipesButton.addTarget(self, action: #selector(viewRecipeButtonTouchUp), for: .touchUpInside)
        viewRecipesButton.addTarget(self, action: #selector(viewRecipeButtonTouchUp), for: .touchUpOutside)
    }
    
    func setupNavBarButtons() {
        self.navigationItem.hidesBackButton = true
        let closeButtonImage = UIImage(named: "ic_close_white")?.withRenderingMode(.alwaysTemplate)
        let closeButton = UIButton()
        closeButton.contentMode = .scaleAspectFill
        closeButton.setImage(closeButtonImage, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTouchUpInside(sender:)), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let searchBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationItem.setLeftBarButton(searchBarButtonItem, animated: true)
    }
    
    lazy var ingredientsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.register(IngredientCell.self, forCellWithReuseIdentifier: cellId)
        view.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        view.backgroundColor = .white
        view.alwaysBounceVertical = true
        return view
    }()
    
    let cellId = "cellId"
    let footerId = "footerId"
    
    let viewRecipesButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Colors().secondaryColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle("VIEW RECIPES", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Demibold", size: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func closeButtonTouchUpInside(sender: UIButton) {
        FoodData.currentPictures.removeAll()
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(TabBarController(), animated: false, completion: nil)
    }
    
    @objc func viewRecipesButtonTapped() {
        self.navigationController?.pushViewController(CalculatedRecipesViewController(), animated: true)
    }
    
    @objc func viewRecipesButtonTouchDown() {
        UIView.transition(with: viewRecipesButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.viewRecipesButton.backgroundColor = Constants.Colors().secondaryDarkColor
        }, completion: nil)
    }
    
    @objc func viewRecipeButtonTouchUp() {
        UIView.transition(with: viewRecipesButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.viewRecipesButton.backgroundColor = Constants.Colors().secondaryColor
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FoodData.currentPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingredientsCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! IngredientCell
        let ingredient = FoodData.currentPictures[indexPath.row]
        cell.picture = ingredient.image
        cell.name = ingredient.name
        cell.ingredientLabelChanged = { text in
            FoodData.currentPictures[indexPath.row].name = text
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ingredientsCollectionView.frame.width / 2
        return CGSize(width: width, height: width * 1.78)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = ingredientsCollectionView.frame.width / 2
        return CGSize(width: width, height: width * 1.78)
    }
    
}
