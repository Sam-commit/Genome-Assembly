import 'package:flutter/material.dart';
import 'package:genome_assembly/data_loading_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF006663), Color(0xFF111111)]),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Genome Assembler",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Image.asset(
                      "assets/image.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  const Text(
                    "In bioinformatics, sequence assembly refers to aligning and merging fragments from a longer DNA sequence in order to reconstruct the original sequence.",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20,),
                  const Text(
                    "Requirements : ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,size: 15,),
                      SizedBox(width: 10,),
                      Text("Fasta file containing reads",style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,size: 15,),
                      SizedBox(width: 10,),
                      Text("Length of desired k-mers",style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,size: 15,),
                      SizedBox(width: 10,),
                      Expanded(child: Text("Existing key if want to calculate accuracy against some existing genome",style: TextStyle(fontSize: 20))),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DataLoadingPage()));
                    },
                    child: const Text("Let's Start",style: TextStyle(color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(width: 2,color:Color(0xFF006663) ),
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(150,42)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
