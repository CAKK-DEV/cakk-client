//
//  UserData.swift
//  CAKK
//
//  Created by 이승기 on 5/11/24.
//

import Foundation

public struct UserData {
  public var nickname: String
  public var email: String
  public var birthday: Date
  public var gender: Gender
  
  public init(nickname: String, email: String, birthday: Date, gender: Gender) {
    self.nickname = nickname
    self.email = email
    self.birthday = birthday
    self.gender = gender
  }
}
