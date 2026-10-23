# synxit.com

This is the source code for the synxit.com website. It is built with [Zola] and uses the [devlab-theme], modified to fit the needs of the synxit project.

## Getting started

1. Install [Zola](https://www.getzola.org/documentation/getting-started/installation/)
2. Clone this repository
3. Run `zola serve` to start the development server

## Structure

The website is structured as follows:

- `content/`: Contains the content of the website, including pages, blog posts, and documentation.
- `static/`: Contains static files such as images, fonts, and other assets.
- `templates/`: Overrides the templates provided by the [devlab-theme] to customize the layout and structure of the website.
- `themes/devlab-theme/`: submodule containing the [devlab-theme], which provides the layout and styling for the website.

[Zola]: https://www.getzola.org/
[devlab-theme]: https://codeberg.org/RiPetitor/devlab-theme
