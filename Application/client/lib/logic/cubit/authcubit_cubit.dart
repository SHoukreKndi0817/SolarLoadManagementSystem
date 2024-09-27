import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../strings.dart';
import '../model/expert.dart';
import '../model/model.dart';
import 'firebase.dart';

part 'authcubit_state.dart';

class AuthcubitCubit extends Cubit<AuthcubitState> {
  AuthcubitCubit() : super(AuthcubitInitial());
  String clientid = '';
  String accessToken = '';
  Future loadLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    clientid = prefs.getString('clientId') ?? '';
    accessToken = prefs.getString('token') ?? '';
    print('clientid : $clientid $accessToken');
  }
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('clientId');  // حذف clientId
    await prefs.remove('token');     // حذف token
    await prefs.remove('userType');  // حذف userType إذا كنت قد استخدمته
  }


  Future<void> _saveLoginData({required String clientId, required String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('clientId', clientId);
    await prefs.setString('token', token);
  }


  Future loginClientMethod({required String username, required String password}) async {
    emitWaiting();
    final body = json.encode({
      "user_name": username,
      "password": password,
      "type": "client",
    });
    try {
      var headers = {'Content-Type': 'application/json'};
      var responce = await http.post(Uri.parse('$baseUrl/Login'),
          body: body, encoding: Encoding.getByName("utf-8"), headers: headers);

      if (responce.statusCode == 200) {
        var tt = LoginClient.fromJson(jsonDecode(responce.body));
        clientid = tt.clientDate!.clientId.toString();
        accessToken = tt.clientDate!.token.toString();
        await _saveLoginData(clientId: clientid, token: accessToken);
        emitLogedClient(tt);
      }
      else {
        var tt = LoginClient.fromJson(jsonDecode(responce.body));

        print(responce.reasonPhrase);
        print(responce.body);
        emitNoLogedClient(tt);
      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }


  Future EditProfile({
    required String name,
    required String username,
    required String address,
    required String phone,
  }) async {
    emitWaiting();
    final body = json.encode({
      "phone_number": phone,
      "name": name,
      "home_address": address,
      "user_name": username,
      "client_id": "$clientid",


    });
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      var responce = await http.post(Uri.parse('$baseUrl/ClientDataUpdate'),
          body: body, encoding: Encoding.getByName("utf-8"), headers: headers);
print(responce.body);
print(responce.statusCode);
      if (responce.statusCode == 200) {
        emitEditProfile();

      } else {
        print(responce.reasonPhrase);
        print(responce.body);
        print('Edit Profile');
      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }

  Future fetchMyHomedevice({required String solar_sys_info_id}) async {
    emitWaiting();
    final body = json.encode({
      "client_id": clientid,
      "solar_sys_info_id" :solar_sys_info_id,
    });
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      var responce = await http.post(Uri.parse('$baseUrl/GetHomeDevicesAddedByClient'),
          body: body, encoding: Encoding.getByName("utf-8"), headers: headers);

      if (responce.statusCode == 200) {
        final data = jsonDecode(responce.body);
        print(data);

        final device = (data['Home Devices'] as List)
            .map((device) => HomeDevices.fromJson(device))
            .toList();
        print(device);

        emitGetMyHomeDevice(device);
      } else {
        var tt = HomeDevice.fromJson(jsonDecode(responce.body));
        print(responce.reasonPhrase);
        print(responce.body);
        emitNoGetMyHomeDevice(tt);
      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }
  Future AddHomeDevice({
    required String name,
    required String socket_id,
    required String device_type,
    required String device_operation_type,
    required String operation_max_watt,
    required String priority,
  }) async {
    emitWaiting();
    final body = json.encode({
      "client_id": clientid,
      "socket_id": socket_id,
      "device_name": name,
      "device_type": device_type,
      "device_operation_type": device_operation_type,
      "operation_max_watt": operation_max_watt,
      "priority": priority,
    });
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      var responce = await http.post(Uri.parse('$baseUrl/AddHomeDeviceData'),
          body: body, encoding: Encoding.getByName("utf-8"), headers: headers);

      if (responce.statusCode == 201) {
        var tt = Login.fromJson(jsonDecode(responce.body));
        print(responce.reasonPhrase);
        print(responce.body);
        print('AddHome');
        print('AddHomeDevice');
        emitAddSolarSystemInfo(tt);
      } else {
        var tt = Login.fromJson(jsonDecode(responce.body));
        print(responce.reasonPhrase);
        print(responce.body);
        print('No Add AddHomeDevice');
        emitNoAddSolarSystemInfo(tt);

      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }

  Future fetchSolar() async {
    emitWaiting();
    print("token: $accessToken");
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = json.encode({
        "client_id":clientid ,
      });
      var responce = await http.post(
          Uri.parse('$baseUrl/ShowAllSolarSystemAssociated'),
          headers: headers,
          body: body,
          encoding: Encoding.getByName("utf-8"));

      if (responce.statusCode == 200) {
        final data = jsonDecode(responce.body);
        print(data);
        print('/////////////////////////////////////////////');

        final solar = AllSolarSystem.fromJson(jsonDecode(responce.body));
        print(solar.msg.toString());
        emitFetchSolarSystem(solar);
      }else if (responce.statusCode == 404) {
        final data = jsonDecode(responce.body);
        print(data);
        print('/////////////////////////////////////////////');

        final solar = AllSolarSystem.fromJson(jsonDecode(responce.body));
        print(solar.msg.toString());
        emitNoFetchSolarSystem(solar);
      } else {
        print('No0000000');
        print(responce.body);
        print(responce.statusCode);
        emitFailed();
      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }
  Future fetchSocket({
    required String id,
  }) async {
    emitWaiting();
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = json.encode({
        "solar_sys_info_id":id ,
        "client_id":clientid
      });
      var responce = await http.post(
          Uri.parse('$baseUrl/AllSocket'),
          headers: headers,
          body: body,
          encoding: Encoding.getByName("utf-8"));

      if (responce.statusCode == 200) {
        final data = jsonDecode(responce.body);
        print(data);
        print('/////////////////////////////////////////////');

        final socket = AllSocket.fromJson(jsonDecode(responce.body));
        print(socket.msg.toString());
        emitFetchSocket(socket);
      } else {
        print('No Equipment');
        print(responce.body);
      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }

  Future fetchSolarInfo({
    required String id,
  }) async {
    emitWaiting();
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = json.encode({
        "solar_sys_info_id":id ,
      });
      var responce = await http.post(
          Uri.parse('$baseUrl/ShowSolarSystemInfo'),
          headers: headers,
          body: body,
          encoding: Encoding.getByName("utf-8"));

      if (responce.statusCode == 200) {
        final data = jsonDecode(responce.body);
        print(data);
        print('/////////////////////////////////////////////');

        final solar = SolarSystemInfo.fromJson(jsonDecode(responce.body));
        print(solar.msg.toString());
        emitFetchSolarSystemInfo(solar);
      }else if (responce.statusCode == 404) {
        final data = jsonDecode(responce.body);
        print(data);
        print('/////////////////////////////////////////////');

        final solar = SolarSystemInfo.fromJson(jsonDecode(responce.body));
        print(solar.msg.toString());
        emitNoFetchSolarSystemInfo(solar);
      } else {
        print('No0000000');
        print(responce.body);
        print(responce.statusCode);
        emitFailed();
      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }
  Future changState({
    required String solar_sys_info_id,
    required String home_device_id,
    required bool isOn,
  }) async {
    emitWaiting();
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      String operation = isOn ? 'on' : 'off';
      final body = json.encode({
        "solar_sys_info_id":solar_sys_info_id ,
        "home_device_id":home_device_id ,
        "operation":operation ,
      });
      var responce = await http.post(
          Uri.parse('http://volta.sy/api/SLMT/CheckPowerToSendAction'),
          headers: headers,
          body: body,
          encoding: Encoding.getByName("utf-8"));

      print(solar_sys_info_id + home_device_id + operation);
      print(responce.body);

      if (responce.statusCode == 200) {
        final data = jsonDecode(responce.body);
        print(data);
        print('/////////////////////////////////////////////');

        final solar = Msg.fromJson(jsonDecode(responce.body));
        print(solar.msg.toString());
        emitCheckPowerToSendAction(solar);
      }else if (responce.statusCode == 404) {
        final data = jsonDecode(responce.body);
        print(data);
        print('/////////////////////////////////////////////');

        final solar = Msg.fromJson(jsonDecode(responce.body));
        print(solar.msg.toString());
        emitNoCheckPowerToSendAction(solar);
      } else {
        print('No0000000');
        print(responce.body);
        print(responce.statusCode);
        emitFailed();
      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }
  Future GetProfile() async {
    emitWaiting();
    print(clientid);
    print(accessToken);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final body = json.encode({
      "client_id": "$clientid",
    });
    var responce = await http.post(
        Uri.parse('$baseUrl/ShowClientData'),
        headers: headers,
        body: body,
        encoding: Encoding.getByName("utf-8"));
    print(responce.statusCode);
    print(responce.body);

    if (responce.statusCode == 200) {
      var tt = ClientProfile.fromJson(jsonDecode(responce.body));
      print('1232');
      print(responce.body);
      emitProfile(tt);
    } else {
      throw Exception('Failed to load trips');
    }
  }
  Future GetBroadcastData({ required String solar_sys_info_id}) async {
    emitWaiting();
    print(clientid);
    print("token: $accessToken");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final body = json.encode({
      "solar_sys_info_id": "$solar_sys_info_id",
    });
    var responce = await http.post(
        Uri.parse('http://volta.sy/api/SLMT/getBroadcastDataForClient'),
        headers: headers,
        body: body,
        encoding: Encoding.getByName("utf-8"));
    print(responce.statusCode);
    print(responce.body);

    if (responce.statusCode == 200) {
      var tt = AllBroadcastData.fromJson(jsonDecode(responce.body));
      print('1232');
      print(responce.body);
      emitBroadcastData(tt);
    } else {
      throw Exception('Failed to load trips');
    }
  }



  void emitWaiting() => emit(AuthcubitWaiting());
  void emitFailed() => emit(AuthcubitFailed());

  ///Login
  void emitLoged(Login authResponse) => emit(AuthcubitLoged(authResponse));
  void emitNoLoged(Login authResponse) => emit(AuthcubitNoLoged(authResponse));
  void emitLogedClient(LoginClient authResponse) => emit(AuthcubitLogedClient(authResponse));
  void emitNoLogedClient(LoginClient authResponse) => emit(AuthcubitNoLogedClient(authResponse));

  ///get My Clients
  void emitGetMyHomeDevice(List<HomeDevices> device) =>
      emit(AuthGetMyHomeDevice(device));
  void emitNoGetMyHomeDevice(HomeDevice device) =>
      emit(AuthNoGetMyHomeDevice(device));

  ///AddClientAccount
  void emitClientCreatedSuccessfully(MyClients clients) =>
      emit(AuthClientCreatedSuccessfully(clients));
  void emitClientNotCreatedSuccessfully(MyClients clients) =>
      emit(AuthClientNotCreatedSuccessfully(clients));

  ///Client Profile
  void emitProfile(ClientProfile expert) => emit(AuthcubitProfile(expert));
  ///
  void emitBroadcastData(AllBroadcastData broadcastData) => emit(AuthcubitBroadcastData(broadcastData));
  ///Dashboard
  void emitDashboard(Dashboard dashboard) => emit(AuthcubitDashboard(dashboard));

  ///
  void emitFetchSocket(AllSocket socket) => emit(AuthcubitSocket(socket));
  ///
  void emitFetchSolarSystem(AllSolarSystem solarSystem) => emit(AuthcubitSolarSystem(solarSystem));
  void emitNoFetchSolarSystem(AllSolarSystem solarSystem) => emit(AuthcubitNoSolarSystem(solarSystem));
  void emitCheckPowerToSendAction(Msg solarSystem) => emit(AuthcubitCheckPowerToSendAction(solarSystem));
  void emitNoCheckPowerToSendAction(Msg solarSystem) => emit(AuthcubitNoCheckPowerToSendAction(solarSystem));
  void emitFetchSolarSystemInfo(SolarSystemInfo solarSystemInfo) => emit(AuthcubitSolarSystemInfo(solarSystemInfo));
  void emitNoFetchSolarSystemInfo(SolarSystemInfo solarSystemInfo) => emit(AuthcubitNoSolarSystemInfo(solarSystemInfo));


  ///SendEquipment

  void emitSendEquipment(Login authResponse) => emit(AuthcubitSendEquipment(authResponse));
  void emitNoSendEquipment(Login authResponse) => emit(AuthcubitNoSendEquipment(authResponse));
  ///EditEquipmentRequest
  void emitEditEquipmentRequest(Login authResponse) => emit(AuthcubitEditEquipmentRequest(authResponse));
  void emitNoEditEquipmentRequest(Login authResponse) => emit(AuthcubitNoEditEquipmentRequest(authResponse));
  ///Edit Profile
  void emitEditProfile() => emit(AuthcubitEditProfile());

  ///AddSolarSystemInfo
  void emitAddSolarSystemInfo(Login authResponse) => emit(AuthcubitAddSolarSystemInfo(authResponse));
  void emitNoAddSolarSystemInfo(Login authResponse) => emit(AuthcubitNoAddSolarSystemInfo(authResponse));
  ///UpdateSolarSystemInfo
  void emitUpdateSolarSystemInfo(Login authResponse) => emit(AuthcubitUpdateSolarSystemInfo(authResponse));
  void emitNoUpdateSolarSystemInfo(Login authResponse) => emit(AuthcubitNoUpdateSolarSystemInfo(authResponse));

  ///All Equipment Request your Send
  void emitEquipmentLoaded(List<AllEquipmentRequestYourSend> equipment) =>
      emit(EquipmentLoaded(equipment));
}
