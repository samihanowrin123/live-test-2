import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool('isDark') ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = !_isDark;
      prefs.setBool('isDark', _isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      debugShowCheckedModeBanner: false,
      theme: _isDark ? ThemeData.dark() : ThemeData.light(),
      home: CalculatorPage(toggleTheme: _toggleTheme, isDark: _isDark),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const CalculatorPage({Key? key, required this.toggleTheme, required this.isDark}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '';

  final List<String> buttons = [
    'AC', '÷', '×', '⌫',
    '7', '8', '9', '−',
    '4', '5', '6', '+',
    '1', '2', '3', '=',
    '0', '.', 
  ];

  bool _isOperator(String x) {
    return ['+', '−', '×', '÷'].contains(x);
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _expression = '';
        _result = '';
      } else if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (value == '=') {
        _calculate();
      } else {
        // Prevent invalid operator input
        if (_expression.isNotEmpty) {
          String lastChar = _expression[_expression.length - 1];
          if (_isOperator(value) && _isOperator(lastChar)) {
            _expression = _expression.substring(0, _expression.length - 1) + value;
            return;
          }
        } else if (_isOperator(value)) {
          return;
        }
        _expression += value;
      }
    });
  }

  void _calculate() {
    try {
      String finalExp = _expression.replaceAll('×', '*').replaceAll('÷', '/').replaceAll('−', '-');
      Parser p = Parser();
      Expression exp = p.parse(finalExp);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      _result = eval.toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 2);
    } catch (e) {
      _result = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.grey[200],
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(fontSize: 30, color: widget.isDark ? Colors.white70 : Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _result,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: widget.isDark ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: widget.isDark ? Colors.grey[900] : Colors.white,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final button = buttons[index];
                final isOperatorBtn = _isOperator(button) || button == '=';

                return GestureDetector(
                  onTap: () => _onButtonPressed(button),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isOperatorBtn
                          ? Colors.orangeAccent
                          : widget.isDark ? Colors.grey[800] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        button,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: isOperatorBtn ? Colors.white : (widget.isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
