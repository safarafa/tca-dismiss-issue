import ComposableArchitecture
import SwiftUI
import UIKit
import Combine

final class RootViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Dismiss Test"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        NotificationCenter.default.addObserver(self, selector: #selector(cancel), name: .cancel, object: nil)
    }

    @objc private func cancel() {
        self.dismiss(animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Dismiss Test"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let navigationController = UINavigationController(rootViewController: makeTransfersList())
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navigationController, animated: true, completion: nil)
    }

    func makeTransfersList() -> UIViewController {
        let controller = UIHostingController(rootView: RootView(store: Store(initialState: RootFeature.State()) {
            RootFeature()._printChanges()
        }))
        return controller
    }
}
