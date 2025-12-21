import Constructors
import HTML
import CSS

public struct StandardNavigationMenu: WebComponent {
    public let navigation: NavigationStructure

    public init(navigation: NavigationStructure) {
        self.navigation = navigation
    }

    public func html() -> [any HTMLNode] {
        [
            desktop_menu_html(),
            mobile_menu_html(),
        ]
    }

    public func styles() -> [CSSStyleSheet] {
        [
            Self.desktop_menu_styles(),
            Self.mobile_menu_styles(),
        ]
    }
}
