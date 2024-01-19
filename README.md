# GitHub Repositories App

GitHub Repositories App is a mobile application that allows users to explore repositories from selected organizations on GitHub. The app utilizes the GitHub API to fetch repository data and provides features like organization-based filtering, repository search, detailed repository information, and the ability to add repositories to favorites.

## Features

- View repositories from organizations:
  - [Algorand](https://github.com/algorand)
  - [Perawallet](https://github.com/perawallet)
  - [Algorand Foundation](https://github.com/algorandfoundation)
  
- Filter repositories by organization.
- Search repositories in the list.
- View detailed information for a repository by tapping on the repository item.
- Add repositories to favorites.
- Check whether a repository is in the favorites list.

## Implementation Details

### Technologies Used

- Swift programming language.
- UIKit framework for building the user interface.
- GitHub API for fetching repository data.
- User Defaults for storing favorite repositories.

### Project Structure

The project follows a standard MVC (Model-View-Controller) architecture:

- **MainViewController:** Displays the list of repositories, and handles filtering, searching, and navigation to the detail screen.
- **DetailViewController:** Shows detailed information about a repository and allows users to add it to favorites.
- **MainViewModel:** Manages the repositories and favorites logic.
- **DetailViewModel:** Manages the data for the DetailViewController.

### User Defaults

User Defaults is used to store the list of favorite repositories. When a user adds or removes a repository from favorites, the changes are reflected in the User Defaults to persist the user's preferences across app sessions.

## How to Run the Project

1. Clone the repository.
2. Open the Xcode project file.
3. Build and run the application on a simulator or device.

Feel free to explore and enhance the app as you wish. Contributions are welcome!

## Additional Features

You are encouraged to add any additional features or improvements to the app based on your preferences and creativity. Consider enhancing the user interface, adding sorting options, or implementing additional interactions.

## Author

Onur

## License

This project is licensed under the [MIT License](LICENSE).
