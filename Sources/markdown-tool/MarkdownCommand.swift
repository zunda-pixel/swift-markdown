/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
 See https://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import ArgumentParser
import Foundation
import Markdown

@main
struct MarkdownCommand: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "markdown", shouldDisplay: false, subcommands: [
        DumpTree.self,
        Format.self,
    ])

    static func parseFile(at path: String, options: ParseOptions) throws -> (source: String, parsed: Document) {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        guard let inputString = String(data: data, encoding: .utf8) else {
            throw Error.couldntDecodeInputAsUTF8
        }
        return (inputString, Document(parsing: inputString, options: options))
    }

    static func parseStandardInput(options: ParseOptions) throws -> (source: String, parsed: Document) {
        let stdinData: Data
        if #available(macOS 10.15.4, *) {
            stdinData = try FileHandle.standardInput.readToEnd() ?? Data()
        } else {
            stdinData = FileHandle.standardInput.readDataToEndOfFile()
        }
        guard let stdinString = String(data: stdinData, encoding: .utf8) else {
            throw Error.couldntDecodeInputAsUTF8
        }
        return (stdinString, Document(parsing: stdinString, options: options))
    }
}
