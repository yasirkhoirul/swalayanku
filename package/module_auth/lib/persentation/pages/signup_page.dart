import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:module_auth/domain/entities/user.dart';
import 'package:module_auth/persentation/bloc/authenticating_bloc.dart';
import 'package:module_core/common/color.dart';
import 'package:module_core/common/logo.dart';
import 'package:module_core/module_core.dart';
import 'package:module_core/widget/layout_background.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});
  
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
        actions: [
          ElevatedButton(onPressed: (){
            context.go('/login');
          }, child: Text("Login"))
        ],
      ),
      body: LayoutBackground(widget: SingleChildScrollView(child: FormSignup())),
    );
  }
}

class FormSignup extends StatefulWidget {
  const FormSignup({super.key});

  @override
  State<FormSignup> createState() => _FormSignupState();
}

class _FormSignupState extends State<FormSignup> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            judul: Text("Daftar Akun Baru"),
            content: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 10),
              physics: NeverScrollableScrollPhysics(),
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _TextInput(
                    label: 'Nama Lengkap',
                    controller: _namaController,
                    icon: Icon(Icons.person_outline),
                    isHidden: false,
                    validator: _validator,
                  );
                } else if (index == 1) {
                  return _TextInput(
                    label: 'Email',
                    controller: _emailController,
                    icon: Icon(Icons.email_outlined),
                    isHidden: false,
                    validator: _emailValidator,
                  );
                } else if (index == 2) {
                  return _TextInput(
                    label: 'Password',
                    controller: _passwordController,
                    icon: Icon(Icons.lock_outline),
                    isHidden: true,
                    validator: _passwordValidator,
                  );
                } else {
                  return _TextInput(
                    label: 'Konfirmasi Password',
                    controller: _confirmPasswordController,
                    icon: Icon(Icons.lock),
                    isHidden: true,
                    validator: _confirmPasswordValidator,
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
                    listener: (context, state) async {
                      if (state is AuthenticatingSucces) {
                        final userInfo = state.userInfo;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Berhasil Daftar sebagai ${userInfo.nama} (${userInfo.role})"),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Tunggu snackbar tampil sebelum navigasi
                        await Future.delayed(Duration(milliseconds: 500));
                      }
                    },
                    builder: (context, state) {
                      
                      if (state is AuthenticatingLoading) {
                        return Center(child: CircularProgressIndicator(),);
                      }
                      if(state is AuthenticatingError){
                        return Column(
                          children: [
                            Text(
                              state.message,
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: (){
                                context.read<AuthenticatingBloc>().add(AuthOnRetry());
                              }, 
                              child: Text("Coba Lagi")
                            )
                          ],
                        );
                      }
                      return MyButton(
                        child: Text("Daftar"),
                        ontap: () {
                          if (_formkey.currentState!.validate()) {
                            final UserSignup userSignup = UserSignup(
                              email: _emailController.text,
                              password: _passwordController.text,
                              nama: _namaController.text,
                              role: 'user',
                            );
                            context.read<AuthenticatingBloc>().add(
                              AuthOnSignup(userSignup),
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

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email tidak boleh kosong";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Format email tidak valid";
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Password tidak boleh kosong";
    }
    if (value.length < 6) {
      return "Password minimal 6 karakter";
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Konfirmasi password tidak boleh kosong";
    }
    if (value != _passwordController.text) {
      return "Password tidak sama";
    }
    return null;
  }
}

class _TextInput extends StatelessWidget {
  final String? Function(String?) validator;
  final String label;
  final TextEditingController controller;
  final bool isHidden;
  final Icon icon;
  
  const _TextInput({
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
