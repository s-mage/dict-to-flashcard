dict-to-flashcard
-----------------

Get definitions from Apple Dictionary and convert to Logseq flashcards.

### Prerequisites

* [rg](https://github.com/BurntSushi/ripgrep). `brew install ripgrep`
* [apple-peeler](https://github.com/solarmist/apple-peeler). `pip install apple-peeler`

Setup: extract XML from the dictionaries.

1. Read README of apple-peeler, but basically

```
export DICT_BASE="/System/Library/AssetsV2/com_apple_MobileAsset_DictionaryServices_dictionaryOSX/"
apple-peeler --out apple-peeler-output # you will need this folder as part of path to xml config value
```

2. Configure this workflow

```
Path to xml: apple-peeler-output/Croatian.xml -- replace with the actual dictionary you want to use
Output file: file inside the logseq graph. Protip: use icloud to sync graph between devices.
```

Enjoy. Or [send patches](https://github.com/s-mage/dict-to-flashcard). Or both.
