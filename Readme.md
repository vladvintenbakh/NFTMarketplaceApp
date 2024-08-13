# FakeNFT

# Links

[Figma Design](https://www.figma.com/file/k1LcgXHGTHIeiCv4XuPbND/FakeNFT-(YP)?node-id=96-5542&t=YdNbOI8EcqdYmDeg-0)

# Purpose

The app allows its users to view and purchase NFTs (Non-Fungible Tokens). The purchase functionality is simulated with a mock server.

Main usage:
- browsing NFT collections
- viewing and buying NFTs
- viewing user rankings

Note: The catalog tab is currently not implemented, and a placeholder is displayed instead.

# Brief app description

The user can:
- view NFT collections in the catalog
- view the catalog info, selected collection, and specific NFTs
- add NFTs to favorites
- add to/remove from cart, purchase the NFTs in the cart
- view user profiles and their rankings
- view their own profile information (including favorites and owned NFTs)

# Functional requirements

## Cart

**Main cart screen**

The list of NFTs added to the cart is shown in a UITableView. Each NFT card contains:
- an image
- name
- rating
- price

Each cell also has a button to remove the corresponding item from the cart. If the user taps it, a confirmation screen is displayed. It contains:
- the NFT image
- deletion confirmation text
- a button to confirm deletion
- a button to cancel deletion

In the top right, there is a sort button. The user can sort the cart items by price, rating, or name.

In the bottom part of the screen, there is a card that shows the number of NFTs in the order, total price, and a button to proceed to payment. The user can transition to the currency selection screen by pressing the button.

A loading indicator is displayed if the data is loading or being updated.

**Currency selection screen**

In this screen, the user can select the payment currency.

At the top of the screen, there is a navigation bar with the screen title and back button. A collection with available payment methods is displayed under it. Each currency cell contains:
- a logo
- full name
- abbreviation

In the bottom part of the screen, there is a label with a link to the user agreement (links to https://yandex.ru/legal/practicum_termsofuse/).

Under the user agreement link, there is a button to process the payment. Upon tapping it, a request is sent to the mock server. If the payment is successful, a screen informing the user of that is shown. It also has a button to return to the NFT catalog tab. If the payment fails, an alert is displayed with retry and cancel buttons.

## Profile

**Profile screen**

This screen shows user profile information. It contains:
- a profile image
- the user's name
- the user's bio

It also has a table with cells that link to the following screens: My NFTs, Favorites, About.

There is a button to edit the profile in the top right corner. If the user presses it, a screen pops up where the user's name, bio, website link for the About section, and profile image link can be edited.

**My NFTs screen**

This screen has a UITableView where each cell contains:
- an icon
- NFT name
- NFT creator
- price (in ETH)

In the top right, there is a sort button. The user can sort the NFTs by price, rating, or name.

A placeholder is shown if there are no NFTs to display.

**Favorites screen**

This screen contains a collection of NFTs that have been added to favorites. Each cell contains the following information:
- NFT icon
- heart icon
- NFT name
- rating
- price (in ETH)

Tapping the heart icon removes the NFT from favorites, and the collection automatically refreshes.

A placeholder is shown if there are no NFTs to display.

## Statistics

**User ranking screen**

This screen shows the user list in the form of a table. The following information is shown for each user:
- ranking spot
- profile image
- the user's name
- number of NFTs

In the top right, there is a sort button. The user can sort the users by name or ranking

Tapping a cell takes one to the user info screen for that specific user.

**User info screen**

This screen displays the following information about the user:
- profile image
- the user's name
- the user's bio

It also contains a button to show the user's website and a cell that links to the user's NFT collection.

**User NFT collection screen**

This screen contains a collection with the user's NFTs. Each cell contains the following information about the NFT:
- NFT icon
- heart icon
- NFT name
- rating
- price (in ETH)
- a button to add to/remove from cart

# Sorting the data

The following screens support the sorting functionality: main cart screen, My NFTs, user ranking screen. The sorting method selected by the user is persistently stored on the device. The previously selected value is restored after relaunching the app.

**Default sorting methods:**
- main cart screen - by name
- My NFTs screen - by rating
- user ranking screen - by ranking
