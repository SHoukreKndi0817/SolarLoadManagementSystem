part of 'authcubit_cubit.dart';

@immutable
abstract class AuthcubitState {}
class AuthcubitInitial extends AuthcubitState {}
class AuthcubitWaiting extends AuthcubitState {}
class AuthcubitFailed extends AuthcubitState {}
class AuthcubitSendEquipment extends AuthcubitState {
  final Login authResponse;
  AuthcubitSendEquipment(this.authResponse); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitSendEquipment && o.authResponse == authResponse;
  }

  @override
  int get hashCode => authResponse.hashCode;
}
class AuthcubitNoSendEquipment extends AuthcubitState {
  final Login authResponse;
  AuthcubitNoSendEquipment(this.authResponse); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitNoSendEquipment && o.authResponse == authResponse;
  }

  @override
  int get hashCode => authResponse.hashCode;
}
class AuthcubitEditEquipmentRequest extends AuthcubitState {
  final Login authResponse;
  AuthcubitEditEquipmentRequest(this.authResponse); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitEditEquipmentRequest && o.authResponse == authResponse;
  }

  @override
  int get hashCode => authResponse.hashCode;
}
class AuthcubitNoEditEquipmentRequest extends AuthcubitState {
  final Login authResponse;
  AuthcubitNoEditEquipmentRequest(this.authResponse); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitNoEditEquipmentRequest && o.authResponse == authResponse;
  }

  @override
  int get hashCode => authResponse.hashCode;
}
class AuthcubitEditProfile extends AuthcubitState {}
class AuthcubitAddSolarSystemInfo extends AuthcubitState {
  final Login authResponse;
  AuthcubitAddSolarSystemInfo(this.authResponse); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitAddSolarSystemInfo && o.authResponse == authResponse;
  }

  @override
  int get hashCode => authResponse.hashCode;
}
class AuthcubitNoAddSolarSystemInfo extends AuthcubitState {
  final Login authResponse;
  AuthcubitNoAddSolarSystemInfo(this.authResponse); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitNoAddSolarSystemInfo && o.authResponse == authResponse;
  }

  @override
  int get hashCode => authResponse.hashCode;
}
class AuthcubitUpdateSolarSystemInfo extends AuthcubitState {
  final Login authResponse;
  AuthcubitUpdateSolarSystemInfo(this.authResponse); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitUpdateSolarSystemInfo && o.authResponse == authResponse;
  }

  @override
  int get hashCode => authResponse.hashCode;
}
class AuthcubitNoUpdateSolarSystemInfo extends AuthcubitState {
  final Login authResponse;
  AuthcubitNoUpdateSolarSystemInfo(this.authResponse); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitNoUpdateSolarSystemInfo && o.authResponse == authResponse;
  }

  @override
  int get hashCode => authResponse.hashCode;
}

///Login
class AuthcubitLoged extends AuthcubitState {
  final Login authResponse;
  AuthcubitLoged(this.authResponse); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitLoged && o.authResponse == authResponse;
  }

  @override
  int get hashCode => authResponse.hashCode;
}
class AuthcubitNoLoged extends AuthcubitState {
  final Login authResponse;
  AuthcubitNoLoged(this.authResponse); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitNoLoged && o.authResponse == authResponse;
  }

  @override
  int get hashCode => authResponse.hashCode;
}
class AuthcubitLogedClient extends AuthcubitState {
  final LoginClient authResponse;
  AuthcubitLogedClient(this.authResponse); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitLogedClient && o.authResponse == authResponse;
  }

  @override
  int get hashCode => authResponse.hashCode;
}
class AuthcubitNoLogedClient extends AuthcubitState {
  final LoginClient authResponse;
  AuthcubitNoLogedClient(this.authResponse); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitNoLogedClient && o.authResponse == authResponse;
  }

  @override
  int get hashCode => authResponse.hashCode;
}

