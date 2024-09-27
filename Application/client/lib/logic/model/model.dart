class SolarSystemInfo {
  String? msg;
  SolarSystemInformation? solarSystemInformation;

  SolarSystemInfo({this.msg, this.solarSystemInformation});

  SolarSystemInfo.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    solarSystemInformation = json['Solar System Information'] != null
        ? new SolarSystemInformation.fromJson(json['Solar System Information'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.solarSystemInformation != null) {
      data['Solar System Information'] = this.solarSystemInformation!.toJson();
    }
    return data;
  }
}

class SolarSystemInformation {
  int? solarSysInfoId;
  String? name;
  int? clientId;
  int? technicalExpertId;
  int? invertersId;
  int? batteryId;
  String? numberOfBattery;
  int? batteryConectionType;
  int? panelId;
  String? numberOfPanel;
  String? numberOfPanelGroup;
  String? panelConectionTypeone;
  String? panelConectionTypetwo;
  String? phaseType;
  int? broadcastDeviceId;
  String? createdAt;
  String? updatedAt;
  TechnicalExpert? technicalExpert;
  Inverter? inverter;
  Battery? battery;
  Panel? panel;

  SolarSystemInformation(
      {this.solarSysInfoId,
        this.name,
        this.clientId,
        this.technicalExpertId,
        this.invertersId,
        this.batteryId,
        this.numberOfBattery,
        this.batteryConectionType,
        this.panelId,
        this.numberOfPanel,
        this.numberOfPanelGroup,
        this.panelConectionTypeone,
        this.panelConectionTypetwo,
        this.phaseType,
        this.broadcastDeviceId,
        this.createdAt,
        this.updatedAt,
        this.technicalExpert,
        this.inverter,
        this.battery,
        this.panel});

  SolarSystemInformation.fromJson(Map<String, dynamic> json) {
    solarSysInfoId = json['solar_sys_info_id'];
    name = json['name'];
    clientId = json['client_id'];
    technicalExpertId = json['technical_expert_id'];
    invertersId = json['inverters_id'];
    batteryId = json['battery_id'];
    numberOfBattery = json['number_of_battery'];
    batteryConectionType = json['battery_conection_type'];
    panelId = json['panel_id'];
    numberOfPanel = json['number_of_panel'];
    numberOfPanelGroup = json['number_of_panel_group'];
    panelConectionTypeone = json['panel_conection_typeone'];
    panelConectionTypetwo = json['panel_conection_typetwo'];
    phaseType = json['phase_type'];
    broadcastDeviceId = json['broadcast_device_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    technicalExpert = json['technical_expert'] != null
        ? new TechnicalExpert.fromJson(json['technical_expert'])
        : null;
    inverter = json['inverter'] != null
        ? new Inverter.fromJson(json['inverter'])
        : null;
    battery =
    json['battery'] != null ? new Battery.fromJson(json['battery']) : null;
    panel = json['panel'] != null ? new Panel.fromJson(json['panel']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['solar_sys_info_id'] = this.solarSysInfoId;
    data['name'] = this.name;
    data['client_id'] = this.clientId;
    data['technical_expert_id'] = this.technicalExpertId;
    data['inverters_id'] = this.invertersId;
    data['battery_id'] = this.batteryId;
    data['number_of_battery'] = this.numberOfBattery;
    data['battery_conection_type'] = this.batteryConectionType;
    data['panel_id'] = this.panelId;
    data['number_of_panel'] = this.numberOfPanel;
    data['number_of_panel_group'] = this.numberOfPanelGroup;
    data['panel_conection_typeone'] = this.panelConectionTypeone;
    data['panel_conection_typetwo'] = this.panelConectionTypetwo;
    data['phase_type'] = this.phaseType;
    data['broadcast_device_id'] = this.broadcastDeviceId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.technicalExpert != null) {
      data['technical_expert'] = this.technicalExpert!.toJson();
    }
    if (this.inverter != null) {
      data['inverter'] = this.inverter!.toJson();
    }
    if (this.battery != null) {
      data['battery'] = this.battery!.toJson();
    }
    if (this.panel != null) {
      data['panel'] = this.panel!.toJson();
    }
    return data;
  }
}

class TechnicalExpert {
  int? technicalExpertId;
  String? name;
  String? phoneNumber;
  String? homeAddress;
  String? userName;
  int? adminId;
  String? role;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  TechnicalExpert(
      {this.technicalExpertId,
        this.name,
        this.phoneNumber,
        this.homeAddress,
        this.userName,
        this.adminId,
        this.role,
        this.isActive,
        this.createdAt,
        this.updatedAt});

