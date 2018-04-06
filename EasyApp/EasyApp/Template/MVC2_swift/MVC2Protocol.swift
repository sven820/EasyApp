//
//  MVC2Protocol.swift
//  EasyApp
//
//  Created by 靳小飞 on 2018/3/17.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

import Foundation

@objc protocol Context: NSObjectProtocol{
    
}

@objc protocol Binder: NSObjectProtocol{
    
    static func binderWithModule(module: String) -> Binder
    func unBind()
    
    var module: String {get set}
    var branches: NSMapTable<AnyObject, AnyObject> {get set}
    
    weak var superBinder: Binder? {get set}
    var subBinders: [Binder] {get set}
    
    func addSubBinder(binder: Binder)
    func removeFromSuperBinder()
    
    func bind(branch:Branch, ptl: Protocol)
    func bind(branch:Branch, ptl: Protocol, identity: String)
    func unbind(ptl: Protocol)
    func unbind(ptl: Protocol, identity: String)
    func branch(ptl:Protocol) -> Branch
    func branch(ptl:Protocol, identity: String) -> Branch
    
    @objc optional var contexts: NSMutableDictionary {get set}
    @objc optional func addCtx(context: Context)
    @objc optional func addCtx(context: Context, identity: String)
    @objc optional func removeCtx(cls: Context)
    @objc optional func removeCtx(cls: Context, identity: String)
}
@objc protocol BranchRequest: NSObjectProtocol {
    
}
@objc protocol Branch: NSObjectProtocol {
    
}

// MARK: - 测试
// TODO:ffff
// MARK:zzz

//class Binder: <#super class#> {
//    <#code#>
//}


