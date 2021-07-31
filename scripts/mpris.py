#!/usr/bin/env python3

import sys
import dbus
from operator import itemgetter
import argparse
import re
from urllib.parse import unquote
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib
DBusGMainLoop(set_as_default=True)

class PlayerManager:
    def __init__(self, connect = True):
        self._connect = connect
        self._session_bus = dbus.SessionBus()
        self.players = {}

        self.print_queue = []
        self.connected = False
        self.player_states = {}

        self.refreshPlayerList()

        if self._connect:
            self.connect()
            loop = GLib.MainLoop()
            try:
                loop.run()
            except KeyboardInterrupt:
                print("interrupt received, stopping…")

    def connect(self):
        self._session_bus.add_signal_receiver(self.onOwnerChangedName, 'NameOwnerChanged')
        self._session_bus.add_signal_receiver(self.onChangedProperties, 'PropertiesChanged',
                                              path = '/org/mpris/MediaPlayer2',
                                              sender_keyword='sender')

    def onChangedProperties(self, interface, properties, signature, sender = None):
        if sender in self.players:
            player = self.players[sender]
            # If we know this player, but haven't been able to set up a signal handler
            if 'properties_changed' not in player._signals:
                # Then trigger the signal handler manually
                player.onPropertiesChanged(interface, properties, signature)
        else:
            # If we don't know this player, get its name and add it
            bus_name = self.getBusNameFromOwner(sender)
            if bus_name is None:
                return
            self.addPlayer(bus_name, sender)
            player = self.players[sender]
            player.onPropertiesChanged(interface, properties, signature)

    def onOwnerChangedName(self, bus_name, old_owner, new_owner):
        if self.busNameIsAPlayer(bus_name):
            if new_owner and not old_owner:
                self.addPlayer(bus_name, new_owner)
            elif old_owner and not new_owner:
                self.removePlayer(old_owner)
            else:
                self.changePlayerOwner(bus_name, old_owner, new_owner)

    def getBusNameFromOwner(self, owner):
        player_bus_names = [ bus_name for bus_name in self._session_bus.list_names() if self.busNameIsAPlayer(bus_name) ]
        for player_bus_name in player_bus_names:
            player_bus_owner = self._session_bus.get_name_owner(player_bus_name)
            if owner == player_bus_owner:
                return player_bus_name

    def busNameIsAPlayer(self, bus_name):
        return bus_name.startswith('org.mpris.MediaPlayer2')

    def refreshPlayerList(self):
        player_bus_names = [ bus_name for bus_name in self._session_bus.list_names() if self.busNameIsAPlayer(bus_name) ]
        for player_bus_name in player_bus_names:
            self.addPlayer(player_bus_name)
        if self.connected != True:
            self.connected = True
            self.printQueue()

    def addPlayer(self, bus_name, owner = None):
        player = Player(self._session_bus, bus_name, owner = owner, connect = self._connect, _print = self.print)
        self.players[player.owner] = player

    def removePlayer(self, owner):
        if owner in self.players:
            self.players[owner].disconnect()
            del self.players[owner]
        # If there are no more players, clear the output
        if len(self.players) == 0:
            _printFlush('')
        # Else, print the output of the next active player
        else:
            players = self.getSortedPlayerOwnerList()
            if len(players) > 0:
                self.players[players[0]].printStatus()

    def changePlayerOwner(self, bus_name, old_owner, new_owner):
        player = Player(self._session_bus, bus_name, owner = new_owner, connect = self._connect, _print = self.print)
        self.players[new_owner] = player
        del self.players[old_owner]

    # Get a list of player owners sorted by current status and age
    def getSortedPlayerOwnerList(self):
        players = [
            {
                'number': int(owner.split('.')[-1]),
                'status': 2 if player.status == 'playing' else 1 if player.status == 'paused' else 0,
                'owner': owner
            }
            for owner, player in self.players.items()
        ]
        return [ info['owner'] for info in reversed(sorted(players, key=itemgetter('status', 'number'))) ]

    # Get latest player that's currently playing
    def getCurrentPlayer(self):
        playing_players = [
            player_owner for player_owner in self.getSortedPlayerOwnerList()
            if
                self.players[player_owner].status == 'playing' or
                self.players[player_owner].status == 'paused'
        ]
        return self.players[playing_players[0]] if playing_players else None

    def print(self, status, player):
        self.player_states[player.bus_name] = status

        if self.connected:
            current_player = self.getCurrentPlayer()
            if current_player != None:
                _printFlush(self.player_states[current_player.bus_name])
            else:
                _printFlush('')
        else:
            self.print_queue.append([status, player])

    def printQueue(self):
        for args in self.print_queue:
            self.print(args[0], args[1])
        self.print_queue.clear()