  TechnicalExpert.fromJson(Map<String, dynamic> json) {
    technicalExpertId = json['technical_expert_id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    homeAddress = json['home_address'];
    userName = json['user_name'];
    adminId = json['admin_id'];
    role = json['role'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['technical_expert_id'] = this.technicalExpertId;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['home_address'] = this.homeAddress;
    data['user_name'] = this.userName;
    data['admin_id'] = this.adminId;
    data['role'] = this.role;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Inverter {
  int? invertersId;
  String? modelName;
  String? operatingTemperature;
  String? invertModeRatedPower;
  String? invertModeDcInput;
  String? invertModeAcOutput;
  String? acChargerModeAcInput;
  String? acChargerModeAcOutput;
  String? acChargerModeDcOutput;
  String? acChargerModeMaxCharger;
  String? solarChargerModeRatedPower;
  String? solarChargerModeSystemVoltage;
  String? solarChargerModeMpptVoltageRange;
  String? solarChargerModeMaxSolarVoltage;
  String? createdAt;
  String? updatedAt;

  Inverter(
      {this.invertersId,
        this.modelName,
        this.operatingTemperature,
        this.invertModeRatedPower,
        this.invertModeDcInput,
        this.invertModeAcOutput,
        this.acChargerModeAcInput,
        this.acChargerModeAcOutput,
        this.acChargerModeDcOutput,
        this.acChargerModeMaxCharger,
        this.solarChargerModeRatedPower,
        this.solarChargerModeSystemVoltage,
        this.solarChargerModeMpptVoltageRange,
        this.solarChargerModeMaxSolarVoltage,
        this.createdAt,
        this.updatedAt});

  Inverter.fromJson(Map<String, dynamic> json) {
    invertersId = json['inverters_id'];
    modelName = json['model_name'];
    operatingTemperature = json['operating_temperature'];
    invertModeRatedPower = json['invert_mode_rated_power'];
    invertModeDcInput = json['invert_mode_dc_input'];
    invertModeAcOutput = json['invert_mode_ac_output'];
    acChargerModeAcInput = json['ac_charger_mode_ac_input'];
    acChargerModeAcOutput = json['ac_charger_mode_ac_output'];
    acChargerModeDcOutput = json['ac_charger_mode_dc_output'];
    acChargerModeMaxCharger = json['ac_charger_mode_max_charger'];
    solarChargerModeRatedPower = json['solar_charger_mode_rated_power'];
    solarChargerModeSystemVoltage = json['solar_charger_mode_system_voltage'];
    solarChargerModeMpptVoltageRange =
    json['solar_charger_mode_mppt_voltage_range'];
    solarChargerModeMaxSolarVoltage =
    json['solar_charger_mode_max_solar_voltage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inverters_id'] = this.invertersId;
    data['model_name'] = this.modelName;
    data['operating_temperature'] = this.operatingTemperature;
    data['invert_mode_rated_power'] = this.invertModeRatedPower;
    data['invert_mode_dc_input'] = this.invertModeDcInput;
    data['invert_mode_ac_output'] = this.invertModeAcOutput;
    data['ac_charger_mode_ac_input'] = this.acChargerModeAcInput;
    data['ac_charger_mode_ac_output'] = this.acChargerModeAcOutput;
    data['ac_charger_mode_dc_output'] = this.acChargerModeDcOutput;
    data['ac_charger_mode_max_charger'] = this.acChargerModeMaxCharger;
    data['solar_charger_mode_rated_power'] = this.solarChargerModeRatedPower;
    data['solar_charger_mode_system_voltage'] =
        this.solarChargerModeSystemVoltage;
    data['solar_charger_mode_mppt_voltage_range'] =
        this.solarChargerModeMpptVoltageRange;
    data['solar_charger_mode_max_solar_voltage'] =
        this.solarChargerModeMaxSolarVoltage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Battery {
  int? batteryId;
  String? batteryType;
  String? batteryCapacity;
  String? maximumWattBattery;
  String? absorbStageVolts;
  String? floatStageVolts;
  String? equalizeStageVolts;
  String? equalizeIntervalDays;
  String? setingSwitches;
  String? createdAt;
  String? updatedAt;

  Battery(
      {this.batteryId,
        this.batteryType,
        this.batteryCapacity,
        this.maximumWattBattery,
        this.absorbStageVolts,
        this.floatStageVolts,
        this.equalizeStageVolts,
        this.equalizeIntervalDays,
        this.setingSwitches,
        this.createdAt,
        this.updatedAt});

  Battery.fromJson(Map<String, dynamic> json) {
    batteryId = json['battery_id'];
    batteryType = json['battery_type'];
    batteryCapacity = json['battery_capacity'];
    maximumWattBattery = json['maximum_watt_battery'];
    absorbStageVolts = json['absorb_stage_volts'];
    floatStageVolts = json['float_stage_volts'];
    equalizeStageVolts = json['equalize_stage_volts'];
    equalizeIntervalDays = json['equalize_interval_days'];
    setingSwitches = json['seting_switches'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['battery_id'] = this.batteryId;
    data['battery_type'] = this.batteryType;
    data['battery_capacity'] = this.batteryCapacity;
    data['maximum_watt_battery'] = this.maximumWattBattery;
    data['absorb_stage_volts'] = this.absorbStageVolts;
    data['float_stage_volts'] = this.floatStageVolts;
    data['equalize_stage_volts'] = this.equalizeStageVolts;
    data['equalize_interval_days'] = this.equalizeIntervalDays;
    data['seting_switches'] = this.setingSwitches;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Panel {
  int? panelId;
  String? manufacturer;
  String? model;
  String? maxPowerOutputWatt;
  String? cellType;
  String? efficiency;
  String? panelType;
  String? createdAt;
  String? updatedAt;

  Panel(
      {this.panelId,
        this.manufacturer,
        this.model,
        this.maxPowerOutputWatt,
        this.cellType,
        this.efficiency,
        this.panelType,
        this.createdAt,
        this.updatedAt});

  Panel.fromJson(Map<String, dynamic> json) {
    panelId = json['panel_id'];
    manufacturer = json['manufacturer'];
    model = json['model'];
    maxPowerOutputWatt = json['max_power_output_watt'];
    cellType = json['cell_type'];
    efficiency = json['efficiency'];
    panelType = json['panel_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['panel_id'] = this.panelId;
    data['manufacturer'] = this.manufacturer;
    data['model'] = this.model;
    data['max_power_output_watt'] = this.maxPowerOutputWatt;
    data['cell_type'] = this.cellType;
    data['efficiency'] = this.efficiency;
    data['panel_type'] = this.panelType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

///

class HomeDevice {
  String? msg;
  List<HomeDevices>? homeDevices;

  HomeDevice({this.msg, this.homeDevices});

  HomeDevice.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['Home Devices'] != null) {
      homeDevices = <HomeDevices>[];
      json['Home Devices'].forEach((v) {
        homeDevices!.add(new HomeDevices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.homeDevices != null) {
      data['Home Devices'] = this.homeDevices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HomeDevices {
  int? homeDeviceId;
  String? deviceName;
  String? deviceType;
  int? socketId;
  String? socketName;
  int? socketStatus;

  HomeDevices(
      {this.homeDeviceId,
        this.deviceName,
        this.deviceType,
        this.socketId,
        this.socketName,
        this.socketStatus});

  HomeDevices.fromJson(Map<String, dynamic> json) {
    homeDeviceId = json['home_device_id'];
    deviceName = json['device_name'];
    deviceType = json['device_type'];
    socketId = json['socket_id'];
    socketName = json['socket_name'];
    socketStatus = json['socket_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home_device_id'] = this.homeDeviceId;
    data['device_name'] = this.deviceName;
    data['device_type'] = this.deviceType;
    data['socket_id'] = this.socketId;
    data['socket_name'] = this.socketName;
    data['socket_status'] = this.socketStatus;
    return data;
  }
}

///

class AllSocket {
  String? msg;
  List<Socket>? socket;

  AllSocket({this.msg, this.socket});

  AllSocket.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['Socket'] != null) {
      socket = <Socket>[];
      json['Socket'].forEach((v) {
        socket!.add(new Socket.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.socket != null) {
      data['Socket'] = this.socket!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Socket {
  int? socketId;
  int? broadcastDeviceId;
  String? socketModel;
  String? socketVersion;
  String? socketName;
  String? socketConnectionType;
  int? status;
  String? createdAt;
  String? updatedAt;

  Socket(
      {this.socketId,
        this.broadcastDeviceId,
        this.socketModel,
        this.socketVersion,
        this.socketName,
        this.socketConnectionType,
        this.status,
        this.createdAt,
        this.updatedAt});

  Socket.fromJson(Map<String, dynamic> json) {
    socketId = json['socket_id'];
    broadcastDeviceId = json['broadcast_device_id'];
    socketModel = json['socket_model'];
    socketVersion = json['socket_version'];
    socketName = json['socket_name'];
    socketConnectionType = json['socket_connection_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['socket_id'] = this.socketId;
    data['broadcast_device_id'] = this.broadcastDeviceId;
    data['socket_model'] = this.socketModel;
    data['socket_version'] = this.socketVersion;
    data['socket_name'] = this.socketName;
    data['socket_connection_type'] = this.socketConnectionType;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

///
class AllBroadcastData {
  String? msg;
  BroadcastData? broadcastData;

  AllBroadcastData({this.msg, this.broadcastData});

  AllBroadcastData.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    broadcastData = json['Broadcast Data'] != null
        ? new BroadcastData.fromJson(json['Broadcast Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.broadcastData != null) {
      data['Broadcast Data'] = this.broadcastData!.toJson();
    }
    return data;
  }
}

class BroadcastData {
  int? broadcastDataId;
  String? batteryVoltage;
  int? solarPowerGenerationW;
  int? powerConsumptionW;
  String? batteryPercentage;
  int? electric;
  int? status;

  BroadcastData(
      {this.broadcastDataId,
        this.batteryVoltage,
        this.solarPowerGenerationW,
        this.powerConsumptionW,
        this.batteryPercentage,
        this.electric,
        this.status});

  BroadcastData.fromJson(Map<String, dynamic> json) {
    broadcastDataId = json['broadcast_data_id'];
    batteryVoltage = json['battery_voltage'];
    solarPowerGenerationW = json['solar_power_generation(w)'];
    powerConsumptionW = json['power_consumption(w)'];
    batteryPercentage = json['battery_percentage'];
    electric = json['electric'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['broadcast_data_id'] = this.broadcastDataId;
    data['battery_voltage'] = this.batteryVoltage;
    data['solar_power_generation(w)'] = this.solarPowerGenerationW;
    data['power_consumption(w)'] = this.powerConsumptionW;
    data['battery_percentage'] = this.batteryPercentage;
    data['electric'] = this.electric;
    data['status'] = this.status;
    return data;
  }
}
