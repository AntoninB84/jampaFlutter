import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/auth/auth_bloc.dart';
import 'package:jampa_flutter/bloc/sync/sync_bloc.dart';
import 'package:jampa_flutter/repository/auth_repository.dart';
import 'package:jampa_flutter/repository/sync_repository.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/connectivity/connectivity_service.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/routers/routes.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

/// Splash screen displayed while checking authentication status and performing initial sync
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SyncBloc(
        syncRepository: serviceLocator<SyncRepository>(),
        connectivityService: serviceLocator<ConnectivityService>(),
      ),
      child: Builder(
        builder: (context) {
          // Check auth status immediately when splash loads
          final authState = context.watch<AuthBloc>().state;

          // Handle authenticated state
          if (authState.status == AuthStatus.authenticated) {
            // Trigger sync once
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final syncState = context.read<SyncBloc>().state;
              if (syncState is SyncInitial) {
                context.read<SyncBloc>().add(SyncRequested());
              }
            });
          }

          // Handle unauthenticated state
          if (authState.status == AuthStatus.unauthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.goNamed(kAppRouteLoginName);
            });
          }

          return BlocListener<SyncBloc, SyncState>(
          listener: (context, syncState) {
            // Navigate to home when sync completes (success or failure)
            if (syncState is SyncSuccess ||
                syncState is SyncFailure ||
                syncState is SyncNoNetwork) {

                // Show error message if sync failed or no network
                switch(syncState){
                  case SyncNoNetwork():
                    SnackBarX.showError(context, context.strings.sync_no_network_message);
                  case SyncFailure():
                    SnackBarX.showError(context, context.strings.sync_failed_message);
                  default:
                }

                // Navigate to notes page after sync
                context.goNamed(kAppRouteNotesName);
            }
          },
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: MediaQuery.of(context).size.width * 0.45,
                  ),
                  const SizedBox(height: 24),
                  // Loading indicator
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        );
        },
      ),
    );
  }
}

