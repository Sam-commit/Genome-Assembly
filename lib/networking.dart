import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const ktextfield = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  hintStyle: TextStyle(color: Colors.black26),

  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

const loader = SpinKitWanderingCubes(
  color: Colors.green,
  size: 70.0,
);


Functions func = Functions();

class Functions {
  Future postFile(FilePickerResult file, String kmer_length) async {
    print("post called");

    var request = http.MultipartRequest(
        'POST', Uri.parse("https://ngs-python.onrender.com/process_fasta"));
    request.files.add(await http.MultipartFile.fromPath(
        'fasta_file', file.paths[0]!,
        filename: "fasta_file"));

    request.fields['kmer_length'] = kmer_length;

    try {
      var response = await request.send();

      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(
          await utf8.decodeStream(response.stream),
        );
        var results = [];
        results.add(data["results"]);
        results.add(data["minLength"]);
        results.add(data["maxLength"]);
        results.add(data["avgLength"]);
        return results;
      }
    } on Exception catch (e) {
      print(e);
    }

    return [];
  }

  Future postKeyFile(FilePickerResult keyFile,
       String match, String misMatch, String gap,List<dynamic>results) async {
    print("post called");

    var request = http.MultipartRequest(
        'POST', Uri.parse("https://ngs-python.onrender.com/fasta_accuracy"));

    request.files.add(await http.MultipartFile.fromPath(
        'key_file', keyFile.paths[0]!,
        filename: "key_file"));

    request.fields['results'] = jsonEncode(results);
    request.fields['match_score'] = match;
    request.fields['mismatch_penalty'] = misMatch;
    request.fields['gap_penalty'] = gap;

    print(jsonEncode(results));

    try {
      var response = await request.send();

      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(
          await utf8.decodeStream(response.stream),
        );
        return data;
      }
    } on Exception catch (e) {
      print(e);
    }

    return {};
  }

  List<List<dynamic>> saving_data = [];

  Future save_data(List<dynamic> data, String name) async {
    print(data);
    saving_data.clear();
    bool success = false;
    List<dynamic> reads = [];
    data[0].forEach((value) {
      reads.add(value);
    });
    saving_data.add(reads);
    List<dynamic> reads_len = [];
    data[0].forEach((value) {
      reads_len.add(value.length);
    });
    saving_data.add(reads_len);
    Directory? _folderpath = Directory('/storage/emulated/0/Download');
    if(! await _folderpath.exists() )  _folderpath= await getExternalStorageDirectory();

    if (_folderpath != null) {
      String path;
      path = _folderpath.path + "/Genome";
      _folderpath = Directory(path);
      print(_folderpath.path);

      PermissionStatus status =
          await Permission.manageExternalStorage.request();
      print(status);
      if (status == PermissionStatus.granted) {
        if (await _folderpath.exists()) {
          path = _folderpath.path;
        } else {
          //if folder not exists create folder and then return its path
          final Directory _appDocDirNewFolder = await _folderpath
            ..create();
          path = _appDocDirNewFolder.path;
        }

        print(path);
        try {
          String csvData = ListToCsvConverter().convert(saving_data);
          path = "$path/${name}.csv";
          print(path);
          final File file = File(path);
          await file.writeAsString(csvData);
          success = true;
        } on Exception catch (e) {
          print(e);
        }
      } else {
        print("permission denied");
      }
    }
    return success;
  }

  Future save_data_all(List<dynamic> data, String name) async {
    print(data);
    saving_data.clear();
    bool success = false;
    List<dynamic> seq1 = [];
    List<dynamic> seq2 = [];
    List<dynamic> acc = [];
    for (var value in data) {
      seq1.add(value["seq1"]);
      seq2.add(value["seq2"]);
      acc.add(value["acc"]);
    }
    saving_data.add(seq1);
    saving_data.add(seq2);
    saving_data.add(acc);

    Directory? _folderpath = Directory('/storage/emulated/0/Download');
    if(! await _folderpath.exists() )  _folderpath= await getExternalStorageDirectory();

    if (_folderpath != null) {
      String path;
      path = _folderpath.path + "/Genome";
      _folderpath = Directory(path);
      print(_folderpath.path);

      PermissionStatus status =
      await Permission.manageExternalStorage.request();
      print(status);
      if (status == PermissionStatus.granted) {
        if (await _folderpath.exists()) {
          path = _folderpath.path;
        } else {
          //if folder not exists create folder and then return its path
          final Directory _appDocDirNewFolder = await _folderpath
            ..create();
          path = _appDocDirNewFolder.path;
        }

        print(path);
        try {
          String csvData = ListToCsvConverter().convert(saving_data);
          path = "$path/${name}.csv";
          print(path);
          final File file = File(path);
          await file.writeAsString(csvData);
          success = true;
        } on Exception catch (e) {
          print(e);
        }
      } else {
        print("permission denied");
      }
    }
    return success;
  }



  Future save_data_best(var data, String name) async {
    print(data);
    saving_data.clear();
    bool success = false;
    List<dynamic> read = [];
    List<dynamic> len = [];
    List<dynamic> mis = [];
    List<dynamic> gap = [];
    List<dynamic> score = [];

    read.add(data["best"]);
    len.add(data["best"].length);
    mis.add(data["mismatch"]);
    gap.add(data["gap"]);
    score.add(data["accuracy"]);

    saving_data.add(read);
    saving_data.add(len);
    saving_data.add(mis);
    saving_data.add(gap);
    saving_data.add(score);

    Directory? _folderpath = Directory('/storage/emulated/0/Download');
    if(! await _folderpath.exists() )  _folderpath= await getExternalStorageDirectory();

    if (_folderpath != null) {
      String path;
      path = _folderpath.path + "/Genome";
      _folderpath = Directory(path);
      print(_folderpath.path);

      PermissionStatus status =
      await Permission.manageExternalStorage.request();
      print(status);
      if (status == PermissionStatus.granted) {
        if (await _folderpath.exists()) {
          path = _folderpath.path;
        } else {
          //if folder not exists create folder and then return its path
          final Directory _appDocDirNewFolder = await _folderpath
            ..create();
          path = _appDocDirNewFolder.path;
        }

        print(path);
        try {
          String csvData = ListToCsvConverter().convert(saving_data);
          path = "$path/${name}.csv";
          print(path);
          final File file = File(path);
          await file.writeAsString(csvData);
          success = true;
        } on Exception catch (e) {
          print(e);
        }
      } else {
        print("permission denied");
      }
    }
    return success;
  }





}
