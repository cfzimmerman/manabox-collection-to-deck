# manabox-collection-to-deck

Manabox is my favorite app for digitally managing a Magic: The Gathering collection. But while it’s phenomenal in most aspects, I got really annoyed by the card import / export mechanics.

There are two ways to store cards in Manabox. There’s a *Collection*, which holds all of the cards I own. Then, there are *Decks*, which, in my opinion, should be constructed from cards within my *Collection*.

However, they’re not. There’s a normal search function to add cards to a *Deck* separately from those in a *Collection*. For those who want to create a *Deck* from a list of cards, there’s a text box to paste card data. Conveniently, the collection tab also has an export feature that creates a CSV list of the cards in my collection. However, the CSV exported by the *Collection* is rejected by the import tool in *Decks* 🤦‍♂️. I tried a few ways to get around it but had no luck.

I found this hugely annoying, so I wrote an OCaml tool to turn a *Collection* CSV into a format that can be handled by the *Deck* import feature. I wrote most of it while in class, so there are definitely places to improve, but it was a fun, hacky way to add a feature to a product I like.
