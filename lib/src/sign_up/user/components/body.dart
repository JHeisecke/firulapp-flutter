import 'package:flutter/material.dart';

import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/size_config.dart';
import 'sign_up_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sizeConfig.wp(4.5)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: sizeConfig.hp(4)), // 4%
                Text("Registrar Cuenta", style: Constants.headingStyle),
                Text("Complete sus datos",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: sizeConfig.wp(4),
                    )),
                SizedBox(height: sizeConfig.hp(6)),
                SignUpForm(),
                SizedBox(height: sizeConfig.hp(5)),
                Text(
                  'Al continuar, confirma que está de acuerdo \ncon nuestros Términos y condiciónes',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: sizeConfig.hp(1.7)),
                ),
                SizedBox(height: sizeConfig.hp(2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
