import Constructors

public struct DocsArticlePlan: Sendable {
    public let sections: [DocsPlannedSection]
    public let paragraphCount: Int

    public init(
        sections: [DocsPlannedSection],
        paragraphCount: Int
    ) {
        self.sections = sections
        self.paragraphCount = paragraphCount
    }

    public var parts: [DocsPlannedPart] {
        sections.flatMap(\.parts)
    }

    public var navigation: NavigationStructure {
        NavigationStructure(
            roots: sections.compactMap(\.navigationNode)
        )
    }
}

public struct DocsPlannedSection: Sendable {
    public let source: DocsArticleSection
    public let index: Int
    public let parts: [DocsPlannedPart]

    public var navigationNode: NavigationNode? {
        switch source.nav {
        case .hidden:
            return nil

        case .item:
            return NavigationNode(
                label: source.title,
                path: parts.first?.source.href,
                children: []
            )

        case .group:
            return NavigationNode(
                label: source.title,
                children: parts.compactMap(\.navigationNode)
            )
        }
    }
}

public struct DocsPlannedPart: Sendable {
    public let source: DocsArticlePart
    public let sectionIndex: Int
    public let index: Int
    public let blocks: [DocsPlannedBlock]

    public var navigationNode: NavigationNode? {
        NavigationNode(
            label: source.title,
            path: source.href
        )
    }
}

public struct DocsPlannedBlock: Sendable {
    public let source: DocsReadableBlock
    public let sectionIndex: Int
    public let partIndex: Int
    public let blockIndex: Int
    public let paragraph: DocsParagraphMeta?

    public init(
        source: DocsReadableBlock,
        sectionIndex: Int,
        partIndex: Int,
        blockIndex: Int,
        paragraph: DocsParagraphMeta?
    ) {
        self.source = source
        self.sectionIndex = sectionIndex
        self.partIndex = partIndex
        self.blockIndex = blockIndex
        self.paragraph = paragraph
    }
}

public struct DocsParagraphMeta: Sendable {
    public let index: Int
    public let indexInPart: Int
    public let isFirstInArticle: Bool
    public let isFirstInPart: Bool
    public let followsParagraph: Bool

    public init(
        index: Int,
        indexInPart: Int,
        isFirstInArticle: Bool,
        isFirstInPart: Bool,
        followsParagraph: Bool
    ) {
        self.index = index
        self.indexInPart = indexInPart
        self.isFirstInArticle = isFirstInArticle
        self.isFirstInPart = isFirstInPart
        self.followsParagraph = followsParagraph
    }
}

public enum DocsArticlePlanner {
    public static func plan(
        _ article: DocsArticle
    ) -> DocsArticlePlan {
        var paragraphIndex = 0
        var plannedSections: [DocsPlannedSection] = []

        for sectionIndex in article.sections.indices {
            let section = article.sections[sectionIndex]
            var plannedParts: [DocsPlannedPart] = []

            for partIndex in section.parts.indices {
                let part = section.parts[partIndex]
                var plannedBlocks: [DocsPlannedBlock] = []
                var paragraphIndexInPart = 0

                for blockIndex in part.body.blocks.indices {
                    let block = part.body.blocks[blockIndex]
                    let previousBlock = blockIndex > part.body.blocks.startIndex
                        ? part.body.blocks[part.body.blocks.index(before: blockIndex)]
                        : nil

                    let paragraph: DocsParagraphMeta?

                    if block.isParagraph {
                        paragraphIndex += 1
                        paragraphIndexInPart += 1

                        paragraph = DocsParagraphMeta(
                            index: paragraphIndex,
                            indexInPart: paragraphIndexInPart,
                            isFirstInArticle: paragraphIndex == 1,
                            isFirstInPart: paragraphIndexInPart == 1,
                            followsParagraph: previousBlock?.isParagraph == true
                        )
                    } else {
                        paragraph = nil
                    }

                    plannedBlocks.append(
                        DocsPlannedBlock(
                            source: block,
                            sectionIndex: sectionIndex,
                            partIndex: partIndex,
                            blockIndex: blockIndex,
                            paragraph: paragraph
                        )
                    )
                }

                plannedParts.append(
                    DocsPlannedPart(
                        source: part,
                        sectionIndex: sectionIndex,
                        index: partIndex,
                        blocks: plannedBlocks
                    )
                )
            }

            plannedSections.append(
                DocsPlannedSection(
                    source: section,
                    index: sectionIndex,
                    parts: plannedParts
                )
            )
        }

        return DocsArticlePlan(
            sections: plannedSections,
            paragraphCount: paragraphIndex
        )
    }
}

private extension DocsReadableBlock {
    var isParagraph: Bool {
        if case .paragraph = self {
            return true
        }

        return false
    }
}
