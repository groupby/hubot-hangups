import unittest
from unittest.mock import Mock
from unittest.mock import patch
import asyncio
from ..hangupsbot import HangupsBot

import inspect
import os

dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
dir = os.path.dirname(dir)
#[ws1 hubot-hangups (master)] python3.3 -m HangoutsBot.tests.test_hangupsbot

class TestHangupsBot(unittest.TestCase):

    def setUp(self):
        self.bot = HangupsBot('{}/cookies.txt'.format(dir), '{}/config.json'.format(dir))

    def test_send_message_segments(self):
        mock = Mock()
        something = asyncio.Future()
        something.set_result('Done!')
        attrs = {'send_message.return_value': something, 'done.return_value': True}
        mock.configure_mock(**attrs)

        self.bot.send_message_segments(mock, ['some', 'data'])

        self.assertTrue(mock.send_message.called)

    @patch('hangups.ChatMessageSegment')
    def test_send_message(self, MockClass1):
        mock = Mock()
        text = 'something'
        something = asyncio.Future()
        something.set_result('Done!')
        attrs = {'send_message.return_value': something, 'done.return_value': True}
        mock.configure_mock(**attrs)

        self.bot.send_message(mock, text)

        assert MockClass1.from_str.called

if __name__ == '__main__':
    # suite = unittest.TestLoader().loadTestsFromTestCase(TestSequenceFunctions)
    # unittest.TextTestRunner(verbosity=2).run(suite)
    unittest.main()