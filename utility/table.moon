append = (tab1, tab2) ->
  for i=1,#tab1
    tab1[#tab1+1] = tab2[i]
  return tab1

{
  :append
}
