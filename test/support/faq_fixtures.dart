import 'package:icebot/icebot.dart';

/// A small, deterministic FAQ set shared across tests.
const resetPassword = FaqItem(
  id: '1',
  question: 'How do I reset my password?',
  answer: 'Open Settings and choose Change Password.',
  keywords: ['password', 'reset', 'forgot'],
  alternativeQuestions: ['I forgot my password', 'cannot log in'],
  category: 'Account',
  popularity: 100,
  isPinned: true,
  relatedQuestionIds: ['2'],
);

const changeEmail = FaqItem(
  id: '2',
  question: 'How do I change my email address?',
  answer: 'Go to Settings > Account > Email.',
  keywords: ['email', 'change', 'address'],
  category: 'Account',
  popularity: 50,
);

const deleteAccount = FaqItem(
  id: '3',
  question: 'How do I delete my account?',
  answer: 'Contact support to delete your account.',
  keywords: ['delete', 'account', 'remove'],
  category: 'Account',
  popularity: 10,
  isPinned: true,
);

const contactSupport = FaqItem(
  id: '4',
  question: 'How do I contact support?',
  answer: 'Email us at support@example.com.',
  keywords: ['contact', 'support', 'help'],
  category: 'Support',
  popularity: 30,
);

const sampleFaqs = <FaqItem>[
  resetPassword,
  changeEmail,
  deleteAccount,
  contactSupport,
];

/// A repository whose [loadFaqs] always throws, for exercising error paths.
class ThrowingFaqRepository implements FaqRepository {
  @override
  Future<List<FaqItem>> loadFaqs() async => throw StateError('boom');

  @override
  Future<void> refresh() async => throw StateError('boom');
}
