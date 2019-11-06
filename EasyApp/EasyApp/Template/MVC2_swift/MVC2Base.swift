//
//  MVC2Base.swift
//  EasyApp
//
//  Created by 靳小飞 on 2018/5/2.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

import Foundation

private class ModulesManager: NSObject {
    var binderMap: [String: Binder] = [String: Binder]()
    static let shareManager = ModulesManager()
}

class BinderImp: NSObject, Binder{
    var module: String = String()
    var branches: NSMapTable<AnyObject, Branch> = NSMapTable<AnyObject, Branch>()
    var contexts: [String : Context] = [String : Context]()
    var superBinder: Binder?
    var subBinders: [Binder] = [Binder]()
    
    deinit {
        self.unBind()
    }
    
    override init() {
        super.init()
    }
    
    static func binderWithModule(module: String) -> Binder {
        var mod = ModulesManager.shareManager.binderMap[module]
        if mod == nil {
            mod = BinderImp()
            mod?.module = module
            ModulesManager.shareManager.binderMap[module] = mod
        }
        return mod!
    }
    
    static func unBinderWithModule(module: String) {
        let b = ModulesManager.shareManager.binderMap[module]
        b?.unBind()
    }
    
    func unBind() {
        self.branches.removeAllObjects()
        self.contexts.removeAll()
        self.removeSubBinders()
        ModulesManager.shareManager.binderMap.removeValue(forKey: self.module)
    }
    
    func addSubBinder(binder: Binder) {
        self.subBinders.append(binder)
    }
    
    func removeSubBinders() {
        for binder in self.subBinders {
            binder.removeSubBinders()
        }
        self.subBinders.removeAll()
    }
    
    func removeFromSuperBinder() {
        
        if let index = self.superBinder?.subBinders.index(where: { (binder) -> Bool in
            binder.module == self.module
        }) {
            self.superBinder?.subBinders.remove(at: index)
        }
    }
    //
    func bind(branch: Branch, ptl: Protocol) {
        self.bind(branch: branch, ptl: ptl, identity: nil)
    }
    
    func bind(branch: Branch, ptl: Protocol, identity: String?) {
        self.branches.setObject(branch, forKey: self.getBranchKey(ptl, identify: identity) as AnyObject)
    }
    
    func unbind(ptl: Protocol) {
        self.unbind(ptl: ptl, identity: nil)
    }
    
    func unbind(ptl: Protocol, identity: String?) {
        self.branches.removeObject(forKey: self.getBranchKey(ptl, identify: identity) as AnyObject)
    }
    
    func branch(ptl: Protocol) -> Branch? {
        return self.branch(ptl: ptl, identity: nil)
    }
    
    func branch(ptl: Protocol, identity: String?) -> Branch? {
        return self.branches.object(forKey: self.getBranchKey(ptl, identify: identity) as AnyObject)
    }
    //ctx
    func addCtx(context: Context) {
        self.addCtx(context: context, identity: nil)
        
    }
    
    func addCtx(context: Context, identity: String?) {
        self.contexts[self.getContextKey(type(of: context), identify: identity)] = context
    }
    
    func removeCtx(cls: AnyClass) {
        self.removeCtx(cls: cls, identity: nil)
    }
    
    func removeCtx(cls: AnyClass, identity: String?) {
        self.contexts.removeValue(forKey: self.getContextKey(cls, identify: identity))
    }
    
    func ctx(_ cls: AnyClass) -> Context? {
        return self.ctx(cls, identity: nil)
    }
    
    func ctx(_ cls: AnyClass, identity: String?) -> Context? {
        return self.contexts[self.getContextKey(cls, identify: identity)]
    }
    //private
    fileprivate func getBranchKey(_ ptl: Protocol, identify: String?) -> String {
        return String.init(format: "%@%@", NSStringFromProtocol(ptl), identify ?? "")
    }
    fileprivate func getContextKey(_ cls: AnyClass, identify: String?) -> String {
        return String.init(format: "%@%@", NSStringFromClass(cls), identify ?? "")
    }
}

class BranchRequestModel: NSObject, BranchRequest {
    var module: String = String()
    
    var branch: String = String()
    
    var action: Selector?
    
    var target: AnyObject?
    
    var info: AnyObject?
}
