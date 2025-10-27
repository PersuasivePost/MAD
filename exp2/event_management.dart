void main() {
  print("--- Event Management System Startup ---");
  var ems = EventManagementSystem();

  // 1. Add New Events
  print("\n[Admin] Adding new events...");
  ems.addEvent(
    Conference(
      "C101",
      "Global Dart Conference",
      DateTime(2025, 9, 15),
      "Tech City Hub",
      500,
      ["Dr. Ana Sharma", "Prof. Ben Lee"],
    ),
  );

  ems.addEvent(
    Workshop(
      "W201",
      "Flutter for Beginners",
      DateTime(2025, 10, 5),
      "Community College",
      30,
      "A laptop with Flutter SDK installed",
    ),
  );

  ems.addEvent(
    Meetup(
      "M301",
      "Dart Devs Meetup",
      DateTime(2025, 9, 20),
      "Downtown Cafe",
      50,
      "What's new in Dart 3?",
    ),
  );

  // 2. Register Participants
  print("\n[Admin] Registering participants...");
  ems.registerParticipant("C101", "Ashvatth");
  ems.registerParticipant("C101", "Joshi");
  ems.registerParticipant("W201", "Aswin");
  ems.registerParticipant("W201", "Atharva");
  ems.registerParticipant("M301", "Ashish");

  // Test capacity limit
  print("\n[Admin] Testing workshop capacity...");
  var smallWorkshop = Workshop(
    "W202",
    "Advanced Dart",
    DateTime(2025, 11, 1),
    "Online",
    2,
    "Dart SDK",
  );
  ems.addEvent(smallWorkshop);
  ems.registerParticipant("W202", "Frank");
  ems.registerParticipant("W202", "Grace");
  ems.registerParticipant("W202", "Heidi"); // This should fail

  // 3. Display Event and Participant Information
  print("\nDisplaying All Event Details ");
  ems.displayAllEvents();

  print("\nDisplaying Single Event Info (W201)");
  ems.findAndDisplayEvent("W201");

  // 4. Filter and Sort Events
  print("\nFiltering: Showing only Workshops");
  ems.displayEventsByType(EventType.workshop);

  print("\nSorting: Showing All Events by Date");
  ems.displayEventsSortedByDate();

  // 5. Calculate Statistics
  print("\nCalculating Statistics: Total Attendees per Type");
  ems.displayAttendeeStatistics();
}

// Encapsulation
class EventManagementSystem {
  List<Event> _events = [];

  // Helper function to find an event
  Event? _findEventById(String eventId) {
    try {
      return _events.firstWhere((event) => event.eventId == eventId);
    } catch (e) {
      return null;
    }
  }

  // 1. Add new event
  void addEvent(Event event) {
    _events.add(event);
    print("Event Added: ${event.title}");
  }

  // 2. Register participants
  void registerParticipant(String eventId, String name) {
    var event = _findEventById(eventId);
    if (event != null) {
      event.registerParticipant(name);
    } else {
      print("Error: Event with ID $eventId not found.");
    }
  }

  // 3. Display all event information
  void displayAllEvents() {
    if (_events.isEmpty) {
      print("No events scheduled.");
      return;
    }
    _events.forEach((event) {
      event.displayEventInfo();
    });
  }

  // 3b. Display specific event
  void findAndDisplayEvent(String eventId) {
    var event = _findEventById(eventId);
    if (event != null) {
      event.displayEventInfo();
    } else {
      print("Error: Event with ID $eventId not found.");
    }
  }

  // 4. Filter events
  void displayEventsByType(EventType type) {
    var filteredEvents = _events.where((event) => event.type == type);

    if (filteredEvents.isEmpty) {
      print("No events found of type $type.");
      return;
    }

    filteredEvents.forEach((event) {
      event.displayEventInfo();
    });
  }

  // 4b. Sort events
  void displayEventsSortedByDate() {
    // Create a new list to avoid modifying the original
    var sortedEvents = List<Event>.from(_events);

    // Functional Programming: Using sort() with a comparator function.
    sortedEvents.sort((a, b) => a.date.compareTo(b.date));

    sortedEvents.forEach((event) {
      event.displayEventInfo();
    });
  }

  // 5. Calculate statistics
  void displayAttendeeStatistics() {
    var stats = <EventType, int>{};

    for (var event in _events) {
      stats[event.type] = (stats[event.type] ?? 0) + event.attendeeCount;
    }

    print("Total Attendee Statistics by Event Type:");
    if (stats.isEmpty) {
      print("No attendees yet.");
      return;
    }

    stats.forEach((type, count) {
      print("$type: $count attendees");
    });
  }
}

// An 'enum' to define a fixed set of event types
enum EventType { conference, workshop, meetup }

// abstraction
abstract class Event {
  // encapsulation
  String _eventId;
  String _title;
  DateTime _date;
  String _location;
  List<String> _participants = [];
  int _capacity;
  EventType _type;

  // Constructor for the base class
  Event(
    this._eventId,
    this._title,
    this._date,
    this._location,
    this._capacity,
    this._type,
  );

  // Public "getters" to allow read-only access to private data
  String get eventId => _eventId;
  String get title => _title;
  DateTime get date => _date;
  String get location => _location;
  int get attendeeCount => _participants.length;
  int get capacity => _capacity;
  EventType get type => _type;

  // Public method to modify private data (in a controlled way)
  bool registerParticipant(String name) {
    if (attendeeCount < _capacity) {
      _participants.add(name);
      print("Success: $name registered for $title.");
      return true;
    } else {
      print(
        "Error: $title is full ($capacity/$capacity). Cannot register $name.",
      );
      return false;
    }
  }

  // polymorphism
  void displayEventInfo() {
    print("--- Event: $title ($eventId) ---");
    print("Type: $type");
    print("Date: ${_date.toLocal().toString().split(' ')[0]}"); // Format date
    print("Location: $location");
    print("Attendees: $attendeeCount / $_capacity");
    print(
      "Participants: ${_participants.isEmpty ? 'None yet' : _participants.join(', ')}",
    );
  }
}

// inheritance
class Conference extends Event {
  List<String> _speakers;

  Conference(
    String id,
    String title,
    DateTime date,
    String loc,
    int cap,
    this._speakers,
  ) : super(id, title, date, loc, cap, EventType.conference);

  List<String> get speakers => _speakers;

  // POLYMORPHISM
  @override
  void displayEventInfo() {
    super.displayEventInfo(); // 1. Call the parent method first
    // 2. Add its own specific info
    print("Speakers: ${speakers.join(', ')}");
    print("-------------------------------------------------");
  }
}

class Workshop extends Event {
  String _requiredMaterial;

  Workshop(
    String id,
    String title,
    DateTime date,
    String loc,
    int cap,
    this._requiredMaterial,
  ) : super(id, title, date, loc, cap, EventType.workshop);

  String get requiredMaterial => _requiredMaterial;

  @override
  void displayEventInfo() {
    super.displayEventInfo(); // 1. Call parent method
    // 2. Add specific info
    print("Required Material: $requiredMaterial");
    print("-------------------------------------------------");
  }
}

// Subclass 3: Meetup
class Meetup extends Event {
  String _topic;

  Meetup(
    String id,
    String title,
    DateTime date,
    String loc,
    int cap,
    this._topic,
  ) : super(id, title, date, loc, cap, EventType.meetup);

  String get topic => _topic;

  @override
  void displayEventInfo() {
    super.displayEventInfo(); // 1. Call parent method
    // 2. Add specific info
    print("Main Topic: $topic");
    print("-------------------------------------------------");
  } 
}
