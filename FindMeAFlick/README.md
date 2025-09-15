//
//  README.md
//  FindMeAFlick

# Find Me A Flick!

## Overview
Minimalist iOS app (UIKit, MVC) that shows popular movies from TMDb. Users can view details and save favorites locally.

## Features
- List popular movies (TMDb)
- Movie detail view
- Search (local filter)
- Save favorites (UserDefaults)
- Unit tests for networking
- UI test skeletons

## Architecture
- **UIKit** using MVC for straightforward mapping of Views/Controllers/Models.
- **APIClient** handles networking (URLSession).
- **FavoritesManager** persists favorites via `UserDefaults` (fast for this challenge).
- **ImageLoader** with `NSCache` for poster images.

