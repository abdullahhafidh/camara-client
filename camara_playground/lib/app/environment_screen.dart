import 'package:camara_playground/core/config/environment.dart';
import 'package:camara_playground/core/config/environment_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentScreen extends ConsumerStatefulWidget {
  const EnvironmentScreen({super.key});

  @override
  ConsumerState<EnvironmentScreen> createState() => _EnvironmentScreenState();
}

class _EnvironmentScreenState extends ConsumerState<EnvironmentScreen> {
  late final TextEditingController _authorizeUrlController;
  late final TextEditingController _tokenValidateUrlController;
  late final TextEditingController _verifyMsisdnUrlController;
  late final TextEditingController _clientIdController;
  late final TextEditingController _redirectUriController;
  late final TextEditingController _scopesController;
  late final TextEditingController _apiKeyController;
  late final TextEditingController _labelController;

  // Controls how the redirect URI is selected: either the built-in default
  // from the IOH sandbox configuration, or a manually entered custom value.
  late String _redirectPreset;

  static const _redirectPresetDefault = 'default';
  static const _redirectPresetCustom = 'custom';

  @override
  void initState() {
    super.initState();
    final state = ref.read(environmentManagerProvider);
    final env = state.current.environment;

    _authorizeUrlController = TextEditingController(text: env.authorizeUrl);
    _tokenValidateUrlController =
        TextEditingController(text: env.tokenValidateUrl);
    _verifyMsisdnUrlController =
        TextEditingController(text: env.verifyMsisdnUrl);
    _clientIdController = TextEditingController(text: env.clientId);
    _redirectUriController = TextEditingController(text: env.redirectUri);
    _scopesController = TextEditingController(text: env.scopes.join(' '));
    _apiKeyController = TextEditingController(text: env.apiKey);
    _labelController = TextEditingController(
      text: state.current.label,
    );

    final defaultRedirect = EnvironmentConfig.iohSandbox().environment.redirectUri;
    _redirectPreset = env.redirectUri == defaultRedirect
        ? _redirectPresetDefault
        : _redirectPresetCustom;
  }

  @override
  void dispose() {
    _authorizeUrlController.dispose();
    _tokenValidateUrlController.dispose();
    _verifyMsisdnUrlController.dispose();
    _clientIdController.dispose();
    _redirectUriController.dispose();
    _scopesController.dispose();
    _apiKeyController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(environmentManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Environment'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current (v${state.current.version}): ${state.current.label}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        TextField(
                          controller: _labelController,
                          decoration: const InputDecoration(
                            labelText: 'Label',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _authorizeUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Authorize URL',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _tokenValidateUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Token validate URL',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _verifyMsisdnUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Verify MSISDN URL',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _clientIdController,
                          decoration: const InputDecoration(
                            labelText: 'Client ID',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _redirectPreset,
                                decoration: const InputDecoration(
                                  labelText: 'Redirect URI preset',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: _redirectPresetDefault,
                                    child: Text('Default (IOH Sandbox)'),
                                  ),
                                  DropdownMenuItem(
                                    value: _redirectPresetCustom,
                                    child: Text('Custom'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() {
                                    _redirectPreset = value;
                                    if (value == _redirectPresetDefault) {
                                      _redirectUriController.text =
                                          EnvironmentConfig.iohSandbox()
                                              .environment
                                              .redirectUri;
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _redirectUriController,
                          enabled: _redirectPreset == _redirectPresetCustom,
                          decoration: const InputDecoration(
                            labelText: 'Redirect URI (custom)',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _scopesController,
                          decoration: const InputDecoration(
                            labelText: 'Scopes (space-separated)',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _apiKeyController,
                          decoration: const InputDecoration(
                            labelText: 'API key',
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final env = Environment(
                              authorizeUrl: _authorizeUrlController.text,
                              tokenValidateUrl:
                                  _tokenValidateUrlController.text,
                              verifyMsisdnUrl:
                                  _verifyMsisdnUrlController.text,
                              clientId: _clientIdController.text,
                              redirectUri: _redirectUriController.text,
                              scopes: _scopesController.text
                                  .split(RegExp(r'\s+'))
                                  .where((e) => e.isNotEmpty)
                                  .toList(),
                              apiKey: _apiKeyController.text,
                            );

                            final label = _labelController.text.trim().isEmpty
                                ? 'Custom env'
                                : _labelController.text.trim();

                            await ref
                                .read(environmentManagerProvider.notifier)
                                .saveNewVersion(
                                  label: label,
                                  environment: env,
                                );

                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Environment saved'),
                              ),
                            );
                          },
                          child: const Text('Save as new version'),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'History',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        if (state.history.isEmpty)
                          const Text('No previous versions yet.')
                        else
                          ...state.history.map((v) {
                            return ListTile(
                              title: Text('v${v.version} - ${v.label}'),
                              subtitle: Text(
                                v.createdAt.toLocal().toString(),
                              ),
                              trailing: TextButton(
                                onPressed: () {
                                  ref
                                      .read(environmentManagerProvider.notifier)
                                      .revertTo(v);
                                },
                                child: const Text('Revert'),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}


