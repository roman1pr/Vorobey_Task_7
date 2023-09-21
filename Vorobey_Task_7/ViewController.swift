//
//  ViewController.swift
//  Vorobey_Task_7
//
//  Created by Roman Priiskalov on 21.09.2023.
//

import UIKit

//Вверху экрана находится картинка, под картинкой скролящаяся область. Высота картинки 270pt.

//- Если скролить вниз, то картинка растягивается. Верхний край прикреплен к верхей части экрана.
//- Если скролить вверх, картинка уходит наверх вместе со скролом.
//- Индикатор скрола (полоска справа) всегда находится ниже картинки и не должен залазить на неё.

class ViewController: UIViewController {
    
    private let imageHeight: CGFloat = 270.0
    private let topPadding = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    
    private var imageTopConstraint: NSLayoutConstraint!
    private var imageHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создание и настройка ImageView
        let imageView = UIImageView(image: UIImage(named: "nature.jpg"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Создание и настройка ScrollView
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        // Добавление ScrollView и ImageView на главный View
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)

        // Установка размера контента ScrollView
        scrollView.contentSize = CGSize(width: view.frame.width,
                                        height: view.bounds.height * 2)

        // Установка constraint для ImageView
        imageTopConstraint = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageHeight)

        // Установка ограничений для ScrollView и ImageView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageTopConstraint, imageHeightConstraint,
            imageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            imageView.widthAnchor.constraint(equalToConstant: scrollView.contentSize.width),
        ])

        // Установка делегата для ScrollView
        scrollView.delegate = self
        
        updateScroll(scrollView)
    }
    
    private func updateScroll(_ scrollView: UIScrollView?) {
        guard let contentOffY = scrollView?.contentOffset.y else { return }
        
        if contentOffY < 0 {
            imageTopConstraint.constant = contentOffY
            imageHeightConstraint.constant = imageHeight - contentOffY
        }
        
        scrollView?.verticalScrollIndicatorInsets.top = imageHeightConstraint.constant - view.safeAreaInsets.top
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateScroll(scrollView)
    }
}
