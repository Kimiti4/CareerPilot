import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:careerpilot_ai/features/dashboard/dashboard_screen.dart';
import 'package:careerpilot_ai/features/settings/settings_screen.dart';
import 'package:careerpilot_ai/features/welcome/welcome_screen.dart';
import 'package:careerpilot_ai/shared/widgets/workflow_placeholder_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/cv-import',
        name: 'cv-import',
        builder: (context, state) => WorkflowPlaceholderScreen(
          title: 'CV Import',
          checkpointTag: 'CP-02',
          summary: 'Select a PDF CV from Android storage, validate size/format, and inspect extracted text.',
          plannedControls: const [
            'Android PDF file picker',
            'Corrupted / encrypted / scanned PDF rejection',
            'Extracted text preview',
          ],
          nextStepLabel: 'Next: Add Job Description',
          onNextStep: () => context.push('/job-description'),
        ),
      ),
      GoRoute(
        path: '/job-description',
        name: 'job-description',
        builder: (context, state) => WorkflowPlaceholderScreen(
          title: 'Job Description',
          checkpointTag: 'CP-03',
          summary: 'Paste or edit the target job description to compare against your CV evidence.',
          plannedControls: const [
            'Multi-line job description editor',
            'Character counter and clear control',
            'Target role selector',
          ],
          nextStepLabel: 'Next: Analyse Compatibility',
          onNextStep: () => context.push('/cv-analysis'),
        ),
      ),
      GoRoute(
        path: '/cv-analysis',
        name: 'cv-analysis',
        builder: (context, state) => WorkflowPlaceholderScreen(
          title: 'CV Analysis',
          checkpointTag: 'CP-03',
          summary: 'Review indicative match score, explicitly supported skills, weak evidence, and gaps.',
          plannedControls: const [
            'Indicative match indicator',
            'Evidence status breakdown (Supported / Weak / Not Found)',
            'Explainable requirement mapping',
          ],
          nextStepLabel: 'Next: Review CV Suggestions',
          onNextStep: () => context.push('/cv-suggestions'),
        ),
      ),
      GoRoute(
        path: '/cv-suggestions',
        name: 'cv-suggestions',
        builder: (context, state) => const WorkflowPlaceholderScreen(
          title: 'CV Suggestions',
          checkpointTag: 'CP-03',
          summary: 'Compare original CV lines against grounded wording proposals and approve or reject each change.',
          plannedControls: [
            'Original vs. proposed side-by-side comparison',
            'Accept / Reject controls without modifying source PDF',
            'Reason for each suggestion',
          ],
        ),
      ),
      GoRoute(
        path: '/interview-setup',
        name: 'interview-setup',
        builder: (context, state) => WorkflowPlaceholderScreen(
          title: 'Interview Setup',
          checkpointTag: 'CP-05',
          summary: 'Select an interview category and verify microphone / TTS readiness before beginning.',
          plannedControls: const [
            'Role & interview category selection',
            'Device speech-recognition capability disclosure',
            'Permission explanation prior to start',
          ],
          nextStepLabel: 'Next: Start Interview Session',
          onNextStep: () => context.push('/interview-session'),
        ),
      ),
      GoRoute(
        path: '/interview-session',
        name: 'interview-session',
        builder: (context, state) => WorkflowPlaceholderScreen(
          title: 'Interview Session',
          checkpointTag: 'CP-05',
          summary: 'Complete the 3-question interview using Android TTS, mic recording, transcript review, or typed fallback.',
          plannedControls: const [
            'Question audio playback (TTS)',
            'Mic record / stop / retry controls',
            'Transcript review and manual text fallback',
          ],
          nextStepLabel: 'Next: View Interview Results',
          onNextStep: () => context.push('/interview-results'),
        ),
      ),
      GoRoute(
        path: '/interview-results',
        name: 'interview-results',
        builder: (context, state) => const WorkflowPlaceholderScreen(
          title: 'Interview Results',
          checkpointTag: 'CP-05',
          summary: 'Review transparent rubric scores (0–20 per question, 60 max) and saved transcripts.',
          plannedControls: [
            '4-dimension rubric breakdown',
            'Transcript review per question',
            'Practice recommendations',
          ],
        ),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
