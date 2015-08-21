# DCS-LAC
Late Activation Script for Playable Aircraft

Makes it possible to enable and disable playable aircraft using flags

If an aircraft if disabled, a message will be shown to the user  and the aircraft destroyed after 10 seconds if a specified flat isn't set.

To Setup, load this Script as a DO SCRIPT FILE at mission start

Call lac.disableAircraft("heli 1", 1000,"This aircraft cannot be used yet. In 10 seconds you will be removed from the Aircraft") as a DO SCRIPT after loading the file
Where "heli 1" is the NAME of the unit to disable, 1000 is the flag it keeps checking until its true, and the final argument is the message to display to the user.

Warning: If the flag is later set to FALSE, the player will be thrown out of the aircraft

You can also reserve aircraft using:

lac.reserveAircraft("Impala 1", "VSAAF","Sorry this aircraft is for VSAAF members only!") as a DO SCRIPT
