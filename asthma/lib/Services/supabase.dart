import 'dart:typed_data';

import 'package:asthma/Models/location_model.dart';
import 'package:asthma/Models/medication_model.dart';
import 'package:asthma/Models/symptoms_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

List<LocationModel> allHospetal = [];
List<MedicationModel> allMedication = [];
List<SymptomsModel> allSymptoms = [];

class SupabaseServer {
  final supabase = Supabase.instance.client;

  getHospitalData() async {
    final hospitalData = await supabase.from("hospitals").select();
    print(hospitalData);

    print(hospitalData);
    for (var element in hospitalData) {
      allHospetal.add(LocationModel.fromJson(element));
    }
    return allHospetal;
  }

  getMedication() async {
    final data = await supabase.from("medication").select("*");
    print(data);

    for (var element in data) {
      allMedication.add(MedicationModel.fromJson(element));
    }
    return allMedication;
  }

  getSymptoms() async {
    final data = await supabase.from("symptoms").select("*");
    print(data);

    for (var element in data) {
      allSymptoms.add(SymptomsModel.fromJson(element));
    }
    return allSymptoms;
  }

  addMedication(Map body) async {
    await supabase.from("medication").insert(body).select();
  }

  addSymptom(Map body) async {
    await supabase.from("symptoms").insert(body).select();
    
  }

  saveCaptrueImage(Uint8List pathImagefile) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.storage.from('captrue_image').uploadBinary(
        'image${DateTime.now().millisecondsSinceEpoch}.png', pathImagefile);
    print(response);
  }
}
