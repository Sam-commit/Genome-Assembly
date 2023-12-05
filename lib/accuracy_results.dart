import 'package:flutter/material.dart';
import 'package:genome_assembly/networking.dart';

class AccuracyResults extends StatefulWidget {
  AccuracyResults({required this.data});
  var data;

  @override
  State<AccuracyResults> createState() => _AccuracyResultsState();
}

class _AccuracyResultsState extends State<AccuracyResults> {
  bool _isLoading = false;
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Accuracy Results",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 30),),
                    SizedBox(height: 20,),
                    Text("Best Seq. Score:- ${widget.data["accuracy"].toString()}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                    SizedBox(height: 10,),
                    Text("Best Seq. Length:- ${widget.data["best"].length.toString()}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                    SizedBox(height: 10,),
                    Text("Best Seq. No. of Mismatches:- ${widget.data["mismatch"]}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                    SizedBox(height: 10,),
                    Text("Best Seq. No. of Gaps:- ${widget.data["gap"]}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                    SizedBox(height: 20,),
                    Text("To download the best sequence formed, Click below",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                    SizedBox(height: 10,),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          showDialog(context: context, builder: (context) => AlertDialog(
                            title: Text("Enter File Name"),
                            content: TextField(
                              controller: _textEditingController,
                              decoration: ktextfield.copyWith(
                                  hintText: "Type Something ..."),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    String fileName =
                                        _textEditingController.text;
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    bool success = await func.save_data_best(
                                        widget.data,
                                        fileName == "" ? "Best" : fileName);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.of(context).pop();
                                    print(success);
                                  },
                                  child: Text("Save")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"))
                            ],
                          ));

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
                              'Download Best Seq.',
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                        "To download the score of all sequences formed, Click below",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                    SizedBox(height: 10,),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          showDialog(context: context, builder: (context)=>AlertDialog(
                            title: Text("Enter File Name"),
                            content: TextField(
                              controller: _textEditingController,
                              decoration: ktextfield.copyWith(
                                  hintText: "Type Something ..."),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    String fileName =
                                        _textEditingController.text;
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    bool success = await func.save_data_all(
                                        widget.data["allResults"],
                                        fileName == "" ? "All" : fileName);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.of(context).pop();
                                    print(success);
                                  },
                                  child: Text("Save")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"))
                            ],
                          ));

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
                              'Download All',
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
                  const Center(child: loader),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
