Backbase Assignment

Architecture

I believe architecture and patterns should be decided on a project basis, that being said i've decided to use MVVM and "closure" style pattern. 
While i believe protocol pattern adds to the readability of the project it also adds complexity, coupling and time. 
I also believe closures are more "Switfy" than protocols.

Search

Ideally a binary search would be advised to filter cities, but since i've used a custom object and string matching isn't the case on this type of situation, a manual filtering wasn't that bad considering the time given.
It has a gain of around 50% to 70% from filtering using Swift.

Unit Test

Test are not complex but makes sure the search works on possible scenarios.


