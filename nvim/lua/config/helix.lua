-- i<Esc> won't move the cursor at all, while a<Esc> will move the cursor
-- one to the right. I prefer this, as I use i more than a.
inoremap("<Esc>", "<Esc>l")

-- match-in-word and match-around-word
nnoremap("mi", "vi")
nnoremap("ma", "va")
