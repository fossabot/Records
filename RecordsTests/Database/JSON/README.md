Performances.json


Changes here may effect tests.
An import is permanent unless deleted via the UI by the user.
Scenario 1: You remove a performance from this JSON file.
- It still exists in the database as no delete event occurs.
- Performers are not deleted either.
Scenario 2: You change a performer for an existing performance.
- Example: PerformanceA consists of PerformerA + PerformerB.
- You change PerformanceA so it now consists of PerformerA + PerformerC
- The outcome : Database has PerformanceA with PerformerA + PerformerC AND Database has PerformanceA with PerformerA + PerformerB
An import is permanent unless deleted via the UI by the user.

Events.json

Changes here may effect unit tests.
An import is permanent unless deleted via the UI by the user.

Parties.json

Changes here may effect unit tests.
An import is permanent unless deleted via the UI by the user.
