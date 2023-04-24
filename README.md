# manabox-collection-to-deck

Manabox is my favorite app for managing a Magic: The Gathering collection. But while it’s phenomenal in most aspects, I got really annoyed by the card import / export mechanics.

There are two ways to store cards in Manabox. There’s a _Collection_, which holds all of the cards I own. Then, there are _Decks_, which, in my opinion, should be constructed from cards within my _Collection_.

However, they’re not. There’s a normal search function to add cards to a _Deck_ separately from those in a _Collection_. For those who want to create a _Deck_ from a list of cards, there’s a text box to paste card data. Conveniently, the collection tab also has an export feature that creates a CSV list of the cards in my collection. However, the CSV exported by the _Collection_ is rejected by the import tool in _Decks_ 🤦‍♂️. I tried a few ways to get around it but had no luck.

I found this hugely annoying, so I wrote an OCaml tool to turn a _Collection_ CSV into a format that can be handled by the _Deck_ import feature. I wrote most of it while in Philosophy class, so there are definitely places to improve, but it was a fun, hacky way to add a feature to a product I like.

Here's a [YouTube video](https://youtube.com/shorts/X90nL3ckDDI?feature=share) with the issue referenced above. The final file I used was `output/deck.txt`.

# Setup

If you'd like to use this tool for your own Manabox purposes, awesome!
First, you'll need to clone the repo and install OCaml and its dependencies. This tool also requires a csv module (`opam install csv`).

Once your OCaml environment is configured, follow the steps below:

1. Generate your collection CSV on Manabox.
2. Replace the collection.csv in `/input` with your CSV from Manabox. If you name something other than `collection.csv`, you'll need to update coll_to_deck's `cIN_FILENAME` accordingly.
3. Specify any additional configurations in `coll_to_deck.ml`. Output can be printed, converted to a CSV, or converted to raw text. I had the best luck with raw text (.txt output).
4. Run `make all` from the command line.
5. Run the executable: `./coll_to_deck.byte`.
6. Import the output data as a new deck in Manabox.
