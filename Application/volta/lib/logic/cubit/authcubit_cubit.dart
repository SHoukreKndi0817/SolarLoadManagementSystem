import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../strings.dart';
import '../model/expert.dart';
import 'firebase.dart';

part 'authcubit_state.dart';

class AuthcubitCubit extends Cubit<AuthcubitState> {
  AuthcubitCubit() : super(AuthcubitInitial());
  String expertid = '';
  String accessToken = '';

  List<AllClientYourAdded> _allClients = [];

  Future loginMethod(
      {required String username, required String password}) async {
    emitWaiting();
    final body = json.encode({
      "user_name": username,
      "password": password,
      "type": "technicalexpert",
    });
    try {
      var headers = {'Content-Type': 'application/json'};
      var responce = await http.post(Uri.parse('$baseUrl/Login'),
          body: body, encoding: Encoding.getByName("utf-8"), headers: headers);

      if (responce.statusCode == 200) {
        var tt = Login.fromJson(jsonDecode(responce.body));
        expertid = tt.technicalexpertDate!.technicalExpertId.toString();
        accessToken = tt.technicalexpertDate!.token.toString();

        emitLoged(tt);
      }
      // if (responce.statusCode == 401) {
      //
      //
      // }
      // if (responce.statusCode == 422) {
      //
      // }
      // if (responce.statusCode == 403) {
      //
      // }
      else {
        var tt = Login.fromJson(jsonDecode(responce.body));

        print(responce.reasonPhrase);
        print(responce.body);
        emitNoLoged(tt);
      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }

  Future AddClient({
    required String username,
    required String password,
    required String name,
    required String address,
    required String phone,
  }) async {
    emitWaiting();
    final body = json.encode({
      "user_name": username,
      "password": password,
      "name": name,
      "phone_number": phone,
      "home_address": address,
      "technical_expert_id": "$expertid",
    });
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      var responce = await http.post(Uri.parse('$baseUrl/AddClientAccount'),
          body: body, encoding: Encoding.getByName("utf-8"), headers: headers);

      if (responce.statusCode == 200) {
        var tt = MyClients.fromJson(jsonDecode(responce.body));

        emitClientCreatedSuccessfully(tt);
      } else {
        var tt = MyClients.fromJson(jsonDecode(responce.body));

        print(responce.reasonPhrase);
        print(responce.body);
        emitClientNotCreatedSuccessfully(tt);
      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }

  Future SendEquipmentRequest({
    required String name,
    required String number_of_broadcast_device,
    required String number_of_port,
    required String number_of_socket,
    required String panel_id,
    required String number_of_panel,
    required String battery_id,
    required String number_of_battery,
    required String inverters_id,
    required String number_of_inverter,
    required String additional_equipment,
  }) async {
    emitWaiting();
    final body = json.encode({
      "name": name,
      "number_of_broadcast_device": number_of_broadcast_device,
      "number_of_port": number_of_port,
      "number_of_socket": number_of_socket,
      "panel_id": panel_id,
      "number_of_panel": number_of_panel,
      "battery_id": battery_id,
      "number_of_battery": number_of_battery,
      "inverters_id": inverters_id,
      "number_of_inverter": number_of_inverter,
      "additional_equipment": additional_equipment,
      "technical_expert_id": "$expertid",
    });
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      var responce = await http.post(Uri.parse('$baseUrl/SendEquipmentRequest'),
          body: body, encoding: Encoding.getByName("utf-8"), headers: headers);

      if (responce.statusCode == 201) {
        var tt = Login.fromJson(jsonDecode(responce.body));

        print(responce.body);
        print('Send equipment');
        emitSendEquipment(tt);

      } else {
        var tt = Login.fromJson(jsonDecode(responce.body));

        print(responce.body);
        print('No Send equipment');
        emitNoSendEquipment(tt);

      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }

  Future AddSolarSystem({
    required String name,
    required String client_id,
    required String inverters_id,
    required String number_of_battery,
    required String battery_conection_type,
    required String battery_id,
    required String number_of_panel,
    required String panel_id,
    required String number_of_panel_group,
    required String panel_conection_typeone,
    required String panel_conection_typetwo,
    required String phase_type,
    required String qr_code_data,
  }) async {
    emitWaiting();
    print(qr_code_data);
    final body = json.encode({
      "name": name,
      "client_id": client_id,
      "inverters_id": inverters_id,
      "number_of_battery": number_of_battery,
      "battery_conection_type": battery_conection_type,
      "battery_id": battery_id,
      "number_of_panel": number_of_panel,
      "panel_id": panel_id,
      "number_of_panel_group": number_of_panel_group,
      "panel_conection_typeone": panel_conection_typeone,
      "panel_conection_typetwo": panel_conection_typetwo,
      "phase_type": phase_type,
      "qr_code_data": "$qr_code_data",
      "technical_expert_id": "$expertid",
    });
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      var responce = await http.post(Uri.parse('$baseUrl/AddSolarSystemInfo'),
          body: body, encoding: Encoding.getByName("utf-8"), headers: headers);

      if (responce.statusCode == 200) {
        var tt = Login.fromJson(jsonDecode(responce.body));
        print(responce.reasonPhrase);
        print(responce.body);
        print('AddSolarSystemInfo');
        emitAddSolarSystemInfo(tt);
      } else {
        var tt = Login.fromJson(jsonDecode(responce.body));
        print(responce.reasonPhrase);
        print(responce.body);
        print('No Add SolarSystemInfo');
        emitNoAddSolarSystemInfo(tt);

      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }
  Future updateSolarSystem({
    required String name,
    required String solar_sys_info_id,
    required String inverters_id,
    required String number_of_battery,
    required String battery_id,
    required String number_of_panel,
    required String panel_id,
    required String number_of_panel_group,
    required String panel_conection_typeone,
    required String panel_conection_typetwo,
    required String battery_conection_type,
    required String phase_type,
    required String qr_code_data,
  }) async {
    emitWaiting();
    final body = json.encode({
      "solar_sys_info_id": solar_sys_info_id,
      "name": name,
      "inverters_id": inverters_id,
      "number_of_battery": number_of_battery,
      "battery_id": battery_id,
      "number_of_panel": number_of_panel,
      "panel_id": panel_id,
      "battery_conection_type": battery_conection_type,
      "number_of_panel_group": number_of_panel_group,
      "panel_conection_typeone": panel_conection_typeone,
      "panel_conection_typetwo": panel_conection_typetwo,
      "phase_type": phase_type,
      "qr_code_data": qr_code_data,
    });
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      var responce = await http.post(Uri.parse('$baseUrl/UpdateSolarSystemInfo'),
          body: body, encoding: Encoding.getByName("utf-8"), headers: headers);
      print(qr_code_data);

      if (responce.statusCode == 200) {
        var tt = Login.fromJson(jsonDecode(responce.body));

        print(responce.body);
        print('UpdateSolarSystemInfo');
        emitUpdateSolarSystemInfo(tt);


      } else {
        print(responce.reasonPhrase);
        var tt = Login.fromJson(jsonDecode(responce.body));
        emitNoUpdateSolarSystemInfo(tt);


      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }

  Future EditEquipmentRequest({
    required String name,
    required String requestEquipmentId,
    required String number_of_broadcast_device,
    required String number_of_port,
    required String number_of_socket,
    required String panel_id,
    required String number_of_panel,
    required String battery_id,
    required String number_of_battery,
    required String inverters_id,
    required String number_of_inverter,
    required String additional_equipment,
  }) async {
    emitWaiting();
    final body = json.encode({
      "request_equipment_id": requestEquipmentId,
      "name": name,
      "number_of_broadcast_device": number_of_broadcast_device,
      "number_of_port": number_of_port,
      "number_of_socket": number_of_socket,
      "panel_id": panel_id,
      "number_of_panel": number_of_panel,
      "battery_id": battery_id,
      "number_of_battery": number_of_battery,
      "inverters_id": inverters_id,
      "number_of_inverter": number_of_inverter,
      "additional_equipment": additional_equipment,
    });
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      var responce = await http.post(Uri.parse('$baseUrl/EditRequestEquipmentData'),
          body: body, encoding: Encoding.getByName("utf-8"), headers: headers);

      if (responce.statusCode == 200) {
        var tt = Login.fromJson(jsonDecode(responce.body));

        print(responce.body);
        print('Edit equipment');
        emitEditEquipmentRequest(tt);

      } else {
        var tt = Login.fromJson(jsonDecode(responce.body));
        print(responce.body);
        print('No Edit equipment');
        emitNoEditEquipmentRequest(tt);
      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }

  Future EditProfile({
    required String name,
    required String address,
    required String phone,
  }) async {
    emitWaiting();
    final body = json.encode({
      "phone_number": phone,
      "name": name,
      "home_address": address,
      "technical_expert_id": "$expertid",


    });
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      var responce = await http.post(Uri.parse('$baseUrl/EditTechnicalExpertData'),
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

  Future fetchMyClients() async {
    emitWaiting();
    final body = json.encode({
      "technical_expert_id": "$expertid",
    });
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      var responce = await http.post(Uri.parse('$baseUrl/ShowAllClientYouAdd'),
          body: body, encoding: Encoding.getByName("utf-8"), headers: headers);

      if (responce.statusCode == 200) {
        final data = jsonDecode(responce.body);

        final clients = (data['All Client your Added'] as List)
            .map((client) => AllClientYourAdded.fromJson(client))
            .toList();
        print(clients);
        _allClients = clients;

        emitGetMyClients(clients);
      } else {
        var tt = MyClients.fromJson(jsonDecode(responce.body));

        print(responce.reasonPhrase);
        print(responce.body);
        emitNoGetMyClients(tt);
      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }

  Future fetchEquipment() async {
    emitWaiting();
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      var responce = await http.post(
          Uri.parse('$baseUrl/EquipmentFormDataToSend'),
          headers: headers,
          encoding: Encoding.getByName("utf-8"));

      if (responce.statusCode == 200) {
        final data = jsonDecode(responce.body);
        print(data);
        print('/////////////////////////////////////////////');

        final panels = Equipment.fromJson(jsonDecode(responce.body));
        print(panels.msg.toString());
        emitFetchEquipment(panels);
      } else {
        print('No Equipment');
      }
    } on Exception catch (error) {
      log(error.toString());
      emitFailed();
    }
  }
  Future fetchSolar({
    required String id,
  }) async {
    emitWaiting();
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = json.encode({
        "client_id":id ,
      });
      var responce = await http.post(
          Uri.parse('$baseUrl/SolarSystemAssociatedWithClient'),
          headers: headers,
          body: body,
          encoding: Encoding.getByName("utf-8"));

      if (responce.statusCode == 200) {
        final data = jsonDecode(responce.body);
        print(data);
        print('/////////////////////////////////////////////');

        final solar = SolarSystem.fromJson(jsonDecode(responce.body));
        print(solar.msg.toString());
        emitFetchSolarSystem(solar);
      }else if (responce.statusCode == 404) {
        final data = jsonDecode(responce.body);
        print(data);
        print('/////////////////////////////////////////////');

        final solar = SolarSystem.fromJson(jsonDecode(responce.body));
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

  Future GetProfile() async {
    emitWaiting();
    print(expertid);
    print(accessToken);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final body = json.encode({
      "technical_expert_id": "$expertid",
    });
    var responce = await http.post(
        Uri.parse('$baseUrl/ShowTechnicalExpertData'),
        headers: headers,
        body: body,
        encoding: Encoding.getByName("utf-8"));
    print(responce.statusCode);
    print(responce.body);

    if (responce.statusCode == 200) {
      var tt = ExpertProfile.fromJson(jsonDecode(responce.body));
      print('1232');
      print(responce.body);
      emitProfile(tt);
    } else {
      throw Exception('Failed to load trips');
    }
  }
  Future GetDashboard() async {
    emitWaiting();
    print(expertid);
    print(accessToken);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final body = json.encode({
      "technical_expert_id": "$expertid",
    });
    var responce = await http.post(
        Uri.parse('$baseUrl/TechnicalExpertHomePage'),
        headers: headers,
        body: body,
        encoding: Encoding.getByName("utf-8"));
    print(responce.statusCode);
    print(responce.body);

    if (responce.statusCode == 200) {
      var tt = Dashboard.fromJson(jsonDecode(responce.body));
      print('1232');
      print(responce.body);
      emitDashboard(tt);
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future fetchEquipmentRequests() async {
    emitWaiting();
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = json.encode({
        "technical_expert_id": "$expertid",
      });
      var responce = await http.post(
          Uri.parse('$baseUrl/ShowAllEquipmentRequest'),
          headers: headers,
          body: body,
          encoding: Encoding.getByName("utf-8"));
      print(responce.statusCode);
      print(responce.body);

      if (responce.statusCode == 200) {
        final data = jsonDecode(responce.body);
        final equipment =
        (data['All Equipment Request your Send'] as List).map((equipment) => AllEquipmentRequestYourSend.fromJson(equipment)).toList();
        print(equipment[0].name);
        emitEquipmentLoaded(equipment);
        print(responce.body);
      } else {
        emit(EquipmentError('Failed to fetch equipment requests'));
        print(responce.body);
      }
    } catch (e) {
      emit(EquipmentError('An error occurred: $e'));
    }
  }

  void searchClients(String query) {
    final filteredClients = _allClients
        .where((client) =>
            client.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emitGetMyClients(filteredClients);
  }

  void emitWaiting() => emit(AuthcubitWaiting());
  void emitFailed() => emit(AuthcubitFailed());

  ///Login
  void emitLoged(Login authResponse) => emit(AuthcubitLoged(authResponse));
  void emitNoLoged(Login authResponse) => emit(AuthcubitNoLoged(authResponse));

  ///get My Clients
  void emitGetMyClients(List<AllClientYourAdded> clients) =>
      emit(AuthGetMyClients(clients));
  void emitNoGetMyClients(MyClients clients) =>
      emit(AuthNoGetMyClients(clients));

  ///AddClientAccount
  void emitClientCreatedSuccessfully(MyClients clients) =>
      emit(AuthClientCreatedSuccessfully(clients));
  void emitClientNotCreatedSuccessfully(MyClients clients) =>
      emit(AuthClientNotCreatedSuccessfully(clients));

  ///Expert Profile
  void emitProfile(ExpertProfile expert) => emit(AuthcubitProfile(expert));
  ///Dashboard
  void emitDashboard(Dashboard dashboard) => emit(AuthcubitDashboard(dashboard));

  ///
  void emitFetchEquipment(Equipment equipment) => emit(AuthcubitEquipments(equipment));
  ///
  void emitFetchSolarSystem(SolarSystem solarSystem) => emit(AuthcubitSolarSystem(solarSystem));
  void emitNoFetchSolarSystem(SolarSystem solarSystem) => emit(AuthcubitNoSolarSystem(solarSystem));


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
