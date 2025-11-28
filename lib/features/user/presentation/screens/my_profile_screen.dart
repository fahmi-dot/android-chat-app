import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/features/user/presentation/providers/user_provider.dart';
import 'package:android_chat_app/shared/widgets/custom_banner.dart';
import 'package:android_chat_app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  bool _onEdit = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(userProvider.notifier).getMyProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider).value;
    if (userState == null) return CircularProgressIndicator();

    return Scaffold(
      // appBar: AppBar(),
      body: SizedBox(
        height: AppSizes.screenHeight(context),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: AppSizes.screenWidth(context),
                height: AppSizes.screenHeight(context),
                padding: EdgeInsets.symmetric(
                  vertical: 32.0 + AppSizes.paddingS,
                  horizontal: 32.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.profile,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: AppSizes.font2XL,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _onEdit = !_onEdit;
                            });
                          },
                          child: HeroIcon(
                            _onEdit ? HeroIcons.check : HeroIcons.pencilSquare,
                            color: Theme.of(context).colorScheme.onPrimary,
                            style: HeroIconStyle.outline,
                            size: AppSizes.iconL,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: AppSizes.screenWidth(context),
                height: AppSizes.screenHeight(context) * 0.89,
                padding: EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusL),
                  ),
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: AppSizes.paddingL,
                        children: [
                          CustomBanner(widget: Container(
                            height: 80.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                userState.avatarUrl,
                              ),
                              backgroundColor: Theme.of(context).colorScheme.surface,
                            ),
                          )),
                          Text(
                            userState.displayName,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: AppSizes.fontXL,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          _buildField(AppStrings.username, userState.username),
                          _buildField(AppStrings.bio, userState.bio ?? ''),
                          _buildField(AppStrings.phoneNumber, userState.phoneNumber),
                          _buildField(AppStrings.email, userState.email),
                          SizedBox(height: AppSizes.paddingL),
                          Image.asset(
                            'assets/icons/icon_hello.png',
                            width: AppSizes.screenWidth(context) * 0.15,
                            color: Theme.of(
                              context,
                            ).colorScheme.secondary.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: HeroIcon(
                          HeroIcons.arrowLeft,
                          color: Theme.of(context).colorScheme.onSurface,
                          style: HeroIconStyle.outline,
                          size: AppSizes.iconL,
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
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: TextEditingController(text: value),
          icon: _onEdit ? HeroIcons.pencil : null,
          type: CustomTextFieldType.readOnly,
        ),
      ],
    );
  }
}
