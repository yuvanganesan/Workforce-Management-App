import 'package:flutter/material.dart';
import '../models/ratings.dart';
import '../providers/ratings_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingsCard extends StatefulWidget {
  final List<Ratings> empRatingCardList;
  // ignore: use_key_in_widget_constructors
  const RatingsCard(this.empRatingCardList);

  @override
  State<RatingsCard> createState() => _RatingsCardState();
}

class _RatingsCardState extends State<RatingsCard> {
  @override
  Widget build(BuildContext context) {
    Map<String, String> dropDownItems =
        Provider.of<RatingsProvider>(context, listen: false)
            .dropDownButtonItems;
    return ListView.builder(
        itemCount: widget.empRatingCardList.length,
        itemBuilder: (context, index) => Card(
              elevation: 5,
              child: Padding(
                  padding: EdgeInsets.all(7.0),
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.purpleAccent,
                        child: Text(
                          widget.empRatingCardList[index].empId,
                          style: const TextStyle(color: Colors.white),
                        )),
                    title: Text(widget.empRatingCardList[index].name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   height: 10,
                        // ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: dropDownItems[
                                widget.empRatingCardList[index].stageId],
                            items: dropDownItems.values
                                .map((value) => DropdownMenuItem<String>(
                                      child: Text(value),
                                      value: value,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                Provider.of<RatingsProvider>(context,
                                        listen: false)
                                    .updateStageId(value!, index);
                              });
                            },
                          ),
                        ),
                        RatingBar(
                            allowHalfRating: true,
                            initialRating:
                                widget.empRatingCardList[index].ratingStar,
                            maxRating: 5,
                            minRating: 1,
                            itemSize: 35,
                            ratingWidget: RatingWidget(
                              empty: const Icon(
                                Icons.star,
                                color: Colors.grey,
                              ),
                              full: const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              half: const Icon(
                                Icons.star_half,
                                color: Colors.amber,
                              ),
                            ),
                            onRatingUpdate: (value) {
                              //empRatingCardList[index].updateRatingStar(value);
                              Provider.of<RatingsProvider>(context,
                                      listen: false)
                                  .updateRatingStar(value, index);
                            }),
                      ],
                    ),
                    //  trailing:
                  )),
            ));
  }
}
