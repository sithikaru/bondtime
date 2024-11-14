// audio_guidance_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioGuidanceScreen extends StatefulWidget {
  const AudioGuidanceScreen({super.key});

  @override
  _AudioGuidanceScreenState createState() => _AudioGuidanceScreenState();
}

class _AudioGuidanceScreenState extends State<AudioGuidanceScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  final String paragraph =
      "Welcome! Today, we're going to play a fun color discovery game with your child. First, gather a few small items from around the house in different colors, like red, blue, yellow, and green. Pause the audio if you need a moment. "
      "Now that you have the items, sit with your child in a comfortable spot. Place the items in front of your child where they can see and reach them. "
      "Pick up a colored item and say the color out loud, like, 'This is red.' Let your child repeat the color back to you. Try this with each color you have.";

  List<String> sentences = [];
  int currentSentenceIndex = 0;
  bool isPaused = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    sentences = _splitParagraphIntoSentences(paragraph);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);
    _startReading();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _animationController.dispose();
    super.dispose();
  }

  // Split the paragraph into sentences based on periods and spaces
  List<String> _splitParagraphIntoSentences(String text) {
    final regex = RegExp(r'(?<=\.)\s+');
    return text.split(regex);
  }

  Future<void> _startReading() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);

    _readCurrentSentence();
  }
    Future<void> _readCurrentSentence() async {
    if (currentSentenceIndex < sentences.length) {
      String currentText = sentences[currentSentenceIndex].trim();

      setState(() {
        // Display the current sentence
      });

      await _flutterTts.speak(currentText);

      _flutterTts.setCompletionHandler(() {
        setState(() {
          // Move to the next sentence when the current one is done
          currentSentenceIndex++;
          if (currentSentenceIndex < sentences.length) {
            _readCurrentSentence(); // Recursively call to read the next sentence
          } else {
            _flutterTts.stop(); // Stop TTS when finished
            _animationController.stop(); // Stop pulsing animation
          }
        });
      });
    }
  }

  void _replayParagraph() {
    _flutterTts.stop();
    currentSentenceIndex = 0; // Reset to the beginning
    _startReading();
  }

  void _pauseOrResume() async {
    if (isPaused) {
      _animationController.repeat(reverse: true);
      _readCurrentSentence();
    } else {
      await _flutterTts.pause();
      _animationController.stop();
    }
    setState(() {
      isPaused = !isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFF8E4D7),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: ScaleTransition(
                  scale: _animationController,
                  child: const Icon(
                    Icons.graphic_eq,
                    size: 100,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                currentSentenceIndex < sentences.length
                    ? sentences[currentSentenceIndex].trim()
                    : "End of guidance", // Shows the current sentence or end message
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFD8C3B4),
                  fontFamily: 'Trueno',
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: _replayParagraph,
                    child: Column(
                      children: const [
                        Icon(Icons.replay, color: Color(0xFFD8C3B4)),
                        SizedBox(height: 5),
                        Text(
                          'replay',
                          style: TextStyle(
                            color: Color(0xFFD8C3B4),
                            fontFamily: 'Trueno',
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _pauseOrResume,
                    child: Column(
                      children: [
                        Icon(
                          isPaused ? Icons.play_arrow : Icons.pause,
                          color: Color(0xFFD8C3B4),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          isPaused ? 'resume' : 'pause',
                          style: const TextStyle(
                            color: Color(0xFFD8C3B4),
                            fontFamily: 'Trueno',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
