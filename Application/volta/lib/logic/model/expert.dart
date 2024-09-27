class Login {
  String? msg;
  TechnicalexpertDate? technicalexpertDate;

  Login({this.msg, this.technicalexpertDate});

  Login.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    technicalexpertDate = json['technicalexpert date'] != null
        ? new TechnicalexpertDate.fromJson(json['technicalexpert date'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.technicalexpertDate != null) {
      data['technicalexpert date'] = this.technicalexpertDate!.toJson();
    }
    return data;
  }
}

class TechnicalexpertDate {
  int? technicalExpertId;
  String? name;
  String? phoneNumber;
  String? homeAddress;
  String? userName;
  int? adminId;
  String? role;
  int? isActive;
  String? token;

  TechnicalexpertDate(
      {this.technicalExpertId,
        this.name,
        this.phoneNumber,
        this.homeAddress,
        this.userName,
        this.adminId,
        this.role,
        this.isActive,
        this.token});

  TechnicalexpertDate.fromJson(Map<String, dynamic> json) {
    technicalExpertId = json['technical_expert_id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    homeAddress = json['home_address'];
    userName = json['user_name'];
    adminId = json['admin_id'];
    role = json['role'];
    isActive = json['is_active'];
    token = json['token'];
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
    data['token'] = this.token;
    return data;
  }
}

////////////////////////////////////////////////////////

class MyClients {
  String? msg;
  List<AllClientYourAdded>? allClientYourAdded;

  MyClients({this.msg, this.allClientYourAdded});

