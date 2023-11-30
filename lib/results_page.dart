import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'networking.dart';

class ResultsPage extends StatefulWidget {
  ResultsPage({required this.data});

  var data;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool _isLoading = false;
  String fileName = "";

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
                    colors: [Colors.blue, Colors.deepPurple]),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Results"),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [Text("Min. Len."), Text(widget.data[1])],
                          ),
                          Column(
                            children: [Text("Max. Len."), Text(widget.data[2])],
                          ),
                          Column(
                            children: [Text("Avg. Len."), Text(widget.data[3])],
                          ),
                        ],
                      ),
                    ),
                    Text("Total No. of Results :- ${widget.data[0].length}"),
                    Text(
                        "You can download all the results in an csv file by clicking on the below download button"),
                    Padding(
                      padding: EdgeInsets.only(right: (screenWidth * 0.7)),
                      child: TextField(
                        decoration:
                            ktextfield.copyWith(hintText: "File name to save"),
                        onChanged: (value) {
                          fileName = value;
                        },
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          bool success = await func.save_data(
                              widget.data, fileName == "" ? "Genome" : fileName);
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
                    Text("Accuracy"),
                    Text("You can also check the accuracy of the formed genomes against some key"),

                  ],
                ),
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
                  Center(
                    child: SpinKitWanderingCubes(
                      color: Colors.green,
                      size: 70.0,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
