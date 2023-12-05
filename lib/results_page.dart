import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:genome_assembly/accuracy_results.dart';
import 'networking.dart';

class ResultsPage extends StatefulWidget {
  ResultsPage(
      {required this.data, required this.kmer_length, required this.fastaFile});

  var data;
  String kmer_length;
  FilePickerResult fastaFile;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool _isLoading = false;
  String fileName = "";
  String match_score = "";
  String mismatch_penalty = "";
  String gap_penalty = "";
  bool isPicked = false;
  late FilePickerResult pickedFile;

  TextStyle kstyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);

  Future<FilePickerResult?> _pickKeyFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          allowCompression: false,
          withData: true,
          lockParentWindow: true,
          allowMultiple: false);
      return result;
    } catch (e) {
      print('Error picking Key file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    print(widget.data[0].length);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF006663), Color(0xFF111111)]),
              ),
              child: ListView(children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Results",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Min. Len.",
                                  style: kstyle,
                                ),
                                Text(
                                  widget.data[1].toString(),
                                  style: kstyle,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Max. Len.",
                                  style: kstyle,
                                ),
                                Text(
                                  widget.data[2].toString(),
                                  style: kstyle,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Avg. Len.",
                                  style: kstyle,
                                ),
                                Text(
                                  widget.data[3].toString(),
                                  style: kstyle,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Total No. of Results :- ${widget.data[0].length.toString()}",
                        style: kstyle,
                      ),
                      Text(
                        "You can download all the results in an csv file by clicking on the below download button",
                        style: kstyle,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: (screenWidth * 0.3)),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          decoration: ktextfield.copyWith(
                              hintText: "File name to save"),
                          onChanged: (value) {
                            fileName = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            bool success = await func.save_data(widget.data,
                                fileName == "" ? "Genome" : fileName);
                            setState(() {
                              _isLoading = false;
                            });
                            print(success);
                          },
                          child: Container(
                            width: screenWidth * 0.6,
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
                                'Download',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Accuracy",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "You can also check the accuracy of the formed genomes against some key",
                        style: kstyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            FilePickerResult? file = await _pickKeyFile();
                            print(file);
                            print(file?.paths);
                            if (file != null) {
                              String fileExtension =
                                  file.paths[0]?.split('.').last ?? "null";
                              if (fileExtension == "txt") {
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
                            width: screenWidth * 0.6,
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
                                'Upload Key',
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
                        height: 10,
                      ),
                      Text(
                        "We use global alignment to find accuracy, inorder to find global alignment score, please input the score matrix values :- ",
                        style: kstyle,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Match Score :- ",
                        style: kstyle,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: (screenWidth * 0.5)),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          decoration:
                              ktextfield.copyWith(hintText: "Match Score"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            match_score = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Mismatch Penalty :- ",
                        style: kstyle,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: (screenWidth * 0.5)),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          decoration:
                              ktextfield.copyWith(hintText: "Mismatch Penalty"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            mismatch_penalty = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Gap Penalty:- ",
                        style: kstyle,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: (screenWidth * 0.5)),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          decoration:
                              ktextfield.copyWith(hintText: "Gap Penalty"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            gap_penalty = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            if (isPicked) {
                              setState(() {
                                _isLoading = true;
                              });
                              var data = await func.postKeyFile(
                                  pickedFile,
                                  match_score,
                                  mismatch_penalty,
                                  gap_penalty,
                                  widget.data[0]);
                              setState(() {
                                _isLoading = false;
                              });
                              print(data);
                              if (!data.isEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AccuracyResults(
                                      data: data,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            width: screenWidth * 0.6,
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
                                'Test Accuracy !',
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
              ]),
            ),
            if (_isLoading)
              Stack(
                children: [
                  // ModalBarrier prevents interaction with the underlying screen
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: screenHeight
                    ),
                    child: ModalBarrier(
                      color: Colors.black.withOpacity(0.3),
                      dismissible: false,
                    ),
                  ),
                  // ModalProgressHud shows a loading indicator
                  const Center(child: loader),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
