## hangups

hangups is the first third-party instant messaging client for Google
Hangouts. The [original version](https://github.com/tdryer/hangups) by tdryer includes both a Python library and a reference client with a
text-based user interface, but for our purposes will cut it down to the just the protocol eventually.

Unlike its predecessor Google Talk, Hangouts uses a proprietary,
non-interoperable protocol. hangups is implemented by reverse-engineering
this protocol, which allows it to support features like group messaging that
aren't available in clients that connect via XMPP.

hangups is still in an early stage of development.
