import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/chat_list_screen/controller/chat_list_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search bar
              CommonTextField(
                validationType: ValidationType.notRequired,
                hintText: 'Search conversations',
                backgroundColor: colors.backgroundColor,
                borderColor: colors.transparent,
                paddingVertical: 13,
                prefixIcon: Icon(
                  Icons.search,
                  color: colors.secondaryText,
                ),
                onChanged: controller.onSearchChanged,
              ),
              const SizedBox(height: 12),
              // Encryption banner
              const EncryptedBanner(),
              const SizedBox(height: 4),
            ],
          ),
        );

        if (controller.isLoading.value && chats.isEmpty) {
          return Column(
            children: [
              header,
              const Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          );
        }

        if (chats.isEmpty) {
          return Column(
            children: [
              header,
              const SizedBox(height: 60),
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 56,
                color: colors.border,
              ),
              const SizedBox(height: 12),
              CommonText(
                text: 'No conversations found',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: colors.secondaryText,
                isDescription: true,
                preventScaling: true,
              ),
            ],
          );
        }

        return RefreshIndicator(
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: AppColors.instance.secondaryColor.withAlpha(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_rounded, size: 14, color: textColor??AppColors.instance.secondaryColor),
          const SizedBox(width: 6),
          CommonText(
            text: text??'SECURE END-TO-END ENCRYPTED MESSAGING',
            fontSize: 11,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Avatar + online dot ──
                // Stack(
                //   clipBehavior: Clip.none,
                //   children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: colors.boxBg,
                      backgroundImage: conversation.avatarUrl.isNotEmpty
                          ? NetworkImage(conversation.avatarUrl)
                          : null,
                      child: conversation.avatarUrl.isEmpty
                          ? Icon(Icons.person, color: colors.primary, size: 28)
                          : null,
                    ),
                    // if (conversation.isOnline)
                    //   Positioned(
                    //     bottom: 0,
                    //     right: 0,
                    //     child: Container(
                    //       width: 12,
                    //       height: 12,
                    //       decoration: BoxDecoration(
                    //         color: colors.success,
                    //         shape: BoxShape.circle,
                    //         border: Border.all(color: colors.white, width: 2),
                    //       ),
                    //     ),
                    //   ),
                //   ],
                // ),
                const SizedBox(width: 12),

                // ── Name + last message ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: '${conversation.name}, ${conversation.role}',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        textColor: colors.textPrimary,
                        textAlign: TextAlign.start,
                        isDescription: true,
                        preventScaling: true,
                      ),
                      const SizedBox(height: 3),
                      CommonText(
                        text: conversation.isTyping ? 'typing...' : conversation.lastMessage,
                        fontSize: 13,
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
                const SizedBox(width: 10),

                // ── Time + unread badge ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText(
                      text: conversation.time,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      textColor: isTimeHighlighted
                          ? colors.primary
                          : colors.secondaryText,
                      isDescription: true,
                      preventScaling: true,
                    ),
                    const SizedBox(height: 4),
                    if (hasUnread)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withAlpha(50),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: CommonText(
                          text: '${conversation.unreadCount}',
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          textColor: Colors.white,
                          isDescription: true,
                          preventScaling: true,
                        ),
                      )
                    else
                      const SizedBox(height: 22),
                  ],
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              thickness: 1,
              indent: 72,
              endIndent: 20,
              color: colors.border.withAlpha(120),
            ),
        ],
      ),
    );
  }
}
