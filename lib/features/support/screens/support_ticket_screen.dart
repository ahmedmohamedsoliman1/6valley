import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/controllers/support_ticket_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/widgets/support_ticket_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/widgets/support_ticket_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/widgets/support_ticket_type_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:provider/provider.dart';


class SupportTicketScreen extends StatefulWidget {
  const SupportTicketScreen({super.key});
  @override
  State<SupportTicketScreen> createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  @override
  void initState() {
    if (Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<SupportTicketController>(context, listen: false).getSupportTicketList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: getTranslated('support_ticket', context)),
        bottomNavigationBar: Provider.of<AuthController>(context, listen: false).isLoggedIn()?
        SizedBox(height: 70,
          child: InkWell(onTap: () {showModalBottomSheet(context: context, isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (con) => const SupportTicketTypeWidget());
            },
              child: Padding(padding: const EdgeInsets.all(8.0),
                child: CustomButton(radius: Dimensions.paddingSizeExtraSmall,
                buttonText: getTranslated('add_new_ticket', context)),)),):const SizedBox(),
      body: Consumer<SupportTicketController>(
        builder: (context, support, child) {
            return Provider.of<AuthController>(context, listen: false).isLoggedIn()?
            support.supportTicketList != null ?
            support.supportTicketList!.isNotEmpty?
            RefreshIndicator(onRefresh: () async => await support.getSupportTicketList(),
              child: ListView.builder(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                itemCount: support.supportTicketList?.length,
                itemBuilder: (context, index) => SupportTicketWidget(supportTicketModel: support.supportTicketList![index])),
            ) : const NoInternetOrDataScreenWidget(isNoInternet: false, icon: Images.noTicket,
          message: 'no_ticket_created',) : const SupportTicketShimmer():const NotLoggedInWidget();
          },
        ),
      );
  }
}



