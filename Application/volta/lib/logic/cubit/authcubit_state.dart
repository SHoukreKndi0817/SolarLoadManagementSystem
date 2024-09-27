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
  final ExpertProfile expert;
  AuthcubitProfile(this.expert); // Add this constructor

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AuthcubitProfile && o.expert == expert;
  }

  @override
  int get hashCode => expert.hashCode;
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
class AuthcubitEquipments extends AuthcubitState {
  final Equipment trips;

  AuthcubitEquipments(this.trips);
}
///
class AuthcubitSolarSystem extends AuthcubitState {
  final SolarSystem solarSystem;

  AuthcubitSolarSystem(this.solarSystem);
}
class AuthcubitNoSolarSystem extends AuthcubitState {
  final SolarSystem solarSystem;

  AuthcubitNoSolarSystem(this.solarSystem);
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
