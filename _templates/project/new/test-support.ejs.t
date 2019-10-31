---
to: Tests/<%=h.inflection.camelize(locals.name.replace(/-/g, '_'), false)%>Tests/TestSupport.swift
unless_exists: true
---
import Foundation
import XCTest
import NIO
import Vapor
import SwiftAWS

extension EventLoopFuture {
    
    func check(_ timeoutDescription: String, _ duration: TimeInterval,  _ f: (T) -> Void) {
        do {
            var isCancelled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                if !isCancelled {
                    XCTFail("timeout: \(timeoutDescription)")
                }
            }
           let val = try wait()
            isCancelled = true
            f(val)
        }
        catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
}

extension AWSApp {
    
    static var testRouter: Router {
        return EngineRouter.default()
    }
    
}



extension Router {
    
    
    func testRequest(group: EventLoopGroup, httpRequest: HTTPRequest) -> EventLoopFuture<Response> {
        do {
            let application = try Application()
            let request = Request(
                http: httpRequest,
                using: application
            )
            guard let responder = route(request: request) else {
                let rs: EventLoopFuture<Response> = group.future(
                    Response(http:
                        .init(
                            status: .notFound,
                            version: .init(major: 1, minor: 1),
                            headers:
                            .init(),
                            body: ""
                        ),
                        using: application
                    )
                )
                return rs
            }
            let rs = try responder.respond(to: request)
            rs.whenComplete {
                application.shutdownGracefully { _ in }
            }
            return rs
        }
        catch let error {
            return  group.future(error: error)
        }
    }
}

