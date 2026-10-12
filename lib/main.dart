import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _c1 = TextEditingController();
  final TextEditingController _c2 = TextEditingController();

  String? _op; // phép toán đang chọn: + - * /
  String _result = ''; // kết quả hiển thị

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    super.dispose();
  }

  // Tính toán và cập nhật _result
  void _calculate() {
    if (_op == null) {
      _result = '';
      return;
    }

    final a = double.tryParse(_c1.text.trim());
    final b = double.tryParse(_c2.text.trim());

    if (a == null || b == null) {
      _result = 'Vui lòng nhập số hợp lệ';
      return;
    }

    double r;
    switch (_op) {
      case '+':
        r = a + b;
        break;
      case '-':
        r = a - b;
        break;
      case '*':
        r = a * b;
        break;
      case '/':
        if (b == 0) {
          _result = 'Không thể chia cho 0';
          return;
        }
        r = a / b;
        break;
      default:
        _result = '';
        return;
    }

    // Số nguyên thì bỏ phần thập phân (8.0 -> 8)
    _result = r == r.truncateToDouble() ? r.toInt().toString() : r.toString();
  }

  void _selectOp(String op) {
    setState(() {
      _op = op;
      _calculate();
    });
  }

  Widget _opButton(String symbol, Color color) {
    final selected = _op == symbol;
    return GestureDetector(
      onTap: () => _selectOp(symbol),
      child: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.black : Colors.transparent,
            width: 3,
          ),
        ),
        child: Text(
          symbol,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Center(
                child: Text(
                  'Thực hành 03',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 60),

              // Ô nhập số thứ nhất
              TextField(
                controller: _c1,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                decoration: _inputDecoration('Nhập số thứ nhất'),
                onChanged: (_) => setState(_calculate),
              ),
              const SizedBox(height: 24),

              // 4 nút phép toán
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _opButton('+', const Color(0xFFE04848)),
                  _opButton('-', const Color(0xFFE0A93E)),
                  _opButton('*', const Color(0xFF5B3FE0)),
                  _opButton('/', const Color(0xFF1E1E1E)),
                ],
              ),
              const SizedBox(height: 24),

              // Ô nhập số thứ hai
              TextField(
                controller: _c2,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                decoration: _inputDecoration('Nhập số thứ hai'),
                onChanged: (_) => setState(_calculate),
              ),
              const SizedBox(height: 16),

              // Kết quả
              Text(
                'Kết quả: $_result',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}