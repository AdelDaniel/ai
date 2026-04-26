# 🧱 Project Structure Relevant to UI is Clean Architecture Without Usecase Layer

```text
lib/
  core/
  features/
    <feature_name>/
      data/
        repositories/    // implementations using core/api & core/services
      domain/
        entities/
        repositories/    // abstract interfaces
      presentation/
        bloc/            // Blocs (already implemented)
            [feature]_bloc.dart       # Main BLoC file
            [feature]_event.dart      # Events (part of bloc)
            [feature]_state.dart      # States (part of bloc)
        screens/         // Screens/pages for this feature
        widgets/         // Feature-specific widgets
```

Example:

```
└── 📁lib
    └── 📁core
        └── 📁animations
        └── 📁app_analytics
        └── 📁audio_player
        └── 📁blocs
        └── 📁constants
            ├── constants.dart
        └── 📁errors
            ├── exceptions.dart
            ├── failures.dart
            ├── purchase_failures.dart
        └── 📁extensions
            ├── extensions.dart
            ├── theme_extensions.dart
        └── 📁feedback
            ├── feedback_message.dart
            ├── feedback_snackbar.dart
            ├── feedback_toast.dart
        └── 📁firebase
            └── 📁analytics
                ├── firebase_analytics_services_container_setup.dart
                ├── firebase_analytics_services.dart
            └── 📁crashlytics
                ├── crashlytics_service.dart
            └── 📁firestore
                ├── firestore_container_setup.dart
                ├── firestore_paths.dart
                ├── firestore_service.dart
            └── 📁storage
                ├── firebase_storage_service.dart
        └── 📁global
            └── 📁user_role
                └── 📁bloc
                    ├── user_role_bloc.dart
                    ├── user_role_event.dart
                    ├── user_role_state.dart
                └── 📁managers
                    ├── user_role_manager.dart
                └── 📁models
                    ├── role_context_extension.dart
                    ├── user_role.dart
                ├── container_setup.dart
        └── 📁keys
            ├── keys.dart
        └── 📁localization
            ├── app_localizations.dart
            ├── locale_cubit.dart
            ├── localization_keys.dart
        └── 📁middleware
            ├── middleware.dart
        └── 📁notifications
            ├── notification_navigation_service.dart
            ├── notification_payload_model.dart
            ├── notification_scheduler_service.dart
        └── 📁routes
            ├── app_routes.dart
            ├── app_routing.dart
            ├── mixpanel_route_observer.dart
        └── 📁services
            └── 📁iap
            └── 📁image_picker
            └── 📁store_checker
        └── 📁shared_pref
            └── 📁managers
                ├── pref_manager.dart
            ├── pref_keys.dart
            ├── pref_util.dart
            ├── shared_pref_container_setup.dart
        └── 📁theme
            └── 📁cubit
                ├── app_theme_cubit.dart
                ├── theme_mode_cubit.dart
            └── 📁text_theme
                ├── text_theme_builder.dart
            └── 📁themes
                ├── base_app_theme.dart
                ├── main_app_theme.dart
                ├── theme.dart
            ├── app_theme_factory.dart
        └── 📁utils
            └── 📁app_badge
                ├── app_badge.dart
            └── 📁app_debug_print
                ├── app_debug_print.dart
            └── 📁bloc_observer
                ├── app_bloc_observer.dart
            ├── app_greeting_utils.dart
            ├── app_haptics_feedback.dart
            ├── app_lifecycle_service.dart
            ├── date_formatter.dart
            ├── either.dart
            ├── option.dart
            ├── service_locator.dart
            ├── url_launcher_helper.dart
        └── 📁widgets
            └── 📁app_bars
                ├── close_app_bar.dart
                ├── skip_app_bar.dart
            └── 📁app_buttons
                ├── app_back_button.dart
                ├── app_close_button.dart
                ├── app_elevated_button.dart
                ├── app_icon_button.dart
                ├── app_outlined_button.dart
                ├── app_stretched_button.dart
                ├── app_text_button.dart
                ├── common_widgets.dart
                ├── skip_text_button.dart
            └── 📁app_info
                ├── app_info_service.dart
                ├── app_info_widget.dart
                ├── package_info_cubit.dart
            └── 📁background
                ├── background_image_wrapper.dart
                ├── gradient_bottom.dart
                ├── onboarding_background_wrapper.dart
            └── 📁images
                ├── app_asset_image.dart
                ├── app_cached_network_image.dart
                ├── image_error_widget.dart
                ├── image_shimmer_builder.dart
            └── 📁loaders
                ├── full_screen_loader_widget.dart
                ├── loader_overlay.dart
                ├── loader_widget.dart
                ├── pagination_loader_widget.dart
                ├── square_circle_loading_widget.dart
            └── 📁lottie
                ├── app_lottie_asset.dart
                ├── lottie_overlay.dart
            └── 📁no_result
                ├── no_result_found.dart
            └── 📁screen_scrolling
                ├── full_scrollable_full_custom_screen.dart
                ├── scroll_to_hide_widget.dart
            └── 📁status_bar
                ├── statusbar_controller.dart
            └── 📁text
                ├── hush_text.dart
            └── 📁video
                ├── youtube_frame.dart
            ├── empty_widgets.dart
    └── 📁features
        └── 📁onboarding
            └── 📁domain
                └── 📁entities
                    ├── onboarding_data.dart
                └── 📁models
                    ├── science_recommendation.dart
            └── 📁presentation
                └── 📁bloc
                    ├── onboarding_bloc.dart
                    ├── onboarding_event.dart
                    ├── onboarding_state.dart
                └── 📁pages
                    ├── content_type_page.dart
                    ├── duration_page.dart
                    ├── goal_page.dart
                    ├── science_page.dart
                    ├── unlock_page.dart
                    ├── welcome_page.dart
                └── 📁screens
                    ├── onboarding_screen.dart
                └── 📁widgets
                    ├── onboarding_option_button.dart
                    ├── onboarding_page.dart
                    ├── onboarding_progress_bar.dart
        └── 📁paywall
            └── 📁model
                ├── subscription_constants.dart
            └── 📁screens
                ├── paywall_screen.dart
            └── 📁widget
                ├── lower_description.dart
                ├── most_popular_badge.dart
                ├── payment_details_row.dart
                ├── paywall_app_bar.dart
                ├── products_list.dart
                ├── subscribe_button.dart
                ├── subscription_plan_card.dart
    └── 📁models
        └── 📁noise_models
            ├── noise_models.dart
        └── 📁sound_models
            ├── sound_models.dart
    └── 📁res
        ├── app_asset_paths.dart
        ├── app_colors.dart
        ├── app_padding.dart
        ├── app_spacing.dart
    ├── container_setup.dart
    ├── firebase_options.dart
    ├── main.dart
    └── my_app.dart
```