class Player:
    def __init__(self, session_bus, bus_name, owner = None, connect = True, _print = None):
        self._session_bus = session_bus
        self.bus_name = bus_name
        self._disconnecting = False
        self.__print = _print

        self.metadata = { 'artist': '', 'title': '' }
        self._metadata = None

        self.status = 'stopped'
        if owner is not None:
            self.owner = owner
        else:
            self.owner = self._session_bus.get_name_owner(bus_name)

        self._obj = self._session_bus.get_object(self.bus_name, '/org/mpris/MediaPlayer2')
        self._properties_interface = dbus.Interface(self._obj, dbus_interface='org.freedesktop.DBus.Properties')
        self._introspect_interface = dbus.Interface(self._obj, dbus_interface='org.freedesktop.DBus.Introspectable')
        self._player_interface     = dbus.Interface(self._obj, dbus_interface='org.mpris.MediaPlayer2.Player')
        self._introspect = self._introspect_interface.get_dbus_method('Introspect', dbus_interface=None)
        self._getProperty = self._properties_interface.get_dbus_method('Get', dbus_interface=None)
        self._signals = {}

        self.refreshStatus()
        self.refreshMetadata()

        if connect:
            self.printStatus()
            self.connect()

    def connect(self):
        if self._disconnecting is not True:
            introspect_xml = self._introspect(self.bus_name, '/')
            if 'TrackMetadataChanged' in introspect_xml:
                self._signals['track_metadata_changed'] = self._session_bus.add_signal_receiver(self.onMetadataChanged, 'TrackMetadataChanged', self.bus_name)
            self._signals['seeked'] = self._player_interface.connect_to_signal('Seeked', self.onSeeked)
            self._signals['properties_changed'] = self._properties_interface.connect_to_signal('PropertiesChanged', self.onPropertiesChanged)

    def disconnect(self):
        self._disconnecting = True
        for signal_name, signal_handler in list(self._signals.items()):
            signal_handler.remove()
            del self._signals[signal_name]

    def refreshStatus(self):
        # Some clients (VLC) will momentarily create a new player before removing it again
        # so we can't be sure the interface still exists
        try:
            self.status = str(self._getProperty('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')).lower()
        except dbus.exceptions.DBusException:
            self.disconnect()

    def refreshMetadata(self):
        # Some clients (VLC) will momentarily create a new player before removing it again
        # so we can't be sure the interface still exists
        try:
            self._metadata = self._getProperty('org.mpris.MediaPlayer2.Player', 'Metadata')
            self._parseMetadata()
        except dbus.exceptions.DBusException:
            self.disconnect()

    def _print(self, status):
        self.__print(status, self)

    def _parseMetadata(self):
        if self._metadata != None:
            # Obtain properties from _metadata
            _artist = _getProperty(self._metadata, 'xesam:artist', [''])
            _title  = _getProperty(self._metadata, 'xesam:title', '')

            # Update metadata
            _artist_clean = re.sub(SAFE_TAG_REGEX, """\1\1""", _metadataGetFirstItem(_artist))
            _title_clean  = re.sub(SAFE_TAG_REGEX, """\1\1""", _metadataGetFirstItem(_title))

            # if the artist field is empty but the title field is in the form "* - *" we
            # will split the title on " - " and use those parts for artist/title. This
            # usually happens when there's something playing in a browser tab, the
            # artist field is empty and the title field contains both artist/title
            if len(_artist_clean.strip()) == 0 and _title_clean.count(' - ') == 1:
                _parts = _title_clean.rsplit(' - ')
                _artist_clean = _parts[0]
                _title_clean = _parts[1]

            self.metadata['artist'] = _artist_clean
            self.metadata['title']  = _title_clean

    def onMetadataChanged(self, track_id, metadata):
        self.refreshMetadata()
        self.printStatus()

    def onPropertiesChanged(self, interface, properties, signature):
        updated = False
        if dbus.String('Metadata') in properties:
            _metadata = properties[dbus.String('Metadata')]
            if _metadata != self._metadata:
                self._metadata = _metadata
                self._parseMetadata()
                updated = True
        if dbus.String('PlaybackStatus') in properties:
            status = str(properties[dbus.String('PlaybackStatus')]).lower()
            if status != self.status:
                self.status = status
                updated = True
        if dbus.String('Rate') in properties and dbus.String('PlaybackStatus') not in properties:
            self.refreshStatus()

        if updated:
            self.printStatus()

    def onSeeked(self, position):
        self.printStatus()

    def printStatus(self):
        if self.status == 'playing':
            metadata = { **self.metadata }
            # replace metadata tags in text
            text = re.sub(FORMAT_REGEX, '', FORMAT_STRING)
            # restore polybar tag formatting and replace any remaining metadata tags after that
            try:
                text = re.sub(r'􏿿p􏿿(.*?)􏿿p􏿿(.*?)􏿿p􏿿(.*?)􏿿p􏿿', r'%{\1}\2%{\3}', text.format_map(CleanSafeDict(**metadata)))
            except:
                print("Invalid format string")
            self._print(text)
        elif self.status == 'paused':
            self._print('Paused')
        else:
            self._print('')