  MyClients.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['All Client your Added'] != null) {
      allClientYourAdded = <AllClientYourAdded>[];
      json['All Client your Added'].forEach((v) {
        allClientYourAdded!.add(new AllClientYourAdded.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.allClientYourAdded != null) {
      data['All Client your Added'] =
          this.allClientYourAdded!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllClientYourAdded {
  int? clientId;
  String? name;
  String? phoneNumber;
  String? homeAddress;
  String? userName;
  String? connectionCode;
  int? technicalExpertId;
  String? role;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  AllClientYourAdded(
      {this.clientId,
        this.name,
        this.phoneNumber,
        this.homeAddress,
        this.userName,
        this.connectionCode,
        this.technicalExpertId,
        this.role,
        this.isActive,
        this.createdAt,
        this.updatedAt});

  AllClientYourAdded.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    homeAddress = json['home_address'];
    userName = json['user_name'];
    connectionCode = json['connection_code'];
    technicalExpertId = json['technical_expert_id'];
    role = json['role'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientId;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['home_address'] = this.homeAddress;
    data['user_name'] = this.userName;
    data['connection_code'] = this.connectionCode;
    data['technical_expert_id'] = this.technicalExpertId;
    data['role'] = this.role;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
////////////////////////////////////////////////////////

class Equipment {
  String? msg;
  List<AllPanel>? allPanel;
  List<AllBattery>? allBattery;
  List<AllInverter>? allInverter;

  Equipment({this.msg, this.allPanel, this.allBattery, this.allInverter});

  Equipment.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['All Panel'] != null) {
      allPanel = <AllPanel>[];
      json['All Panel'].forEach((v) {
        allPanel!.add(new AllPanel.fromJson(v));
      });
    }
    if (json['All Battery'] != null) {
      allBattery = <AllBattery>[];
      json['All Battery'].forEach((v) {
        allBattery!.add(new AllBattery.fromJson(v));
      });
    }
    if (json['All inverter'] != null) {
      allInverter = <AllInverter>[];
      json['All inverter'].forEach((v) {
        allInverter!.add(new AllInverter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.allPanel != null) {
      data['All Panel'] = this.allPanel!.map((v) => v.toJson()).toList();
    }
    if (this.allBattery != null) {
      data['All Battery'] = this.allBattery!.map((v) => v.toJson()).toList();
    }
    if (this.allInverter != null) {
      data['All inverter'] = this.allInverter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllPanel {
  int? panelId;
  String? manufacturer;
  String? model;
  String? maxPowerOutputWatt;
  String? cellType;
  String? efficiency;
  String? panelType;
  String? createdAt;
  String? updatedAt;

  AllPanel(
      {this.panelId,
        this.manufacturer,
        this.model,
        this.maxPowerOutputWatt,
        this.cellType,
        this.efficiency,
        this.panelType,
        this.createdAt,
        this.updatedAt});

  AllPanel.fromJson(Map<String, dynamic> json) {
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

class AllBattery {
  int? batteryId;
  String? batteryType;
  String? absorbStageVolts;
  String? floatStageVolts;
  String? equalizeStageVolts;
  String? equalizeIntervalDays;
  String? setingSwitches;
  String? createdAt;
  String? updatedAt;

  AllBattery(
      {this.batteryId,
        this.batteryType,
        this.absorbStageVolts,
        this.floatStageVolts,
        this.equalizeStageVolts,
        this.equalizeIntervalDays,
        this.setingSwitches,
        this.createdAt,
        this.updatedAt, required String settingSwitches});

  AllBattery.fromJson(Map<String, dynamic> json) {
    batteryId = json['battery_id'];
    batteryType = json['battery_type'];
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

class AllInverter {
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

  AllInverter(
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

  AllInverter.fromJson(Map<String, dynamic> json) {
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

/////////////////////////////////////////////////////////

class ExpertProfile {
  String? msg;
  TechnicalExpertData? technicalExpertData;

  ExpertProfile({this.msg, this.technicalExpertData});

  ExpertProfile.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    technicalExpertData = json['Technical Expert data'] != null
        ? new TechnicalExpertData.fromJson(json['Technical Expert data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.technicalExpertData != null) {
      data['Technical Expert data'] = this.technicalExpertData!.toJson();
    }
    return data;
  }
}

class TechnicalExpertData {
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

  TechnicalExpertData(
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

  TechnicalExpertData.fromJson(Map<String, dynamic> json) {
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
//////////////////////////////////////////////////////////////////////////////////////
class Dashboard {
  String? msg;
  int? clientCount;
  int? totalSolarSystems;
  int? requestEquipmentCount;
  int? daysWorked;
  int? theRate;

  Dashboard(
      {this.msg,
        this.clientCount,
        this.totalSolarSystems,
        this.requestEquipmentCount,
        this.daysWorked,
        this.theRate});

  Dashboard.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    clientCount = json['Client Count'];
    totalSolarSystems = json['Total Solar Systems'];
    requestEquipmentCount = json['Request Equipment Count'];
    daysWorked = json['Days Worked'];
    theRate = json['The Rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['Client Count'] = this.clientCount;
    data['Total Solar Systems'] = this.totalSolarSystems;
    data['Request Equipment Count'] = this.requestEquipmentCount;
    data['Days Worked'] = this.daysWorked;
    data['The Rate'] = this.theRate;
    return data;
  }
}
////////////////////////////////////////////////////////////

class ShowAllEquipmentRequest {
  String? msg;
  List<AllEquipmentRequestYourSend>? allEquipmentRequestYourSend;

  ShowAllEquipmentRequest({this.msg, this.allEquipmentRequestYourSend});

  ShowAllEquipmentRequest.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['All Equipment Request your Send'] != null) {
      allEquipmentRequestYourSend = <AllEquipmentRequestYourSend>[];
      json['All Equipment Request your Send'].forEach((v) {
        allEquipmentRequestYourSend!
            .add(new AllEquipmentRequestYourSend.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.allEquipmentRequestYourSend != null) {
      data['All Equipment Request your Send'] =
          this.allEquipmentRequestYourSend!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllEquipmentRequestYourSend {
  int? requestEquipmentId;
  int? technicalExpertId;
  String? name;
  int? numberOfBroadcastDevice;
  int? numberOfPort;
  int? numberOfSocket;
  int? panelId;
  int? numberOfPanel;
  int? batteryId;
  int? numberOfBattery;
  int? invertersId;
  String? numberOfInverter;
  String? additionalEquipment;
  String? status;
  String? commet;
  String? createdAt;
  String? updatedAt;
  Panel? panel;
  Battery? battery;
  Inverter? inverter;

  AllEquipmentRequestYourSend(
      {this.requestEquipmentId,
        this.technicalExpertId,
        this.name,
        this.numberOfBroadcastDevice,
        this.numberOfPort,
        this.numberOfSocket,
        this.panelId,
        this.numberOfPanel,
        this.batteryId,
        this.numberOfBattery,
        this.invertersId,
        this.numberOfInverter,
        this.additionalEquipment,
        this.status,
        this.commet,
        this.createdAt,
        this.updatedAt,
        this.panel,
        this.battery,
        this.inverter});

  AllEquipmentRequestYourSend.fromJson(Map<String, dynamic> json) {
    requestEquipmentId = json['request_equipment_id'];
    technicalExpertId = json['technical_expert_id'];
    name = json['name'];
    numberOfBroadcastDevice = json['number_of_broadcast_device'];
    numberOfPort = json['number_of_port'];
    numberOfSocket = json['number_of_socket'];
    panelId = json['panel_id'];
    numberOfPanel = json['number_of_panel'];
    batteryId = json['battery_id'];
    numberOfBattery = json['number_of_battery'];
    invertersId = json['inverters_id'];
    numberOfInverter = json['number_of_inverter'];
    additionalEquipment = json['additional_equipment'];
    status = json['status'];
    commet = json['commet'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    panel = json['panel'] != null ? new Panel.fromJson(json['panel']) : null;
    battery =
    json['battery'] != null ? new Battery.fromJson(json['battery']) : null;
    inverter = json['inverter'] != null
        ? new Inverter.fromJson(json['inverter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_equipment_id'] = this.requestEquipmentId;
    data['technical_expert_id'] = this.technicalExpertId;
    data['name'] = this.name;
    data['number_of_broadcast_device'] = this.numberOfBroadcastDevice;
    data['number_of_port'] = this.numberOfPort;
    data['number_of_socket'] = this.numberOfSocket;
    data['panel_id'] = this.panelId;
    data['number_of_panel'] = this.numberOfPanel;
    data['battery_id'] = this.batteryId;
    data['number_of_battery'] = this.numberOfBattery;
    data['inverters_id'] = this.invertersId;
    data['number_of_inverter'] = this.numberOfInverter;
    data['additional_equipment'] = this.additionalEquipment;
    data['status'] = this.status;
    data['commet'] = this.commet;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.panel != null) {
      data['panel'] = this.panel!.toJson();
    }
    if (this.battery != null) {
      data['battery'] = this.battery!.toJson();
    }
    if (this.inverter != null) {
      data['inverter'] = this.inverter!.toJson();
    }
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

class Battery {
  int? batteryId;
  String? batteryType;
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

/////////////////////////////////////////////////////////////

class SolarSystem {
  String? msg;
  List<SolarSystemData>? solarSystemData;

  SolarSystem({this.msg, this.solarSystemData});

  SolarSystem.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['Solar System  data'] != null) {
      solarSystemData = <SolarSystemData>[];
      json['Solar System  data'].forEach((v) {
        solarSystemData!.add(new SolarSystemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.solarSystemData != null) {
      data['Solar System  data'] =
          this.solarSystemData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SolarSystemData {
  int? solarSysInfoId;
  String? name;
  int? clientId;
  int? technicalExpertId;
  int? invertersId;
  int? batteryId;
  String? numberOfBattery;
  int? battery_conection_type;
  int? panelId;
  String? numberOfPanel;
  String? numberOfPanelGroup;
  String? panelConectionTypeone;
  String? panelConectionTypetwo;
  String? phaseType;
  int? broadcastDeviceId;
  String? createdAt;
  String? updatedAt;

  SolarSystemData(
      {this.solarSysInfoId,
        this.name,
        this.clientId,
        this.technicalExpertId,
        this.invertersId,
        this.batteryId,
        this.numberOfBattery,
        this.battery_conection_type,
        this.panelId,
        this.numberOfPanel,
        this.numberOfPanelGroup,
        this.panelConectionTypeone,
        this.panelConectionTypetwo,
        this.phaseType,
        this.broadcastDeviceId,
        this.createdAt,
        this.updatedAt});

  SolarSystemData.fromJson(Map<String, dynamic> json) {
    solarSysInfoId = json['solar_sys_info_id'];
    name = json['name'];
    clientId = json['client_id'];
    technicalExpertId = json['technical_expert_id'];
    invertersId = json['inverters_id'];
    batteryId = json['battery_id'];
    numberOfBattery = json['number_of_battery'];
    battery_conection_type = json['battery_conection_type'];
    panelId = json['panel_id'];
    numberOfPanel = json['number_of_panel'];
    numberOfPanelGroup = json['number_of_panel_group'];
    panelConectionTypeone = json['panel_conection_typeone'];
    panelConectionTypetwo = json['panel_conection_typetwo'];
    phaseType = json['phase_type'];
    broadcastDeviceId = json['broadcast_device_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['battery_conection_type'] = this.battery_conection_type;
    data['panel_id'] = this.panelId;
    data['number_of_panel'] = this.numberOfPanel;
    data['number_of_panel_group'] = this.numberOfPanelGroup;
    data['panel_conection_typeone'] = this.panelConectionTypeone;
    data['panel_conection_typetwo'] = this.panelConectionTypetwo;
    data['phase_type'] = this.phaseType;
    data['broadcast_device_id'] = this.broadcastDeviceId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
