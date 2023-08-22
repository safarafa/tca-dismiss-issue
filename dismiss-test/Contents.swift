import ComposableArchitecture
import SwiftUI

struct RootFeature: Reducer {
    struct State: Equatable {
        var isVisible = true
        @PresentationState var child: ChildFeature.State?
    }
    enum Action: Equatable {
        case child(PresentationAction<ChildFeature.Action>)
        case itemTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .child:
                return .none
            case .itemTapped:
                state.child = .init()
                return.none
            }
        }
        .ifLet(\.$child, action: /Action.child){
            ChildFeature()
        }
    }
}

struct RootView: View {
    let store: StoreOf<RootFeature>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .center) {
                NavigationLinkStore(self.store.scope(state: \.$child, action: RootFeature.Action.child)) {
                    viewStore.send(.itemTapped)
                } destination: { childStore in
                    ChildView(store: childStore)
                } label: {
                    Text("Tap to see first level child")
                }
                
            }
            .padding()
        }
    }
}

struct ChildFeature: Reducer {
    struct State: Equatable {
    }
    enum Action: Equatable {
        case closeTapped
        case cancelTapped
    }
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeTapped:
                return .run { _ in await self.dismiss() }
            case .cancelTapped:
                NotificationCenter.default.post(name: .cancel, object: nil)
                return .none
            }
        }
    }
}

struct ChildView: View {
    let store: StoreOf<ChildFeature>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Button("Dismiss this Child") {
                    viewStore.send(.closeTapped)
                }
                
                Button("Dismiss using UIKit") {
                    viewStore.send(.cancelTapped)
                }
            }
            .padding()
        }
    }
}

extension Notification.Name {
    static let cancel = Notification.Name.init("cancel")
}
