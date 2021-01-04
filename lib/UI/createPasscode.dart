import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pos_app/UI/MasterPanel.dart';
import 'package:pos_app/Utils/utils.dart';

class createPasscode extends StatefulWidget{

  _createPasscode createState()=>_createPasscode();
}
class _createPasscode extends State{
TextEditingController _pinVerificationController;
bool ispinentered=false;
bool showreEnteredpin=false;
String firstPin;
String secondPin;
TextEditingController _reEnterPinVerificationController;
@override
  void initState() {
    // TODO: implement initState
    super.initState();

_pinVerificationController=TextEditingController();
_reEnterPinVerificationController=TextEditingController();
}
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text("PassCode"),backgroundColor: utils.getColorFromHex("#CC1313"),),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
Container(
  alignment: Alignment.center,
  child: Text(!showreEnteredpin?"Enter New PassCode":"Enter Confirm PassCode ",style: TextStyle(color: Colors.black,fontSize: 16),),
  
),
            
            
            Container(
              width: MediaQuery.of(context).size.width/2,
                 alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10, left: 0),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,

                      ),
                      length: 6,
                      obscureText: false,

                      controller:(!showreEnteredpin)? _pinVerificationController:_reEnterPinVerificationController,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 60,
                          fieldWidth: 50,
                          activeFillColor: Colors.white,
                          inactiveFillColor:Colors.grey.shade100,
                          selectedFillColor: Colors.grey.shade200,
                          selectedColor: Colors.red,
                          activeColor: Colors.black.withOpacity(0.3),
                          inactiveColor: Colors.black.withOpacity(0.3)

                      ),

                      cursorColor: Colors.black,
                      textStyle: TextStyle(fontSize: 20, height: 1.6),
                      backgroundColor: Colors.blue.shade50,
                      enableActiveFill: true,
                      enablePinAutofill: true,
                      keyboardType: TextInputType.number,

                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )

                      ],




                    )

                )
            ),

            Container(
              margin:
              const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 30),
              child: ButtonTheme(
                height: 50,
                child: FlatButton(
                  onPressed: () {
                     if(!showreEnteredpin){

                       setState(() {
                         showreEnteredpin=true;
                        ispinentered=false;

                       });

                     }else{

                       if(_pinVerificationController.text.contains(_reEnterPinVerificationController.text)){

                         FirebaseFirestore.instance.collection("passCode").add({
                           "code":_pinVerificationController.text,
                           "createdTime":DateTime.now(),
                           "lastTimeLogin":DateTime.now()
                         }).then((value) =>Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>MasterPanel())) );


                       }else{
                         Fluttertoast.showToast(
                             msg: "PassCode are not the same .",
                             toastLength: Toast.LENGTH_SHORT,
                             gravity: ToastGravity.CENTER,
                             timeInSecForIosWeb: 1,
                             backgroundColor: utils.getColorFromHex("#CB0000"),
                             textColor: Colors.white,
                             fontSize: 16.0);
                         setState(() {
                           ispinentered=false;
                           showreEnteredpin=false;
                         });

                       }
                     }

                    },

                  child: Center(
                      child: Text(
                        (!showreEnteredpin)?"Next":"Register",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              decoration: BoxDecoration(
                  color: (ispinentered)?utils.getColorFromHex("#CB0000"):Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
//                  boxShadow: [
//                    BoxShadow(
//                        color: Colors.green.shade200,
//                        offset: Offset(1, -2),
//                        blurRadius: 5),
//                    BoxShadow(
//                        color: Colors.green.shade200,
//                        offset: Offset(-1, 2),
//                        blurRadius: 5)
//                  ]),
            )),


          ],



        ),



      ),

    );
  }
}