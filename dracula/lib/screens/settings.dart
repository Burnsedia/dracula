import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../services/export_service.dart';
import 'CategoryManagement.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  BloodSugarUnit _selectedUnit = BloodSugarUnit.mgdl;
  bool _showTimezone = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final unit = await SettingsService().getBloodSugarUnit();
    final showTimezone = await SettingsService().getShowTimezone();

    setState(() {
      _selectedUnit = unit;
      _showTimezone = showTimezone;
    });
  }

  Future<void> _saveUnit(BloodSugarUnit unit) async {
    await SettingsService().setBloodSugarUnit(unit);
    setState(() => _selectedUnit = unit);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Units changed to ${SettingsService().getUnitDisplayString(unit)}')),
      );
    }
  }

  Future<void> _saveTimezone(bool show) async {
    await SettingsService().setShowTimezone(show);
    setState(() => _showTimezone = show);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader('Blood Sugar Units'),
          _buildUnitSelection(),
          const Divider(),
          _buildSectionHeader('Display'),
          _buildTimezoneToggle(),
          const Divider(),
          _buildSectionHeader('Export Data'),
          _buildExportSection(),
          const Divider(),
          _buildSectionHeader('Categories'),
          _buildCategoriesSection(),
          const Divider(),
          _buildSectionHeader('About'),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildUnitSelection() {
    return Column(
      children: [
        RadioListTile<BloodSugarUnit>(
          title: const Text('mg/dL (milligrams per deciliter)'),
          subtitle: const Text('Standard US units'),
          value: BloodSugarUnit.mgdl,
          groupValue: _selectedUnit,
          onChanged: (value) => value != null ? _saveUnit(value) : null,
        ),
        RadioListTile<BloodSugarUnit>(
          title: const Text('mmol/L (millimoles per liter)'),
          subtitle: const Text('International units'),
          value: BloodSugarUnit.mmoll,
          groupValue: _selectedUnit,
          onChanged: (value) => value != null ? _saveUnit(value) : null,
        ),
      ],
    );
  }

  Widget _buildTimezoneToggle() {
    return SwitchListTile(
      title: const Text('Show timezone in timestamps'),
      subtitle: const Text('Display local timezone information'),
      value: _showTimezone,
      onChanged: _saveTimezone,
    );
  }

  Widget _buildExportSection() {
    return Column(
      children: [
        ListTile(
          title: const Text('Export Blood Sugar Data'),
          subtitle: const Text('Download CSV or TXT file'),
          trailing: const Icon(Icons.download),
          onTap: () => _showExportDialog('blood_sugar'),
        ),
        ListTile(
          title: const Text('Export Exercise Data'),
          subtitle: const Text('Download CSV file'),
          trailing: const Icon(Icons.download),
          onTap: () => _showExportDialog('exercise'),
        ),
        ListTile(
          title: const Text('Export Database Backup'),
          subtitle: const Text('Full SQLite database file'),
          trailing: const Icon(Icons.backup),
          onTap: () => _exportDatabase(),
        ),
      ],
    );
  }

  void _showExportDialog(String type) {
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            'Export ${type == 'blood_sugar' ? 'Blood Sugar' : 'Exercise'} Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Data'),
              leading: const Icon(Icons.all_inclusive),
              onTap: () => _performExport(type, null, null),
            ),
            ListTile(
              title: const Text('Last 7 Days'),
              leading: const Icon(Icons.calendar_view_week),
              onTap: () => _performExport(
                  type, DateTime.now().subtract(const Duration(days: 7)), null),
            ),
            ListTile(
              title: const Text('Last 30 Days'),
              leading: const Icon(Icons.calendar_view_month),
              onTap: () => _performExport(type,
                  DateTime.now().subtract(const Duration(days: 30)), null),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _performExport(
      String type, DateTime? start, DateTime? end) async {
    Navigator.pop(context); // Close dialog

    try {
      if (type == 'blood_sugar') {
        await ExportService.exportBloodSugarToCSV(
            startDate: start, endDate: end);
      } else {
        await ExportService.exportExercisesToCSV(
            startDate: start, endDate: end);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export completed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export failed')),
        );
      }
    }
  }

  Future<void> _exportDatabase() async {
    try {
      await ExportService.exportDatabase();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Database backup completed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup failed')),
        );
      }
    }
  }

  Widget _buildCategoriesSection() {
    return ListTile(
      title: const Text('Manage Categories'),
      subtitle: const Text('Add or remove custom metrics'),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
        );
      },
    );
  }

  Widget _buildAboutSection() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dracula Blood Sugar Tracker',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Version 1.0.0'),
          SizedBox(height: 4),
          Text('Privacy-focused health tracking app'),
          SizedBox(height: 4),
          Text('All data stored locally on device'),
        ],
      ),
    );
  }
}
