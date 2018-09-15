#!/bin/sh

echo "alias Database.Repo
alias Database.ModTag

# import our tags
Repo.insert_all(
  ModTag,
  ["
cut -d';' -f1 < taglist.txt | awk '{ print "    %{name: \"" $0 "\"}," }'
echo "  ],
  []
)"
