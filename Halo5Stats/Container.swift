//
//  Copyright © 2016 Kevin Tatroe. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information

import Foundation


/// Todo: Assemblers and Assemblies to handle switching out a set of services at once?

/**
 `Container` is a basic dependency-injection handler for services, such as
 service bridges, request services, persistent store managers, etc. Dependency-injection
 handlers can get really gnarly really quickly, so this is by design a minimal
 implementation.

 To register, simply call register class and name to register. In the following example,
 we register two instances of classes confirming to the ParkServiceBridge protocol, and
 register a default implementation:

 let container = Container()
 container.register(ParkServiceBridge.self, "WebServices") { WebServicesParkServiceBridge() }
 container.register(ParkServiceBridge.self, "CloudKit") { CloudKitParkServiceBridge() }
 container.register(ParkServiceBridge.self) { container.resolve(ParkServiceBridge.self, "WebServices") } }

 To fetch a service, call resolve:

 if let bridge = container.resolve(ParkServiceBridge.self) { }

 A shared container is also provided, for use in the general case of globaly-available
 injectable services:

 Container.register(ParkServiceBridge.self) { WebServicesParkServiceBridge() }

 ...

 if let bridge = Container.resolve(ParkServiceBridge.self) { }
 */
open class Container {
    static internal var sharedContainer = Container()

    fileprivate var services = [ContainerItemKey: ContainerItemType]()

    open func register<T>(_ serviceType: T.Type, name: String? = nil, factory: (Resolvable) -> T) -> ContainerEntry<T> {
        return registerFactory(serviceType, factory: factory, name: name)
    }

    internal func registerFactory<T, Factory>(_ serviceType: T.Type, factory: Factory, name: String?) -> ContainerEntry<T> {
        let key = ContainerItemKey(factoryType: type(of: factory), name: name)
        let entry = ContainerEntry(serviceType: serviceType, factory: factory)

        services[key] = entry

        return entry
    }

    @discardableResult static open func register<T>(_ serviceType: T.Type, name: String? = nil, factory: (Resolvable) -> T) -> ContainerEntry<T> {
        return sharedContainer.register(serviceType, name: name, factory: factory)
    }
}


extension Container : Resolvable {
    public func resolve<T>(_ serviceType: T.Type, name: String? = nil) -> T? {
        typealias FactoryType = (Resolvable) -> T

        return resolveFactory(name) { (factory: FactoryType) in factory(self) }
    }

    static public func resolve<T>(_ serviceType: T.Type, name: String? = nil) -> T? {
        return sharedContainer.resolve(serviceType, name: name)
    }

    internal func resolveFactory<T, Factory>(_ name: String?, invoker: (Factory) -> T) -> T? {
        let key = ContainerItemKey(factoryType: Factory.self, name: name)

        if let entry = services[key] as? ContainerEntry<T> {
            if entry.instance == nil {
                entry.instance = resolveEntry(entry, key: key, invoker: invoker) as Any
            }

            return entry.instance as? T
        }

        return nil
    }

    fileprivate func resolveEntry<T, Factory>(_ entry: ContainerEntry<T>, key: ContainerItemKey, invoker: (Factory) -> T) -> T {
        let resolvedInstance = invoker(entry.factory as! Factory)

        return resolvedInstance
    }
}


public typealias FunctionType = Any

public protocol Resolvable {
    func resolve<T>(_ serviceType: T.Type, name: String?) -> T?
}


internal struct ContainerItemKey {
    fileprivate let factoryType: FunctionType.Type
    fileprivate let name: String?

    internal init(factoryType: FunctionType.Type, name: String? = nil) {
        self.factoryType = factoryType
        self.name = name
    }
}


extension ContainerItemKey : Hashable {
    var hashValue: Int {
        return String(describing: factoryType).hashValue ^ (name?.hashValue ?? 0)
    }
}

func == (lhs: ContainerItemKey, rhs: ContainerItemKey) -> Bool {
    return (lhs.factoryType == rhs.factoryType) && (lhs.name == rhs.name)
}


internal typealias ContainerItemType = Any

open class ContainerEntry<T> : ContainerItemType {
    fileprivate let serviceType: T.Type
    let factory: FunctionType

    var instance: Any? = nil

    init(serviceType: T.Type, factory: FunctionType) {
        self.serviceType = serviceType
        self.factory = factory
    }
}
