import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/controllers/support_ticket_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class PriorityBottomSheetWidget extends StatelessWidget {
  const PriorityBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SupportTicketController>(
        builder: (context, supportTicketProvider, child) {
          return Container(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(color: Theme.of(context).cardColor,
                borderRadius:  const BorderRadius.vertical(top: Radius.circular(Dimensions.paddingSizeDefault))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 40,height: 5,decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(.5),
                  borderRadius: BorderRadius.circular(20)),),
              const SizedBox(height: 20,),
              ListView.builder(
                  itemCount: supportTicketProvider.priority.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index){
                    return InkWell(onTap: (){
                      Navigator.of(context).pop();
                        supportTicketProvider.setSelectedPriority(index);
                      },
                      child: Container(decoration: BoxDecoration(
                          color: supportTicketProvider.selectedPriorityIndex == index? Theme.of(context).primaryColor.withOpacity(.1):
                          Theme.of(context).cardColor),
                        child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Row(children: [
                            Padding(padding: EdgeInsets.symmetric(horizontal:supportTicketProvider.selectedPriorityIndex == index?
                            Dimensions.paddingSizeSmall:0),
                              child: Text(getTranslated(supportTicketProvider.priority[index], context)??'',
                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                                    color: supportTicketProvider.selectedPriorityIndex == index? Theme.of(context).primaryColor:
                                    Theme.of(context).textTheme.bodyLarge?.color),),),
                          ],
                          ),
                        ),
                      ),
                    );
                  }),
            ],
            ),
          );
        }
    );
  }
}
