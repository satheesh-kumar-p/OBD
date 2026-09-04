# UI Changes

This document describes the user-interface changes made in the Scout OBD application.

## Home Screen

- Added a new `VERSION` item to the sidebar navigation.
- Added the Version screen to the main page navigation so it can be opened like the other application screens.
- Kept the existing system, drive, power, compute, sensor, communication, and debug screens available through the same navigation layout.

## System Screen

- Changed the system dashboard from a vertically scrolling layout to a fixed-height dashboard that fits the available screen area.
- Arranged the subsystem sections into proportional areas so the middle section receives more space when it contains more items.
- Reduced spacing between sections and grid tiles to show more status information at once.
- Made subsystem names and status values uppercase, centered, and easier to scan.
- Improved tile sizing so the six-column grid adapts to the available width and height.
- Preserved color-based status highlighting while simplifying the tile presentation.

## Common Status Bar

- Adjusted spacing between mission controls, telemetry indicators, and the central clock to make the top bar more compact and balanced.
- Reduced divider margins so more status information fits across the header.
- Kept the clock centered while giving the mission and telemetry groups clearer separation.

## Mission and Safety Indicators

- Increased the size and visual weight of the arm status label.
- Simplified the arm status presentation by emphasizing the text state instead of showing the status icon.
- Updated safety, hand-controller, GCS, and mission-mode indicators for the revised top-bar layout.

## Battery Indicators

- Changed the battery display from a horizontal battery graphic to a vertical battery indicator.
- Added a visible battery terminal above the battery body.
- Displayed the state-of-charge value and battery label beside the indicator.
- Added a charging bolt indicator to the battery status display.
- Updated the fill direction so the battery level rises vertically.

## Date and Time Display

- Split the date and time into two separate centered lines.
- Increased the size and weight of the time and date for improved visibility.
- Used a monospaced style to keep the values aligned and readable.

## Version Screen

- Added a dedicated system checksum screen under the `VERSION` navigation item.
- Displays the application name, version, and SHA-256 checksum in separate status cards.
- Sorts application entries alphabetically for consistent presentation.
- Uses status colors to distinguish valid checksum information from unknown checksum values.
- Shows a waiting message when checksum packets have not yet been received.

## Result Screenshot

Paste the screenshot of the updated UI below:





