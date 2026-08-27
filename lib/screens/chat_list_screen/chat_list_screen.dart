import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/chat_list_screen/controller/chat_list_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatListController>();
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Message',
      hideBackButton: true,
      child: Obx(() {
        final chats = controller.filteredConversations;

        // ── Header (search + encryption banner) ──
        final header = Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search bar
              CommonTextField(
                validationType: ValidationType.notRequired,
                hintText: 'Search conversations',
                backgroundColor: colors.backgroundColor,
                borderColor: colors.transparent,
                paddingVertical: 13.h,
                prefixIcon: Icon(
                  Icons.search,
                  color: colors.secondaryText,
                  size: 22.sp,
                ),
                onChanged: controller.onSearchChanged,
              ),
              SizedBox(height: 12.h),
              // Encryption banner
              const EncryptedBanner(),
              SizedBox(height: 4.h),
            ],
          ),
        );

        return Skeletonizer(
          enabled: controller.isLoading.value,
          child: chats.isEmpty && !controller.isLoading.value
              ? Column(
                  children: [
                    header,
                    SizedBox(height: 60.h),
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 56.sp,
                      color: colors.border,
                    ),
                    SizedBox(height: 12.h),
                    CommonText(
                      text: 'No conversations found',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      textColor: colors.secondaryText,
                      isDescription: true,
                      preventScaling: true,
                    ),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: () => controller.fetchConversations(),
                  child: SmartListLoader(
                    itemCount: chats.length,
                    appbar: header,
                    padding: EdgeInsets.zero,
                    onColapsAppbar: const SizedBox.shrink(),
                    itemBuilder: (_, index) => _ChatTile(
                      conversation: chats[index],
                      onTap: () => controller.onConversationTap(chats[index]),
                      showDivider: index < chats.length - 1,
                    ),
                  ),
                ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  Encrypted Messaging Banner
// ═══════════════════════════════════════════════════════
class EncryptedBanner extends StatelessWidget {
  final String? text;
  final Color? textColor;
  const EncryptedBanner({super.key, this.text, this.textColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      color: AppColors.instance.secondaryColor.withAlpha(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_rounded, size: 14.sp, color: textColor??AppColors.instance.secondaryColor),
          SizedBox(width: 6.w),
          CommonText(
            text: text??'SECURE END-TO-END ENCRYPTED MESSAGING',
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            textColor:textColor?? AppColors.instance.secondaryColor,
            isDescription: true,
            preventScaling: true,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  Chat Tile
// ═══════════════════════════════════════════════════════
class _ChatTile extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;
  final bool showDivider;

  const _ChatTile({
    required this.conversation,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final hasUnread = conversation.unreadCount > 0;
    final isTimeHighlighted = hasUnread;

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Avatar + online dot ──
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor: colors.boxBg,
                  backgroundImage: conversation.avatarUrl.isNotEmpty
                      ? NetworkImage(conversation.avatarUrl)
                      : null,
                  child: conversation.avatarUrl.isEmpty
                      ? Icon(Icons.person, color: colors.primary, size: 28.sp)
                      : null,
                ),
                SizedBox(width: 12.w),

                // ── Name + last message ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: '${conversation.name}, ${conversation.role}',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        textColor: colors.textPrimary,
                        textAlign: TextAlign.start,
                        isDescription: true,
                        preventScaling: true,
                      ),
                      SizedBox(height: 3.h),
                      CommonText(
                        text: conversation.isTyping ? 'typing...' : conversation.lastMessage,
                        fontSize: 13.sp,
                        fontWeight: conversation.isTyping ? FontWeight.w600 : FontWeight.w400,
                        textColor: conversation.isTyping ? colors.primary : colors.secondaryText,
                        textAlign: TextAlign.start,
                        isDescription: true,
                        preventScaling: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),

                // ── Time + unread badge ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText(
                      text: conversation.time,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      textColor: isTimeHighlighted
                          ? colors.primary
                          : colors.secondaryText,
                      isDescription: true,
                      preventScaling: true,
                    ),
                    SizedBox(height: 4.h),
                    if (hasUnread)
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withAlpha(50),
                              blurRadius: 5.r,
                              offset: Offset(0, 2.h),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: CommonText(
                          text: '${conversation.unreadCount}',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          textColor: Colors.white,
                          isDescription: true,
                          preventScaling: true,
                        ),
                      )
                    else
                      SizedBox(height: 22.h),
                  ],
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1.h,
              thickness: 1.h,
              indent: 72.w,
              endIndent: 20.w,
              color: colors.border.withAlpha(120),
            ),
        ],
      ),
    );
  }
}