///GetMyClients
class AuthGetMyClients extends AuthcubitState {
  final List<AllClientYourAdded> clients;
  AuthGetMyClients(this.clients); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthGetMyClients && o.clients == clients;
  }

  @override
  int get hashCode => clients.hashCode;
}
class AuthNoGetMyClients extends AuthcubitState {
  final MyClients clients;
  AuthNoGetMyClients(this.clients); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthNoGetMyClients && o.clients == clients;
  }

  @override
  int get hashCode => clients.hashCode;
}

///Add Client created successfully
class AuthClientCreatedSuccessfully extends AuthcubitState {
  final MyClients clients;
  AuthClientCreatedSuccessfully(this.clients); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthClientCreatedSuccessfully && o.clients == clients;
  }

  @override
  int get hashCode => clients.hashCode;
}
class AuthClientNotCreatedSuccessfully extends AuthcubitState {
  final MyClients clients;
  AuthClientNotCreatedSuccessfully(this.clients); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthClientNotCreatedSuccessfully && o.clients == clients;
  }

  @override
  int get hashCode => clients.hashCode;
}

///Expert Profile
class AuthcubitProfile extends AuthcubitState {
  final ClientProfile client;
  AuthcubitProfile(this.client); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitProfile && o.client == client;
  }

  @override
  int get hashCode => client.hashCode;
}
///
class AuthcubitBroadcastData extends AuthcubitState {
  final AllBroadcastData broadcastData;
  AuthcubitBroadcastData(this.broadcastData); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitBroadcastData && o.broadcastData == broadcastData;
  }

  @override
  int get hashCode => broadcastData.hashCode;
}
///Dashboard
class AuthcubitDashboard extends AuthcubitState {
  final Dashboard dashboard;
  AuthcubitDashboard(this.dashboard); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitDashboard && o.dashboard == dashboard;
  }

  @override
  int get hashCode => dashboard.hashCode;
}
///
class AuthcubitSocket extends AuthcubitState {
  final AllSocket socket;

  AuthcubitSocket(this.socket);
}
///
class AuthGetMyHomeDevice extends AuthcubitState {
  final List<HomeDevices> device;
  AuthGetMyHomeDevice(this.device); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthGetMyHomeDevice && o.device == device;
  }

  @override
  int get hashCode => device.hashCode;
}
class AuthNoGetMyHomeDevice extends AuthcubitState {
  final HomeDevice device;
  AuthNoGetMyHomeDevice(this.device); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthNoGetMyHomeDevice && o.device == device;
  }

  @override
  int get hashCode => device.hashCode;
}
///
class AuthcubitSolarSystem extends AuthcubitState {
  final AllSolarSystem solarSystem;

  AuthcubitSolarSystem(this.solarSystem);
}
class AuthcubitSolarSystemInfo extends AuthcubitState {
  final SolarSystemInfo solarSystemInfo;

  AuthcubitSolarSystemInfo(this.solarSystemInfo);
}
class AuthcubitNoSolarSystem extends AuthcubitState {
  final AllSolarSystem solarSystem;

  AuthcubitNoSolarSystem(this.solarSystem);
}
class AuthcubitNoSolarSystemInfo extends AuthcubitState {
  final SolarSystemInfo solarSystemInfo;

  AuthcubitNoSolarSystemInfo(this.solarSystemInfo);
}
class AuthcubitNoCheckPowerToSendAction extends AuthcubitState {
  final Msg solarSystem;

  AuthcubitNoCheckPowerToSendAction(this.solarSystem);
}
class AuthcubitCheckPowerToSendAction extends AuthcubitState {
  final Msg solarSystemInfo;

  AuthcubitCheckPowerToSendAction(this.solarSystemInfo);
}

///
class EquipmentInitial extends AuthcubitState {}

class EquipmentLoading extends AuthcubitState {}

class EquipmentLoaded extends AuthcubitState {
  final List<AllEquipmentRequestYourSend> equipmentRequests;
  EquipmentLoaded(this.equipmentRequests);
}

class EquipmentError extends AuthcubitState {
  final String message;
  EquipmentError(this.message);
}
