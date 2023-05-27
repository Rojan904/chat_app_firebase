import 'package:chat_app/bloc_switch/auth/login/bloc/login_bloc.dart';
import 'package:chat_app/bloc_switch/auth/login/bloc/pages/login_page.dart';
import 'package:chat_app/bloc_switch/auth/register/bloc/register_bloc.dart';
import 'package:chat_app/bloc_switch/auth_bloc/auth_bloc_bloc.dart';
import 'package:chat_app/bloc_switch/core/network/cubit/internet_cubit.dart';
import 'package:chat_app/bloc_switch/presentation/chat/bloc/chat_bloc.dart';
import 'package:chat_app/bloc_switch/presentation/group_info/bloc/group_info_bloc.dart';
import 'package:chat_app/bloc_switch/presentation/home/bloc/home_bloc.dart';
import 'package:chat_app/bloc_switch/presentation/home/page/home.dart';
import 'package:chat_app/bloc_switch/presentation/intro/intro_screen.dart';
import 'package:chat_app/bloc_switch/presentation/search/cubit/search_cubit.dart';
import 'package:chat_app/bloc_switch/repository/repository.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_switch/presentation/search/bloc/search_bloc.dart';

void main() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  Connectivity connectivity = Connectivity();
  final userRepository = UserRepositories();
  @override
  void initState() {
    getUserLoggedInStatus();
    super.initState();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthBlocBloc(userRepository);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(authBloc)),
        BlocProvider(create: (_) => RegisterBloc()),
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(create: (_) => ApiBloc()),
        BlocProvider(create: (_) => SearchBloc()),
        BlocProvider(create: (_) => SearchCubit()),
        BlocProvider(create: (_) => GroupInfoBloc()),
        BlocProvider(create: (_) => ChatBloc()),
        BlocProvider(
            create: (_) => AuthBlocBloc(userRepository)..add(AppStarted())),
        BlocProvider(create: (_) => InternetCubit(connectivity: connectivity)),
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Constants.primaryColor,
            scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        // home: isLoggedIn ? const HomePage2() : const LoginPage2(),
        home: IntroScreen(userRepositories: userRepository),
        // home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        //   builder: (context, state) {
        //     if (state is AuthenticationAuthenticated) {
        //       return MainScreen();
        //     }
        //     if (state is AuthenticationUnauthenticated) {
        //       return IntroPage(userRepository: userRepository);
        //     }
        //     if (state is AuthenticationLoading) {
        //       return Scaffold(
        //         body: Container(
        //           color: Colors.white,
        //           width: MediaQuery.of(context).size.width,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: <Widget>[
        //               SizedBox(
        //                 height: 25.0,
        //                 width: 25.0,
        //                 child: CircularProgressIndicator(
        //                   valueColor: new AlwaysStoppedAnimation<Color>(
        //                       Style.Colors.mainColor),
        //                   strokeWidth: 4.0,
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //       );
        //     }
        //     return Scaffold(
        //       body: Container(
        //         color: Colors.white,
        //         width: MediaQuery.of(context).size.width,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: <Widget>[
        //             SizedBox(
        //               height: 25.0,
        //               width: 25.0,
        //               child: CircularProgressIndicator(
        //                 valueColor: new AlwaysStoppedAnimation<Color>(
        //                     Style.Colors.mainColor),
        //                 strokeWidth: 4.0,
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
