import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double blurr = 20;
  double opacity = 0.6;
  bool failedAuth = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.8;
    return MaterialApp(
      home: SecureApplication(
        onNeedUnlock: (secure) async {
          print(
              'ロックを解除する必要がある場合は、バイオメトリックを使用して確認し、sercure.unlock()を使用するか、lockedBuilderを使用することができます');
          // var authResult = authMyUser();
          // if (authResul) {
          //  secure.unlock();
          //  return SecureApplicationAuthenticationStatus.SUCCESS;
          //}
          // else {
          //  return SecureApplicationAuthenticationStatus.FAILED;
          //}
          return null;
        },
        onAuthenticationFailed: () async {
          // clean you data
          setState(() {
            failedAuth = true;
          });
          print('auth failed');
        },
        onAuthenticationSucceed: () async {
          // clean you data

          setState(() {
            failedAuth = false;
          });
          print('auth success');
        },
        child: SecureGate(
          blurr: blurr,
          opacity: opacity,
          lockedBuilder: (context, secureNotifier) => Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Text('UNLOCK'),
                onPressed: () => secureNotifier!.authSuccess(unlock: true),
              ),
              ElevatedButton(
                child: const Text('FAIL AUTHENTICATION'),
                onPressed: () => secureNotifier!.authFailed(unlock: false),
              ),
            ],
          )),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Secure Application Demo'),
            ),
            body: Center(
              child: Builder(builder: (context) {
                var valueNotifier = SecureApplicationProvider.of(context);
                return ListView(
                  children: [
                    ElevatedButton(
                      onPressed: () => valueNotifier!.secure(),
                      child: const Text('Secure'),
                    ),
                    ElevatedButton(
                      onPressed: () => valueNotifier!.open(),
                      child: const Text('Open'),
                    ),
                    FlutterLogo(
                      size: width,
                    ),
                    ElevatedButton(
                      onPressed: () => valueNotifier!.lock(),
                      child: const Text('Manually Lock'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          const Text('Blurr:'),
                          Expanded(
                            child: Slider(
                                value: blurr,
                                min: 0,
                                max: 100,
                                onChanged: (v) => setState(() => blurr = v)),
                          ),
                          Text(blurr.floor().toString()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          const Text('opacity:'),
                          Expanded(
                            child: Slider(
                                value: opacity,
                                min: 0,
                                max: 1,
                                onChanged: (v) => setState(() => opacity = v)),
                          ),
                          Text("${(opacity * 100).floor()}%"),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
