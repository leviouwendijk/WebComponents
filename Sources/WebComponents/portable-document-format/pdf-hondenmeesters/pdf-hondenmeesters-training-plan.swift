import Constructors
import HTML

public extension HondenmeestersPortableDocumentFormat {
    struct TrainingPlan: ReusableComponent, Sendable {
        public struct Client: Sendable {
            public let name: String?
            public let dog: String?

            public init(
                name: String? = nil,
                dog: String? = nil
            ) {
                self.name = name
                self.dog = dog
            }
        }

        public struct Exercise: Sendable {
            public let title: String
            public let steps: [String]
            public let note: String?

            public init(
                title: String,
                steps: [String],
                note: String? = nil
            ) {
                self.title = title
                self.steps = steps
                self.note = note
            }
        }

        public let id: String
        public let label: String
        public let filename: String
        public let client: Client?
        public let title: String
        public let subtitle: String?
        public let goal: String
        public let criteria: [String]
        public let exercises: [Exercise]
        public let notes: [String]
        public let includeStyles: Bool
        public let includeScript: Bool

        public init(
            id: String,
            label: String = "Download trainingsplan",
            filename: String,
            client: Client? = nil,
            title: String = "Trainingsplan",
            subtitle: String? = nil,
            goal: String,
            criteria: [String] = [],
            exercises: [Exercise] = [],
            notes: [String] = [],
            includeStyles: Bool = true,
            includeScript: Bool = true
        ) {
            self.id = id
            self.label = label
            self.filename = filename
            self.client = client
            self.title = title
            self.subtitle = subtitle
            self.goal = goal
            self.criteria = criteria
            self.exercises = exercises
            self.notes = notes
            self.includeStyles = includeStyles
            self.includeScript = includeScript
        }

        public var nodes: ReusableComponentNodes {
            PortableDocumentFormatExport(
                id: id,
                label: label,
                filename: filename,
                payload: payload,
                includeStyles: includeStyles,
                includeScript: includeScript
            ).nodes
        }

        public func node() -> any HTMLNode {
            nodes.body[0]
        }

        private var payload: PortableDocumentFormatPayload {
            HondenmeestersPortableDocumentFormat.payload(
                template: .worksheet_a4,
                title: title,
                subtitle: resolvedSubtitle,
                blocks: blocks
            )
        }

        private var resolvedSubtitle: String? {
            if let subtitle {
                return subtitle
            }

            guard let client else {
                return nil
            }

            switch (client.name, client.dog) {
            case (.some(let name), .some(let dog)):
                return "\(name) · \(dog)"

            case (.some(let name), .none):
                return name

            case (.none, .some(let dog)):
                return dog

            case (.none, .none):
                return nil
            }
        }

        private var blocks: [PortableDocumentFormatBlock] {
            var result: [PortableDocumentFormatBlock] = [
                .heading("Doel"),
                .paragraph(goal)
            ]

            if !criteria.isEmpty {
                result.append(.heading("Criteria", level: 2))
                result.append(.checklist(criteria))
            }

            if !exercises.isEmpty {
                result.append(.heading("Oefeningen", level: 2))

                for exercise in exercises {
                    result.append(.heading(exercise.title, level: 3))

                    if !exercise.steps.isEmpty {
                        result.append(.checklist(exercise.steps))
                    }

                    if let note = exercise.note, !note.isEmpty {
                        result.append(
                            .callout(
                                title: "Let op",
                                text: note
                            )
                        )
                    }
                }
            }

            if !notes.isEmpty {
                result.append(.heading("Notities", level: 2))

                for note in notes where !note.isEmpty {
                    result.append(.paragraph(note))
                }
            }

            return result
        }
    }
}
