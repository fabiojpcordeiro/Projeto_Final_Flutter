import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/core/layouts/base_layout.dart';
import 'package:projeto_final_flutter/core/storage/local_storage.dart';
import 'package:projeto_final_flutter/core/widgets/job_card.dart';
import 'package:projeto_final_flutter/services/job_service.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  final String? city;
  const HomePage({super.key, this.city});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final JobService _jobService = JobService();
  final CarouselSliderController _controller = CarouselSliderController();
  List<dynamic> _jobs = [];
  bool _isLoading = true;
  String? _error;
  String? _city;
  int _current = 0;
  bool _carouselAutoPlay = true;

  @override
  void initState() {
    super.initState();
    _city = widget.city;
    _loadJobs(_city);
  }

  Future<void> _loadJobs(String? city) async {
    try {
      final jobs = await _jobService.getjobsByCity(city ?? '');
      setState(() {
        _jobs = jobs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.height;
    return BaseLayout(
      title: 'Confira algumas vagas.',
      showDrawer: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _city == null || _city!.isEmpty
                        ? 'Digite sua cidade para procurar vagas próximas a voce!'
                        : 'Mostrando vagas para $_city',
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Sua cidade',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) async {
                      if (value.isNotEmpty) {
                        await LocalStorage.saveCity(value);
                        setState(() {
                          _city = value;
                        });
                        await _loadJobs(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Text(
            widget.city == null || widget.city!.isEmpty
                ? 'Exibindo todas as vagas'
                : 'Exibindo vagas para $_city',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _jobs.isEmpty
                ? Center(child: const Text('Nenhuma vaga encontrada.'))
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CarouselSlider.builder(
                          carouselController: _controller,
                          itemCount: _jobs.length,
                          itemBuilder: (context, index, realIndex) =>
                              JobCard(job: _jobs[index]),
                          options: CarouselOptions(
                            height: screenSize * 0.6,
                            enableInfiniteScroll: true,
                            enlargeCenterPage: true,
                            autoPlay: _carouselAutoPlay,
                            pauseAutoPlayOnTouch: true,
                            autoPlayCurve: Curves.easeInOut,
                            autoPlayInterval: Duration(seconds: 4),
                            autoPlayAnimationDuration: Duration(
                              milliseconds: 450,
                            ),
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                                if (reason ==
                                    CarouselPageChangedReason.manual) {
                                  _carouselAutoPlay = false;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _jobs.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == entry.key
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
