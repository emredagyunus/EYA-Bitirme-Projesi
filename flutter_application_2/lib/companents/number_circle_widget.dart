import 'package:flutter/material.dart';

class NumberCircleContainer extends StatelessWidget {
  final Color? backgroundColor1;
  final Color? backgroundColor2;
  final Color? lineColor1;
  final Color? lineColor2;


  const NumberCircleContainer({
    super.key,
    this.lineColor1,
    this.lineColor2,
    this.backgroundColor1,
    this.backgroundColor2,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor:
                backgroundColor1 != null ? backgroundColor1 : Colors.white,
            child: Text(
              '1',
              style: TextStyle(
                  color: lineColor1 != null ? lineColor1 : Colors.deepPurple),
            ),
          ),
          SizedBox(width: 10.0),
          CircleAvatar(
            backgroundColor:
                backgroundColor2 != null ? backgroundColor2 : Colors.white,
            child: Text(
              '2',
              style: TextStyle(
                  color: lineColor2 != null ? lineColor2 : Colors.deepPurple),
            ),
          ),
         
        ],
      ),
    );
  }
}
