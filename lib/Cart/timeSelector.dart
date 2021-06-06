import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';

class scheduleChoice extends StatefulWidget {
  @override
  _scheduleChoiceState createState() => _scheduleChoiceState();
}

class _scheduleChoiceState extends State<scheduleChoice> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () => setState(() => _value = !_value),
                child: Card(
                    color: _value ? Color(0xFF3B4257) : Colors.white,
                    child: Container(
                      height: 80,
                      width: 150,
                      alignment: Alignment.center,
                      margin: new EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.done,
                            color: _value ? Colors.white : Colors.grey,
                            size: 40,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Now",
                            style: TextStyle(
                                color: _value ? Colors.white : Colors.grey),
                          )
                        ],
                      ),
                    )),
              ),
              SizedBox(width: 4),
              GestureDetector(
                onTap: () => setState(() => _value = !_value),
                child: Card(
                    color: !_value ? Color(0xFF3B4257) : Colors.white,
                    child: Container(
                      height: 80,
                      width: 150,
                      alignment: Alignment.center,
                      margin: new EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.timer,
                            color: !_value ? Colors.white : Colors.grey,
                            size: 40,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Schedule",
                            style: TextStyle(
                                color: !_value ? Colors.white : Colors.grey),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
          !_value
              ? Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: Form(
                        child: TextFormField(
                          style: TextStyle(
                            color: AppTheme.dark_grey.withOpacity(0.5),
                          ),
                          decoration: new InputDecoration(
                              hintText: "Phone number",
                              prefixText: "+977 ",
                              prefixStyle:
                                  TextStyle(color: AppTheme.dark_grey)),
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("Change"),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