def _dbusValueToPython(value):
    if isinstance(value, dbus.Dictionary):
        return {_dbusValueToPython(key): _dbusValueToPython(value) for key, value in value.items()}
    elif isinstance(value, dbus.Array):
        return [ _dbusValueToPython(item) for item in value ]
    elif isinstance(value, dbus.Boolean):
        return int(value) == 1
    elif (
        isinstance(value, dbus.Byte) or
        isinstance(value, dbus.Int16) or
        isinstance(value, dbus.UInt16) or
        isinstance(value, dbus.Int32) or
        isinstance(value, dbus.UInt32) or
        isinstance(value, dbus.Int64) or
        isinstance(value, dbus.UInt64)
    ):
        return int(value)
    elif isinstance(value, dbus.Double):
        return float(value)
    elif (
        isinstance(value, dbus.ObjectPath) or
        isinstance(value, dbus.Signature) or
        isinstance(value, dbus.String)
    ):
        return unquote(str(value))

def _getProperty(properties, property, default = None):
    value = default
    if not isinstance(property, dbus.String):
        property = dbus.String(property)
    if property in properties:
        value = properties[property]
        return _dbusValueToPython(value)
    else:
        return value

def _metadataGetFirstItem(_value):
    if type(_value) is list:
        # Returns the string representation of the first item on _value if it has at least one item.
        # Returns an empty string if _value is empty.
        return str(_value[0]) if len(_value) else ''
    else:
        # If _value isn't a list just return the string representation of _value.
        return str(_value)

class CleanSafeDict(dict):
    def __missing__(self, key):
        return '{{{}}}'.format(key)


_last_status = ''
def _printFlush(status, **kwargs):
    global _last_status
    if status != _last_status:
        print(status, **kwargs)
        sys.stdout.flush()
        _last_status = status

FORMAT_REGEX = re.compile(r'(\{:(?P<tag>.*?)(:(?P<format>[wt])(?P<formatlen>\d+))?:(?P<text>.*?):\})', re.I)
SAFE_TAG_REGEX = re.compile(r'[{}]')
FORMAT_STRING = re.sub(r'%\{(.*?)\}(.*?)%\{(.*?)\}', r'􏿿p􏿿\1􏿿p􏿿\2􏿿p􏿿\3􏿿p􏿿', '{artist} - {title}')
PlayerManager()
