import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:module_auth/domain/entities/user.dart';
import 'package:module_auth/persentation/bloc/authenticating_bloc.dart';
import 'package:module_core/common/color.dart';
import 'package:module_core/common/logo.dart';
import 'package:module_core/module_core.dart';
import 'package:module_core/widget/layout_background.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        elevation: 20,
        shadowColor: Colors.black,
        backgroundColor: MyColor.hijau,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(Mylogo.logo),
        ),
      ),
      body: LayoutBackground(widget: SingleChildScrollView(child: FormLogin())),
    );
  }
}

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _ur = TextEditingController();
  final TextEditingController _pw = TextEditingController();

  @override
  void dispose() {
    _ur.dispose();
    _pw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formkey,
        child: SizedBox(
          width: 600,

          child: MyCardDialog(
            logo: SvgPicture.asset(
              Mylogo.logo,
              colorFilter: ColorFilter.mode(MyColor.hijau, BlendMode.srcIn),
            ),
            judul: Text("Silahkan Masuk Sebagai Admin"),
            content: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 10),
              physics: NeverScrollableScrollPhysics(),
              itemCount: 2,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return TextInput(
                    label: 'Username',
                    controller: _ur,
                    icon: Icon(Icons.person),
                    isHidden: false,
                    validator: _validator,
                  );
                } else {
                  return TextInput(
                    label: "Password",
                    controller: _pw,
                    icon: Icon(Icons.lock),
                    isHidden: true,
                    validator: _validator,
                  );
                }
              },
            ),
            contentBottom: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 10),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) =>
                  BlocConsumer<AuthenticatingBloc, AuthenticatingState>(
                    listener: (context, state) {
                      if (state is AuthenticatingSucces) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Berhasil Login")),
                        );
                      }
                    },
                    builder: (context, state) {
                      
                      if (state is AuthenticatingLoading) {
                        return Center(child: CircularProgressIndicator(),);
                      }
                      if(state is AuthenticatingError){
                        return Column(
                          children: [
                            Text(state.message),
                            ElevatedButton(onPressed: (){
                              context.read<AuthenticatingBloc>().add(AuthOnRetry());
                            }, child: Text("ReTry"))
                          ],
                        );
                      }
                      return MyButton(
                        child: Text("Login"),
                        ontap: () {
                          if (_formkey.currentState!.validate()) {
                            
                            final User user = User(_ur.text, _pw.text);
                            context.read<AuthenticatingBloc>().add(
                              AuthOnSubmit(user),
                            );
                          }
                        },
                      );
                    },
                  ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Kolom ini tidak boleh kosong";
    }
    return null;
  }
}

class TextInput extends StatelessWidget {
  final String? Function(String?) validator;
  final String label;
  final TextEditingController controller;
  final bool isHidden;
  final Icon icon;
  const TextInput({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.isHidden,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        label: Text(label),
        icon: icon,
      ),
      obscureText: isHidden,
    );
  }
}
