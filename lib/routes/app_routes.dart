import 'package:flutter/material.dart';
import 'package:vaciniciapp/screens/login/login_screen.dart';
import 'package:vaciniciapp/screens/main/main_layout.dart';
import 'package:vaciniciapp/screens/onboarding/onboarding_screen.dart';
import 'package:vaciniciapp/screens/vaccine_card/vaccine_card_screen.dart';
import 'package:vaciniciapp/screens/vaccine_detail/vaccine_detail_screen.dart';
import 'package:vaciniciapp/screens/register/register_screen.dart';
import 'package:vaciniciapp/screens/schedule/schedule_screen.dart';
import 'package:vaciniciapp/screens/statistics/statistics_screen.dart';
import 'package:vaciniciapp/screens/settings/settings_screen.dart';
import 'package:vaciniciapp/screens/forgot_password/forgot_password_screen.dart';
import 'package:vaciniciapp/screens/edit_profile/edit_profile_screen.dart';
import 'package:vaciniciapp/screens/professionals/professionals_screen.dart';
import 'package:vaciniciapp/screens/professional_detail/professional_detail_screen.dart';
import 'package:vaciniciapp/screens/terms/terms_screen.dart';
import 'package:vaciniciapp/screens/help/help_screen.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  static const String vaccineCard = '/vaccine-card';
  static const String vaccineDetail = '/vaccine-detail';
  static const String schedule = '/schedule';
  static const String statistics = '/statistics';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String professionals = '/professionals';
  static const String professionalDetail = '/professional-detail';
  static const String terms = '/terms';
  static const String help = '/help';

  static final Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    main: (context) => const MainLayout(),
    vaccineCard: (context) => const VaccineCardScreen(),
    vaccineDetail: (context) => const VaccineDetailScreen(),
    schedule: (context) => const ScheduleScreen(),
    statistics: (context) => const StatisticsScreen(),
    settings: (context) => const SettingsScreen(),
    editProfile: (context) => const EditProfileScreen(),
    professionals: (context) => const ProfessionalsScreen(),
    professionalDetail: (context) => const ProfessionalDetailScreen(),
    terms: (context) => const TermsScreen(),
    help: (context) => const HelpScreen(),
  };
}