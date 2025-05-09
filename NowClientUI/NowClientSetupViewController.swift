import UIKit
import LoopKit
import LoopKitUI
import EversenseNowClient


class NowClientSetupViewController: UINavigationController, CGMManagerOnboarding, CompletionNotifying {
    weak var cgmManagerOnboardingDelegate: CGMManagerOnboardingDelegate?
    weak var completionDelegate: CompletionDelegate?

    let cgmManager = NowClientManager()

    init() {
        let authVC = AuthenticationViewController(authentication: cgmManager.nowService)

        super.init(rootViewController: authVC)

        authVC.authenticationObserver = { [weak self] (service) in
            self?.cgmManager.nowService = service
        }
        authVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        authVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func cancel() {
        completionDelegate?.completionNotifyingDidComplete(self)
    }

    @objc private func save() {
        cgmManagerOnboardingDelegate?.cgmManagerOnboarding(didCreateCGMManager: cgmManager)
        cgmManagerOnboardingDelegate?.cgmManagerOnboarding(didOnboardCGMManager: cgmManager)
        completionDelegate?.completionNotifyingDidComplete(self)
    }
}
