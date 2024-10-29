import 'package:flutter/material.dart';

class AppLifecycleDisplay extends StatefulWidget {
  const AppLifecycleDisplay({super.key});

  @override
  State<AppLifecycleDisplay> createState() => _AppLifecycleDisplayState();
}

class _AppLifecycleDisplayState extends State<AppLifecycleDisplay> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final List<String> _states = <String>[];
  AppLifecycleState? _state;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _state = WidgetsBinding.instance.lifecycleState; // Get initial state
    if (_state != null) {
      _states.add(_state!.name);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  //checking if lifecycle has changed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _handleStateChange(state);
    _handleTransition(state.name);
  }

  void _handleTransition(String name) {
    setState(() {
      _states.add(name);
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _handleStateChange(AppLifecycleState state) {
    setState(() {
      _state = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('App Lifecycle State'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                Text('Current State: ${_state ?? 'Not initialized yet'}'),
                const SizedBox(height: 30),
                Text('State History:\n  ${_states.join('\n  ')}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
