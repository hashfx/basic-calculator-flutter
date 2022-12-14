import 'package:calculator_flutter/riverpod.dart';
import 'package:calculator_flutter/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:calculator_flutter/colors.dart';
import 'package:calculator_flutter/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as prv;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final String title = 'CalSee';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(title: title),
    );
  }
}

class MainPage extends StatefulWidget {
  final String title;
  const MainPage({Key? key, required this.title}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Container(
            margin: EdgeInsets.only(left: 8),
            child: Text(widget.title),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: buildResult()),
              Expanded(flex: 2, child: buildButtons())
            ],
          ),
        ),
      );

  Widget buildResult() => prv.Consumer(
          // update equation and result UI w.r.t. user input
          builder: ((context, WidgetRef ref, child) {
        final state = ref.watch(calculatorProvider);
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // displays equation
              Text(
                state.equation,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 36, height: 1),
              ),
              const SizedBox(height: 24),
              // displays result
              Text(
                state.result,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ],
          ),
        );
      }));

  Widget buildButtons() => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MyColors.background2,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: <Widget>[
            buildButtonRow('AC', '<', '', '??'),
            buildButtonRow('7', '8', '9', 'x'),
            buildButtonRow('4', '5', '6', '-'),
            buildButtonRow('1', '2', '3', '+'),
            buildButtonRow('0', '.', '', '='),
          ],
        ),
      );

  Widget buildButtonRow(
    String first,
    String second,
    String third,
    String fourth,
  ) {
    final row = [first, second, third, fourth];

    return Expanded(
      child: Row(
        children: row
            .map((text) => ButtonWidget(
                  text: text,
                  onClicked: () => onClickedButton(text),
                  onClickedLong: () => onLongClickedButton(text),
                ))
            .toList(),
      ),
    );
  }

  void onClickedButton(String buttonText) {
    final calculator = context.watch(calculatorProvider);

    // calculator.append(buttonText);

    switch (buttonText) {
      // reset screen
      case 'AC':
        calculator.reset();
        break;
      // evaluate expression
      case '=':
        calculator.equals();
        break;
      // clear backspace
      case '<':
        calculator.delete();
        break;
      default:
        calculator.append(buttonText); // append to previous text
        break;
    }
  }

  // on long press, acts like AC button
  void onLongClickedButton(String text) {
    // reference to calculator programme
    final calculator = context.read();

    // check if clicked text is <
    if (text == '<') {
      calculator.reset();
    }
  }
}
