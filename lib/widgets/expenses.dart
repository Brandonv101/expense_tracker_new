import 'package:expense_tracker_new/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker_new/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker_new/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    int expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Expense Removed'),
          action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _registeredExpenses.insert(expenseIndex, expense);
                });
              })),
    );
  }

  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Cheeseburger',
        amount: 11.99,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Movie Ticket',
        amount: 18.99,
        date: DateTime.now(),
        category: Category.leisure),
  ];
  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No ExpensesFound. Click + to add'),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Text("Chart"), //Put chart here
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
