import Primitives

public enum DocsVisibility {
    public static let live: Set<BuildEnvironment> = Set(BuildEnvironment.allCases)
    public static let localAndTest: Set<BuildEnvironment> = [.local, .test]
    public static let localOnly: Set<BuildEnvironment> = [.local]
    public static let hidden: Set<BuildEnvironment> = []
}
