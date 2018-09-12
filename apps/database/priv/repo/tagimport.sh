cat taglist.txt | awk '{ print "Repo.insert!(%ModTag{ name: \"" $0 "\" })" }'
