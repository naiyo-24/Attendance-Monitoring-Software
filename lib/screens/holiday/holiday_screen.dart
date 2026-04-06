import 'package:flutter/material.dart';
import 'dart:ui';
import '../../providers/auth_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../theme/app_theme.dart';
import '../../cards/holiday/calendar_card.dart';
import '../../cards/holiday/holiday_detail_card.dart';
import '../../cards/holiday/create_edit_holiday_card.dart';
import '../../notifiers/holiday_notifier.dart';
import '../../models/holiday.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/loader.dart';

class HolidayScreen extends ConsumerStatefulWidget {
  const HolidayScreen({super.key});

  @override
  ConsumerState<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends ConsumerState<HolidayScreen> {
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  HolidayNotifier? _holidayNotifier;
  bool _initialized = false;

  Widget _glassSection({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kWhite.withAlpha(190),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: kBlack.withAlpha((0.06 * 255).toInt()),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: kBlack.withAlpha((0.05 * 255).toInt()),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(padding: const EdgeInsets.all(14), child: child),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final authNotifier = ref.read(authProvider);
      final adminId = authNotifier.user?.adminId;
      if (adminId != null) {
        _holidayNotifier = HolidayNotifier(adminId: adminId);
        _holidayNotifier!.fetchHolidays();
      } else {
        // Optionally handle the case where adminId is not available (e.g., show error or loading)
      }
      _initialized = true;
    }
  }

  void _openCreateEditHoliday({int? index, Holiday? holiday}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CreateEditHolidayCard(
          date: holiday?.date ?? _selectedDay,
          occasion: holiday?.occasion,
          remarks: holiday?.remarks,
          onSave: (date, occasion, remarks) async {
            final newHoliday = Holiday(
              date: date,
              occasion: occasion,
              remarks: remarks,
            );
            if (index != null) {
              await _holidayNotifier!.updateHoliday(index, newHoliday);
            } else {
              await _holidayNotifier!.addHoliday(newHoliday);
            }
            if (!context.mounted) return;
            Navigator.of(context).pop();
            setState(() {
              _selectedDay = date;
            });
          },
        ),
      ),
    );
  }

  void _deleteHoliday(int index) async {
    await _holidayNotifier!.deleteHoliday(index);
    setState(() {
      _selectedDay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminUser = ref.watch(authProvider).user;

    if (_holidayNotifier == null) {
      return Scaffold(
        drawer: adminUser == null ? null : SideNavBar(adminUser: adminUser),
        appBar: const PremiumAppBar(
          title: 'Holiday List',
          subtitle: 'View & manage holidays',
        ),
        body: const AttendX24Loader(text: 'Loading holidays…'),
      );
    }

    return AnimatedBuilder(
      animation: _holidayNotifier!,
      builder: (context, _) {
        final holidays = _holidayNotifier!.holidays;
        final holidayDates = holidays.map((h) => h.date).toSet();
        final selectedHolidayIndex = holidays.indexWhere(
          (h) => _selectedDay != null && _isSameDay(h.date, _selectedDay!),
        );
        final selectedHoliday = selectedHolidayIndex != -1
            ? holidays[selectedHolidayIndex]
            : null;

        return Scaffold(
          drawer: adminUser == null ? null : SideNavBar(adminUser: adminUser),
          appBar: const PremiumAppBar(
            title: 'Holiday List',
            subtitle: 'View & manage holidays',
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [kWhite, kWhiteGrey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                child: Column(
                  children: [
                    _glassSection(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Holiday List',
                              style: kHeaderTextStyle(context).copyWith(
                                fontSize: Responsive.fontSize(context, 16),
                                color: kBrown,
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Create'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: kBrown,
                              side: BorderSide(
                                color: kBrown.withAlpha((0.16 * 255).toInt()),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              textStyle: kCaptionTextStyle(
                                context,
                              ).copyWith(fontWeight: FontWeight.w900),
                            ),
                            onPressed: _openCreateEditHoliday,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: _holidayNotifier!.isLoading
                          ? const AttendX24Loader(text: 'Loading holidays…')
                          : _holidayNotifier!.error != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Text(
                                  _holidayNotifier!.error!,
                                  textAlign: TextAlign.center,
                                  style: kCaptionTextStyle(context).copyWith(
                                    color: kerror,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  CalendarCard(
                                    focusedDay: _focusedDay,
                                    holidayDates: holidayDates,
                                    onDaySelected: (date) {
                                      setState(() => _selectedDay = date);
                                    },
                                  ),
                                  const SizedBox(height: 14),
                                  if (selectedHoliday != null)
                                    HolidayDetailCard(
                                      occasion: selectedHoliday.occasion,
                                      date:
                                          '${selectedHoliday.date.day}/${selectedHoliday.date.month}/${selectedHoliday.date.year}',
                                      remarks: selectedHoliday.remarks,
                                      onEdit: () => _openCreateEditHoliday(
                                        index: selectedHolidayIndex,
                                        holiday: selectedHoliday,
                                      ),
                                      onDelete: () =>
                                          _deleteHoliday(selectedHolidayIndex),
                                    )
                                  else
                                    _glassSection(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Text(
                                          'Select a date to view details.',
                                          textAlign: TextAlign.center,
                                          style: kCaptionTextStyle(context)
                                              .copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: kBrown.withAlpha(
                                                  (0.72 * 255).toInt(),
                                                ),
                                              ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
