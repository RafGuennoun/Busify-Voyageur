import 'package:busify_voyageur/models/Account_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../Utils/constants.dart';

class AccountController {

  final String api = Constants().getAPI();

  Future<Account> getAccount(Map<String, dynamic> json) async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      "${api}account/webId", 
      data: json
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> res = response.data as Map<String, dynamic>;

      Map<String, dynamic> acc;
      if (res["error"] == "1") {
        acc = {
          "username" : "null",
          "password" : "null",
          "webId" : "null",
        }; 
      }
      else{
        acc = {
          "username" : res['username'],
          "password" : res['password'],
          "webId" : res['webId'],
        }; 
      }
      
      Account account = Account.fromJson(acc);
      return account;

    } else {
      debugPrint(response.statusCode.toString());
      throw Exception('Failed to login.');
    }

  }
} 