print '(2(L1,1X))', row%start_with('1999'), row%end_with('edition')
print '(A,I0)', 'second comma at ', row%index(',', occurrence=2)
print '(A,I0)', 'last comma at   ', row%index(',', back=.true.)
