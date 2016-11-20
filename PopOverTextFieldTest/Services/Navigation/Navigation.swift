//
//  Navigation.swift
//  NonReactiveMVVM
//
//  Created by Ian Keen on 20/04/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import UIKit

class Navigation {
    //MARK: - Private
    fileprivate let navigationController: UINavigationController
    fileprivate let application: Application
    
    //MARK: - Lifecycle
    init(window: UIWindow, navigationController: UINavigationController, application: Application) {
        self.application = application
        self.navigationController = navigationController
        window.rootViewController = self.navigationController
        window.makeKeyAndVisible()
    }
    
    //MARK: - Public
    func start() {
        self.studentEnrolment()
    }
    
    fileprivate func studentEnrolment(){
        let viewModel = StudentEnrolmentViewModel()
        let instance = StudentEnrolmentViewController(viewModel: viewModel)
        self.navigationController.pushViewController(instance, animated: false)
    }
}
