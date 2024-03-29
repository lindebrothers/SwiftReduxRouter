import ReSwift
import SwiftReduxRouter
import SwiftUI

struct ContentView: View {
    @ObservedObject var navigationState: NavigationState

    var dispatch: DispatchFunction

    static let navigationRoute = NavigationRoute("hello/<int:name>")
    let names = ["Cars", "Houses", "Bikes", "Toys", "Tools", "Furniture", "Jobs"]

    let backgrounds = [Color.red, Color.pink, Color.yellow, Color.green, Color.purple]

    var body: some View {
        RouterView(
            navigationState: navigationState,
            routes: [
                RouterView.Route(
                    route: Self.navigationRoute,
                    renderView: { session, params in
                        let presentedName = params["name"] as? Int ?? 0
                        let next = presentedName + 1
                        return AnyView(
                            HStack {
                                Spacer()
                                VStack(spacing: 10) {
                                    Spacer()

                                    Text("Presenting \(presentedName)")
                                        .font(.system(size: 50)).bold()
                                        .foregroundColor(.black)
                                    Button(action: {
                                        dispatch(
                                            NavigationActions.Push(
                                                path: Self.navigationRoute.reverse(params: ["name": "\(next)"])!,
                                                to: session.id
                                            )
                                        )
                                    }) {
                                        Text("Push \(next) to current session").foregroundColor(.black)
                                    }
                                    Button(action: {
                                        dispatch(
                                            NavigationActions.SelectTab(by: AppState.tabOne)
                                        )
                                        dispatch(
                                            NavigationActions.Push(
                                                path: Self.navigationRoute.reverse(params: ["name": "\(next)"])!,
                                                to: AppState.tabOne
                                            )
                                        )
                                    }) {
                                        Text("Push \(next) to Tab 1").foregroundColor(.black)
                                    }

                                    Button(action: {
                                        dispatch(
                                            NavigationActions.SelectTab(by: AppState.tabTwo)
                                        )
                                        dispatch(
                                            NavigationActions.Push(
                                                path: Self.navigationRoute.reverse(params: ["name": "\(next)"])!,
                                                to: AppState.tabTwo
                                            )
                                        )

                                    }) {
                                        Text("Push \(next) to Tab 2").foregroundColor(.black)
                                    }

                                    Button(action: {
                                        dispatch(
                                            NavigationActions.Present(
                                                path: Self.navigationRoute.reverse(params: ["name": "\(next)"])!
                                            )
                                        )
                                    }) {
                                        Text("Present \(next)").foregroundColor(.black)
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }

                            .background(backgrounds.randomElement() ?? Color.white)

                            .navigationTitle("\(presentedName)")
                            .navigationBarItems(trailing: Button(action: {
                                dispatch(
                                    NavigationActions.Dismiss(session: session)
                                )
                            }) {
                                Text(session.tab == nil ? "Close" : "")
                            })

                            .background(backgrounds.randomElement() ?? Color.white)
                        )
                    }
                ),
            ],
            tintColor: .red,
            setSelectedPath: { session, navigationPath in
                dispatch(NavigationActions.SetSelectedPath(session: session, navigationPath: navigationPath))
            },
            onDismiss: { session in
                dispatch(NavigationActions.SessionDismissed(session: session))
            }
        )
        .edgesIgnoringSafeArea(.all)
        .background(Color.red)
    }
}
