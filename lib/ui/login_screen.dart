import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_cable_demo/data/auth_service.dart';
import 'package:network_cable_demo/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.strings,
    required this.language,
    required this.onLanguageChanged,
    required this.onLoginSuccess,
  });

  final AppStrings strings;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final VoidCallback onLoginSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;
  bool _showPassword = false;
  String _errorMessage = '';
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language != widget.language) {
      _errorMessage = '';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school_outlined,
                  size: 80,
                  color: Color(0xFF3A8F86),
                ),
                const SizedBox(height: 24),
                Text(
                  strings.appTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF3A8F86),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isRegistering ? strings.createAccount : strings.signIn,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    strings.language,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF2F5F59),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<AppLanguage>(
                    showSelectedIcon: false,
                    selected: {widget.language},
                    onSelectionChanged:
                        _isLoading
                            ? null
                            : (selection) {
                              if (selection.isNotEmpty) {
                                widget.onLanguageChanged(selection.first);
                              }
                            },
                    segments: [
                      ButtonSegment<AppLanguage>(
                        value: AppLanguage.turkish,
                        label: Text(strings.turkish),
                      ),
                      ButtonSegment<AppLanguage>(
                        value: AppLanguage.english,
                        label: Text(strings.english),
                      ),
                    ],
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      side: WidgetStateProperty.resolveWith((states) {
                        final color =
                            states.contains(WidgetState.selected)
                                ? const Color(0xFF3A8F86)
                                : const Color(0xFFCDE5DD);
                        return BorderSide(color: color);
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: strings.email,
                    hintText: strings.emailHint,
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    labelText: strings.password,
                    hintText: strings.passwordHint,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _showPassword = !_showPassword);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A8F86),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleSubmit,
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              _isRegistering
                                  ? strings.createAccount
                                  : strings.signIn,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () {
                            setState(() {
                              _isRegistering = !_isRegistering;
                              _errorMessage = '';
                              _emailController.clear();
                              _passwordController.clear();
                            });
                          },
                  child: Text(
                    _isRegistering
                        ? strings.alreadyHaveAccount
                        : strings.noAccountCreate,
                    style: const TextStyle(color: Color(0xFF3A8F86)),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _confirmAndCloseApp,
                    icon: const Icon(Icons.power_settings_new),
                    label: Text(strings.closeApp),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[700],
                      side: BorderSide(color: Colors.red[200]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAndCloseApp() async {
    final strings = widget.strings;
    final shouldClose = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(strings.closeAppTitle),
            content: Text(strings.closeAppMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(strings.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  strings.close,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (!mounted || shouldClose != true) {
      return;
    }

    await SystemNavigator.pop();
  }

  Future<void> _handleSubmit() async {
    final strings = widget.strings;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = strings.fillAllFields);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = await _getAuthService();

      if (_isRegistering) {
        final success = await authService.register(email, password);
        if (success) {
          if (!mounted) return;
          setState(() {
            _errorMessage = '';
            _isRegistering = false;
          });
          _emailController.clear();
          _passwordController.clear();

          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(strings.accountCreated)));
        } else {
          if (!mounted) return;
          setState(() => _errorMessage = strings.registerFailed);
        }
      } else {
        final success = await authService.login(email, password);
        if (success) {
          if (!mounted) return;
          widget.onLoginSuccess();
        } else {
          if (!mounted) return;
          setState(() => _errorMessage = strings.invalidLogin);
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = '${strings.errorPrefix}: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<AuthService> _getAuthService() async {
    final authService = AuthService();
    await authService.initialize();
    return authService;
  }
}
