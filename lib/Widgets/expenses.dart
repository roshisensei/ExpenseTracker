import 'package:expense_tracker/Widgets/chart/chart.dart';
import 'package:expense_tracker/Widgets/expenes_list/expenses_list.dart';
import 'package:expense_tracker/Widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    // dummy data
    Expense(
        title: 'flutter course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Movie',
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense Deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(onAddExpense: _addExpense);
        });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No Expenses found, Try adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter ExpenseTracker'), actions: [
        IconButton(
            onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
      ]),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
