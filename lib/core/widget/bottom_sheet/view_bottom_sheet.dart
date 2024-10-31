import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../core/extension/space_extension.dart';
import '../../../../core/utils/border_radius.dart';
import '../../../../core/utils/color.dart';
import '../../../../core/utils/text_style.dart';
import '../button/button_constant.dart';

class ViewBottomSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final double footerHeight;
  final Widget? footerWidget;
  final void Function() onClose;
  final double maxChildSizeOffset;
  final double minChildSizeOffset;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final SliverPersistentHeaderDelegate? sliverPersistentHeaderDelegate;

  const ViewBottomSheet({
    super.key,
    required this.title,
    required this.onClose,
    required this.children,
    this.subtitle,
    this.footerHeight = AppButtonHeights.lg,
    this.footerWidget,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    this.maxChildSizeOffset = 0.1,
    this.minChildSizeOffset = 0.05,
    this.sliverPersistentHeaderDelegate,
  });

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool keyboardShowing = keyboardHeight > 0;

    final double maxChildSizeFinal = maxChildSize + maxChildSizeOffset > 1
        ? 1
        : maxChildSize + maxChildSizeOffset;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboardShowing ? keyboardHeight : 0),
      child: DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: !keyboardShowing ? maxChildSize : maxChildSizeFinal,
        expand: false,
        snapSizes: [
          minChildSize + minChildSizeOffset,
          initialChildSize,
          if (initialChildSize < maxChildSize)
            !keyboardShowing ? maxChildSize : maxChildSizeFinal,
        ],
        snap: true,
        builder: (context, controller) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.only(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
                top: 6.0,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppBorderRadius.md12),
                ),
                // color: Colors.white,
              ),
              child: Stack(
                children: [
                  CustomScrollView(
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPersistentHeader(
                        delegate: sliverPersistentHeaderDelegate ??
                            _SectionHeaderDelegate(
                              title: title,
                              subtitle: subtitle,
                              onClose: onClose,
                            ),
                        pinned: true,
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          children,
                        ),
                      ),
                      if (footerWidget != null)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(
                            height: footerHeight + 16,
                          ),
                        ),
                    ],
                  ),
                  if (footerWidget != null)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: footerWidget!,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String? subtitle;
  final void Function() onClose;

  _SectionHeaderDelegate({
    required this.title,
    required this.onClose,
    this.subtitle,
  });

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      // color: AppColor.white,
      height: subtitle != null ? 112 : 64,
      child: Column(
        children: [
          Center(
            child: Container(
              height: 4.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          8.gap,
          Expanded(
            child: subtitle != null ? _buildTitleAndSubtitle() : _buildTitle(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() => Row(
        children: [
          Expanded(
            child: AutoSizeText(title, style: AppTextStyle.style30B),
          ),
          8.gap,
          IconButton(
            onPressed: onClose,
            icon: const Icon(
              HeroIcons.x_mark,
              color: AppColor.primaryColor200,
              size: 26.0,
            ),
          ),
        ],
      );

  Widget _buildTitleAndSubtitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          Text(
            subtitle!,
            style: AppTextStyle.style14,
          ),
          const Spacer(),
          const Divider(height: 1),
        ],
      );

  @override
  double get maxExtent => subtitle != null ? 112 : 64;

  @override
  double get minExtent => subtitle != null ? 112 : 64;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
