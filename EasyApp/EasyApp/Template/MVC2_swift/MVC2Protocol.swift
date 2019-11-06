//
//  MVC2Protocol.swift
//  EasyApp
//
//  Created by 靳小飞 on 2018/3/17.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

import Foundation
import UIKit

typealias BranchRequestedHandler = (_ branch: Branch, _ requestModel: BranchRequest)->Void

@objc protocol Context: NSObjectProtocol{
    
}

@objc protocol Binder: NSObjectProtocol{
    
    static func binderWithModule(module: String) -> Binder
    static func unBinderWithModule(module: String);
    func unBind()
    
    var module: String {get set}
    var branches: NSMapTable<AnyObject, Branch> {get set}
    
    weak var superBinder: Binder? {get set}
    var subBinders: [Binder] {get set}
    
    func addSubBinder(binder: Binder)
    func removeSubBinders()
    func removeFromSuperBinder()
    
    func bind(branch:Branch, ptl: Protocol)
    func bind(branch:Branch, ptl: Protocol, identity: String?)
    func unbind(ptl: Protocol)
    func unbind(ptl: Protocol, identity: String?)
    func branch(ptl:Protocol) -> Branch?
    func branch(ptl:Protocol, identity: String?) -> Branch?
    
    var  contexts: [String: Context] {get set}
    func addCtx(context: Context)
    func addCtx(context: Context, identity: String?)
    func removeCtx(cls: AnyClass)
    func removeCtx(cls: AnyClass, identity: String?)
    func ctx(_ cls: AnyClass) -> Context?
    func ctx(_ cls: AnyClass, identity: String?) -> Context?
}
@objc protocol BranchRequest: NSObjectProtocol {
    var module: String {set get}
    var branch: String {set get}
    var action: Selector? {set get}
    var target: AnyObject? {set get}
    var info: AnyObject? {set get}
}
@objc protocol Branch: NSObjectProtocol {
    weak var binder: Binder? {set get}
    func bind(binder: Binder)
    func request(request: BranchRequest, handler: BranchRequestedHandler)
    func dealWithRequestInfo(info: BranchRequest, handler: BranchRequestedHandler)
}
extension Branch {
    //branch
    func Bind(_ branch: Branch, p: Protocol) {
        self.binder?.bind(branch: branch, ptl: p)
    }
    func Unbind(_ p: Protocol) {
        self.binder?.unbind(ptl: p)
    }
    func Branch(_ p: Protocol) -> Branch?{
        return self.binder?.branch(ptl: p)
    }
    func BindWithIdentify(_ branch: Branch, p: Protocol, identity: String) {
        self.binder?.bind(branch: branch, ptl: p, identity:identity)
    }
    func UnbindWithIdentify(_ p: Protocol, identity: String) {
        self.binder?.unbind(ptl: p, identity:identity)
    }
    func BranchWithIdentify(_ p: Protocol, identity: String) -> Branch?{
        return self.binder?.branch(ptl: p, identity:identity)
    }
    //ctx
    func addCtx(_ ctx: Context) {
        self.binder?.addCtx(context: ctx)
    }
    func removeCtx(_ cls: AnyClass) {
        self.binder?.removeCtx(cls: cls)
    }
    func ctx(_ cls: AnyClass) -> Context? {
        return self.binder?.ctx(cls)
    }
    func addCtx(_ ctx: Context, identity: String) {
        self.binder?.addCtx(context: ctx, identity:identity)
    }
    func removeCtx(_ cls: AnyClass, identity: String) {
        self.binder?.removeCtx(cls: cls, identity:identity)
    }
    func ctx(_ cls: AnyClass, identity: String) -> Context? {
        return self.binder?.ctx(cls, identity:identity)
    }
}

// MARK: 协议簇
@objc protocol Presenter: Branch {
    weak var bindingView: UIView? {set get}
    func doAddSubView()
    func makeViewConstraints()
}
@objc protocol Interactor: Branch {
    func actionForView(view: UIView)
    func gestureRecongnizerForView(view: UIGestureRecognizer)
}
@objc protocol VModel: Branch {
    
}
@objc protocol Router: Branch {
    
}
// MARK: 组合协议
//mvc
@objc protocol MVC: Presenter, Interactor, VModel, Router {
    
}
//mvvm
@objc protocol MVVM_Interactor: Interactor, Router {
    
}
@objc protocol MVVM_VM: Presenter, VModel {
    
}
//viper
@objc protocol VIPER_Interactor: Interactor {
    
}
@objc protocol VIPER_ViewModel: Presenter {
    
}
@objc protocol VIPER_Vm: VModel {
    
}
@objc protocol VIPER_Router: Router {
    
}
