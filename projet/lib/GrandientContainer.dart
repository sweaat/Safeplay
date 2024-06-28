import 'package:flutter/material.dart';
import 'CustomText.dart';

class GradientContainer extends StatelessWidget{
  const GradientContainer({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors:[
                Color.fromARGB(255, 24, 25, 166),
                Color.fromARGB(255, 24, 112, 166)
              ]
          )
      ),
      child: const Center(
          child: CustomText()
      ),
    );
  }
}