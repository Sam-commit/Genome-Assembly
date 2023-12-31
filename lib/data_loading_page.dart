import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:genome_assembly/results_page.dart';
import 'package:http/http.dart' as http;
import 'networking.dart';

class DataLoadingPage extends StatefulWidget {
  const DataLoadingPage({Key? key}) : super(key: key);

  @override
  State<DataLoadingPage> createState() => _DataLoadingPageState();
}

class _DataLoadingPageState extends State<DataLoadingPage> {
  bool isPicked = false;
  bool _isLoading = false;
  String fileName = "Not selected";
  late FilePickerResult pickedFile;
  String kmer_length = "5";

  Future<FilePickerResult?> _pickFastaFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          allowCompression: false,
          withData: true,
          lockParentWindow: true,
          allowMultiple: false);
      return result;
    } catch (e) {
      print('Error picking Fasta file: $e');
    }
  }

  // Future<String> check()async {
  //   await Future.delayed(Duration(seconds: 10), () {
  //     // Your code to execute after the delay
  //     print('Delayed action executed after 2 seconds');
  //   });
  //
  //   return "Hello";
  //
  //
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF006663), Color(0xFF111111)]),
              ),
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Please select a Fasta file to upload",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  FilePickerResult? file = await _pickFastaFile();
                                  print(file);
                                  print(file?.paths);
                                  if (file != null) {
                                    String fileExtension =
                                        file.paths[0]?.split('.').last ?? "null";
                                    if (fileExtension == "fasta") {
                                      setState(() {
                                        fileName = file.names[0]!;
                                        isPicked = true;
                                        pickedFile = file;
                                      });
                                    }
                                  }
                                  if (isPicked == false) {
                                    SnackBar(
                                      content:
                                          Text("Something went wrong ! Try again"),
                                    );
                                  }
                                },
                                child: Container(
                                  width: screenWidth * 0.4,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black, // Outline color
                                      width: 1, // Outline width
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Upload',
                                      style: TextStyle(color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            isPicked
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Selected file:- $fileName"),
                                  )
                                : Container(),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Please select a desired size of K-mer. (Please make sure it is shorter or equal to shortest read)",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: (screenWidth * 0.5)),
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                decoration:
                                    ktextfield.copyWith(hintText: "K-mer length"),
                                onChanged: (value) {
                                  kmer_length = value;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Start Assembly",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "If things goes right, a csv will be generated which can be downloaded with some possible answers.(Max 100)",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  if (isPicked) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    var data = await func.postFile(
                                        pickedFile, kmer_length);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (!data.isEmpty) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ResultsPage(
                                                    data: data,
                                                    kmer_length: kmer_length,
                                                    fastaFile: pickedFile,
                                                  )));
                                    }
                                  }
                                },
                                child: Container(
                                  width: screenWidth * 0.4,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black, // Outline color
                                      width: 1, // Outline width
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Start !',
                                      style: TextStyle(color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Stack(
                children: [
                  // ModalBarrier prevents interaction with the underlying screen
                  ModalBarrier(
                    color: Colors.black.withOpacity(0.3),
                    dismissible: false,
                  ),
                  // ModalProgressHud shows a loading indicator
                  Center(child: loader),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
