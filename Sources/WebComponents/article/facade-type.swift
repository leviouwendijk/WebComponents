import Path

public struct Facade: FacadeRendering {
    public let title: String 
    public let definition: String 
    public let thumbnail_src: StandardPath? 

    // -------------------------------------
    // --------   **Classical conditioning**
    // |      |   
    // |      |   Classical conditioning is ..
    // |      |   this that and the other..
    // --------
    // -------------------------------------

    public init(
        title: String,
        definition: String,
        thumbnail_src: StandardPath? = nil,
    ) {
        self.title = title
        self.definition = definition
        self.thumbnail_src = thumbnail_src
    }
}
