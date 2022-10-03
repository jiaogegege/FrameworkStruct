//
//  SceneDelegate.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/9.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    //获取单例对象，如果UIWindowScene对象还未初始化，那么返回nil
    static func shared() -> SceneDelegate?
    {
        for windowScene: UIWindowScene in (UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!
        {
            if windowScene.activationState == .foregroundActive
            {
                return windowScene.delegate as? SceneDelegate
            }
        }
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate
    }
    
    //获取当前windowScene
    var currentWindowScene: UIWindowScene? {
        for windowScene: UIWindowScene in (UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!
        {
            if windowScene.activationState == .foregroundActive
            {
                return windowScene
            }
        }
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    
    //获取当前UIWindow
    var currentWindow: UIWindow? {
        if let currentWindowScene = currentWindowScene {
            for window in currentWindowScene.windows
            {
                if window.isKeyWindow
                {
                    return window
                }
            }
        }
        
        return self.currentWindowScene?.windows.first
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
//        let windowScene = scene as! UIWindowScene
//        self.window = UIWindow(windowScene: windowScene)
//        self.window?.frame = windowScene.coordinateSpace.bounds
//        self.window?.rootViewController = BasicTabbarController.init()
//        self.window?.makeKeyAndVisible()
        
        ApplicationManager.shared.scene(scene, willConnectTo: session, options: connectionOptions)
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    //通过URL Schemes或其它App打开此App
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        ApplicationManager.shared.scene(scene, openURLContexts: URLContexts)
    }
    
    //当app在后台通过shortchut打开的时候调用
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        //处理shortcut打开app
        ApplicationManager.shared.windowScene(windowScene, performActionFor: shortcutItem) { (succeeded) in
            completionHandler(succeeded)
        }
    }

}

