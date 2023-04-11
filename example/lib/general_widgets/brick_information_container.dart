import 'package:flutter/material.dart';

import 'stylized_container.dart';

class BrickContainer extends StatefulWidget{
  final String headLine;
  final Icon icon;
  String mainData;
  int lastUpdate;
  final Function() onClick;
  BrickContainer({super.key, required this.headLine, required this.icon,
  required this.mainData, required this.lastUpdate, required this.onClick,});

  @override
  State<BrickContainer> createState() => _BrickContainerState();

}

class _BrickContainerState extends State<BrickContainer>{
  @override
  Widget build(BuildContext context) =>
  StylizedContainer(alignment: Alignment.center,
  width: 100 ,height: 100, child: _BrickInformation(),);

}

class _BrickInformation extends StatefulWidget{


  @override
  State<_BrickInformation> createState() => _BrickInformationState();

}

class _BrickInformationState extends State<_BrickInformation>{
  @override
  Widget build(BuildContext context)
    => Column(children: const [
       Text("Test"),
    ],)
  ;


}