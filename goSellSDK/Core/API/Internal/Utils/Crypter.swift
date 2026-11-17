//
//  Crypter.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import Security

/// Crypter helper class.
///
/// Encrypts with RSA PKCS#1 v1.5 using Apple's Security framework. It produces the same
/// format SwiftyRSA did: the input is split into chunks of (key block size - 11) bytes,
/// each chunk is encrypted separately, and the encrypted blocks are concatenated and
/// base64-encoded.
internal class Crypter {

    // MARK: - Internal -
    // MARK: Methods

    /// Encrypts the given string using the given key.
    ///
    /// - Parameters:
    ///   - string: String to encrypt.
    ///   - key: Key to encrypt with: an RSA public key, PEM-encoded or bare base64, in X.509 (SubjectPublicKeyInfo) or PKCS#1 form.
    /// - Returns: String if the encryption succeed.
    internal static func encrypt(_ string: String, using key: String) -> String? {

        guard let publicKey = self.publicKey(fromPEM: key) else { return nil }
        guard let clearData = string.data(using: .utf8) else { return nil }

        var resultString = ""

        while true {

            guard let encryptedData = self.encrypt(clearData, with: publicKey) else { return nil }
            resultString = encryptedData.base64EncodedString()

            if !resultString.hasSuffix("AA==") {

                break
            }
        }

        return resultString
    }

    // MARK: - Private -

    private struct Constants {

        /// PKCS#1 v1.5 padding takes 11 bytes of every block.
        fileprivate static let pkcs1PaddingLength = 11

        fileprivate static let sequenceTag: UInt8       = 0x30
        fileprivate static let integerTag: UInt8        = 0x02
        fileprivate static let bitStringTag: UInt8      = 0x03
        fileprivate static let octetStringTag: UInt8    = 0x04
    }

    // MARK: Methods

    private static func encrypt(_ data: Data, with key: SecKey) -> Data? {

        let blockSize = SecKeyGetBlockSize(key)
        let maxChunkSize = blockSize - Constants.pkcs1PaddingLength
        guard maxChunkSize > 0 else { return nil }

        var result = Data()
        var index = 0

        while index < data.count {

            let chunk = data.subdata(in: index..<min(index + maxChunkSize, data.count))

            var error: Unmanaged<CFError>?
            guard let encryptedChunk = SecKeyCreateEncryptedData(key, .rsaEncryptionPKCS1, chunk as CFData, &error) as Data? else {

                return nil
            }

            result.append(encryptedChunk)
            index += maxChunkSize
        }

        return result
    }

    private static func publicKey(fromPEM pemString: String) -> SecKey? {

        // Drop the "-----BEGIN ...-----" / "-----END ...-----" lines (if any) and join the rest.
        let base64String = pemString
            .components(separatedBy: "\n")
            .filter { !$0.hasPrefix("-----BEGIN") && !$0.hasPrefix("-----END") }
            .joined()

        guard let keyData = Data(base64Encoded: base64String, options: [.ignoreUnknownCharacters]) else { return nil }
        guard let pkcs1KeyData = self.pkcs1PublicKeyData(from: keyData) else { return nil }

        let attributes: [CFString: Any] = [

            kSecAttrKeyType:        kSecAttrKeyTypeRSA,
            kSecAttrKeyClass:       kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits:  NSNumber(value: pkcs1KeyData.count * 8)
        ]

        var error: Unmanaged<CFError>?
        return SecKeyCreateWithData(pkcs1KeyData as CFData, attributes as CFDictionary, &error)
    }

    /// Returns the PKCS#1 `RSAPublicKey` that `SecKeyCreateWithData` expects.
    ///
    /// A PKCS#1 key is a DER sequence of two integers (modulus and exponent) and is returned
    /// unchanged. An X.509 `SubjectPublicKeyInfo` key wraps it: a sequence whose last element
    /// is a bit string holding the PKCS#1 key, which is returned without the wrapper.
    private static func pkcs1PublicKeyData(from keyData: Data) -> Data? {

        let bytes = [UInt8](keyData)

        guard let root = self.readElement(in: bytes, at: 0), root.tag == Constants.sequenceTag else { return nil }

        var children: [DERElement] = []
        var offset = root.contentRange.lowerBound

        while offset < root.contentRange.upperBound {

            guard let child = self.readElement(in: bytes, at: offset), child.end <= root.contentRange.upperBound else { return nil }
            children.append(child)
            offset = child.end
        }

        guard let last = children.last else { return nil }

        if children.allSatisfy({ $0.tag == Constants.integerTag }) {

            return keyData
        }

        switch last.tag {

        case Constants.bitStringTag:

            // The first content byte of a bit string is the number of unused bits (0 here).
            guard last.contentRange.count > 1 else { return nil }
            return Data(bytes[(last.contentRange.lowerBound + 1)..<last.contentRange.upperBound])

        case Constants.octetStringTag:

            return Data(bytes[last.contentRange])

        default:

            return nil
        }
    }

    /// Reads one DER tag-length-value element starting at `offset`.
    private static func readElement(in bytes: [UInt8], at offset: Int) -> DERElement? {

        guard offset + 1 < bytes.count else { return nil }

        let tag = bytes[offset]
        var position = offset + 1

        let firstLengthByte = bytes[position]
        position += 1

        var length = 0

        if firstLengthByte < 0x80 {

            // Short form: the byte is the length.
            length = Int(firstLengthByte)
        }
        else {

            // Long form: the low 7 bits say how many following bytes hold the length.
            let lengthByteCount = Int(firstLengthByte & 0x7F)
            guard lengthByteCount > 0, lengthByteCount <= 4, position + lengthByteCount <= bytes.count else { return nil }

            for byte in bytes[position..<(position + lengthByteCount)] {

                length = (length << 8) | Int(byte)
            }

            position += lengthByteCount
        }

        guard position + length <= bytes.count else { return nil }

        return DERElement(tag: tag, contentRange: position..<(position + length))
    }
}

/// One DER element: its tag and where its content sits in the parsed bytes.
private struct DERElement {

    fileprivate let tag: UInt8
    fileprivate let contentRange: Range<Int>

    fileprivate var end: Int {

        return self.contentRange.upperBound
    }
}
