import 'package:flutter/material.dart';

import 'capability_registry.dart';
import 'environment_screen.dart';

enum SupportFilter {
  all,
  supported,
  notSupported,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SupportFilter _currentFilter = SupportFilter.all;
  Map<CamaraApiCategory, List<CamaraCapability>>? _filteredCapabilities;
  int? _totalCapabilities;

  @override
  void initState() {
    super.initState();
    _updateFilteredCapabilities();
  }

  void _updateFilteredCapabilities() {
    final filtered = <CamaraApiCategory, List<CamaraCapability>>{};
    int total = 0;

    for (final entry in capabilitiesByCategory.entries) {
      final category = entry.key;
      final capabilities = entry.value;

      List<CamaraCapability> filteredList;
      switch (_currentFilter) {
        case SupportFilter.supported:
          filteredList = capabilities
              .where((c) => c.isSupportedByIOH)
              .toList();
          break;
        case SupportFilter.notSupported:
          filteredList = capabilities
              .where((c) => !c.isSupportedByIOH)
              .toList();
          break;
        case SupportFilter.all:
          filteredList = capabilities;
          break;
      }

      if (filteredList.isNotEmpty) {
        filtered[category] = filteredList;
        total += filteredList.length;
      }
    }

    setState(() {
      _filteredCapabilities = filtered;
      _totalCapabilities = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredCapabilities = _filteredCapabilities ?? {};
    final totalCapabilities = _totalCapabilities ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CAMARA Playground'),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton<SupportFilter>(
                tooltip: 'Filter capabilities',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getFilterIcon(_currentFilter),
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getFilterLabel(_currentFilter),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_drop_down, size: 18),
                    ],
                  ),
                ),
                onSelected: (SupportFilter filter) {
                  setState(() {
                    _currentFilter = filter;
                  });
                  _updateFilteredCapabilities();
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<SupportFilter>(
                    value: SupportFilter.all,
                    child: Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: 20,
                          color: _currentFilter == SupportFilter.all
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 12),
                        const Text('All'),
                        if (_currentFilter == SupportFilter.all) ...[
                          const Spacer(),
                          Icon(
                            Icons.check,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuItem<SupportFilter>(
                    value: SupportFilter.supported,
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: _currentFilter == SupportFilter.supported
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 12),
                        const Text('Supported'),
                        if (_currentFilter == SupportFilter.supported) ...[
                          const Spacer(),
                          Icon(
                            Icons.check,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuItem<SupportFilter>(
                    value: SupportFilter.notSupported,
                    child: Row(
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 20,
                          color: _currentFilter == SupportFilter.notSupported
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 12),
                        const Text('Not Yet Supported'),
                        if (_currentFilter == SupportFilter.notSupported) ...[
                          const Spacer(),
                          Icon(
                            Icons.check,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalCapabilities',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Environment',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EnvironmentScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: filteredCapabilities.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No capabilities found',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try selecting a different filter',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredCapabilities.length,
                    itemBuilder: (context, index) {
                      final category = filteredCapabilities.keys.elementAt(index);
                      final capabilities = filteredCapabilities[category]!;
                      
                      return ExpansionTile(
                        leading: _getCategoryIcon(category),
                        title: Text(
                          category.displayName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        subtitle: Text('${capabilities.length} API${capabilities.length != 1 ? 's' : ''}'),
                        children: capabilities.map((capability) {
                          return ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(capability.title),
                                ),
                                if (capability.isSupportedByIOH)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'IOH',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Text(
                              capability.description,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                  ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => capability.buildEntryPoint(context),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getFilterLabel(SupportFilter filter) {
    switch (filter) {
      case SupportFilter.all:
        return 'All';
      case SupportFilter.supported:
        return 'Supported';
      case SupportFilter.notSupported:
        return 'Not Supported';
    }
  }

  IconData _getFilterIcon(SupportFilter filter) {
    switch (filter) {
      case SupportFilter.all:
        return Icons.list;
      case SupportFilter.supported:
        return Icons.check_circle_outline;
      case SupportFilter.notSupported:
        return Icons.hourglass_empty;
    }
  }

  Icon _getCategoryIcon(CamaraApiCategory category) {
    switch (category) {
      case CamaraApiCategory.authenticationAndFraudPrevention:
        return const Icon(Icons.security);
      case CamaraApiCategory.locationServices:
        return const Icon(Icons.location_on);
      case CamaraApiCategory.communicationServices:
        return const Icon(Icons.chat);
      case CamaraApiCategory.communicationQuality:
        return const Icon(Icons.signal_cellular_alt);
      case CamaraApiCategory.deviceInformation:
        return const Icon(Icons.devices);
      case CamaraApiCategory.computingServices:
        return const Icon(Icons.cloud);
      case CamaraApiCategory.paymentsAndCharging:
        return const Icon(Icons.payment);
      case CamaraApiCategory.serviceManagement:
        return const Icon(Icons.settings);
    }
  }
}

