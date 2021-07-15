import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:match_number/models/score_model.dart';
import 'package:match_number/ui/widgets/fancy_button.dart';
import 'package:match_number/viewmodel/stats_view_model.dart';

class StatsPage extends StatelessWidget {
  final int? score;
  final StatsViewModel _viewModel;
  final TextEditingController _controller = TextEditingController();
  StatsPage(this.score) : _viewModel = StatsViewModel(score);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        title: Text(
          'Champ Board',
          style: GoogleFonts.pressStart2p(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Visibility(
              visible: score != null && score! > 0,
              child: Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Type ur name champion',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.grey[400]),
                  ),
                  controller: _controller,
                  onChanged: _viewModel.championNameChangedCommand,
                  style: Theme.of(context).textTheme.headline3,
                ),
              )),
            ),
            Visibility(
              visible: score != null && score! > 0,
              child: LimitedBox(
                maxHeight: MediaQuery.of(context).size.height * 0.1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FancyButton(
                      color: Theme.of(context).primaryColor,
                      child: InkWell(
                        onTap: () {
                          _viewModel.saveChampionCommand();
                          Navigator.pop(context);
                        },
                        child: Center(
                            child: Text('Save champion',
                                style: GoogleFonts.pressStart2p())),
                      )),
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<ScoreModel>>(
                  valueListenable: _viewModel.loadChampionsCommand,
                  builder: (context, snapshot, child) {
                    snapshot.sort((a, b) => a.score > b.score ? 0 : 1);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                            visible: snapshot.isEmpty && score == null,
                            child: const Text(
                                'No Scores Here !!! Play now and be a player')),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _getDataTable(context, snapshot),
                          ),
                        ),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  DataTable _getDataTable(BuildContext context, List<ScoreModel> scores) {
    return DataTable(
      columns: [
        DataColumn(
            label: Text('Name',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.black54))),
        DataColumn(
            label: Text('Score',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.black54)))
      ],
      rows: List<DataRow>.generate(
          scores.length,
          (index) => DataRow(cells: [
                DataCell(Text(scores[index].name,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black54))),
                DataCell(Text('${scores[index].score}',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black54)))
              ])),
    );
  }

  ListView _getListView(List<ScoreModel> snapshot) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: snapshot.length + 1,
        itemBuilder: (context, i) {
          final index = i - 1;
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  i == 0 ? 'Name' : snapshot[index].name,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.black54),
                ),
                Text(
                  i == 0 ? 'Score' : snapshot[index].score.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.black54),
                ),
              ]);
        });
  }
}
