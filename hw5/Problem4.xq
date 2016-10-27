(: Yijia Liu
	CSE 414
	HW5
:)

(:Problem 4 :)

<result>
	<country>
		<name>United States</name>	
		{ 
		for $x in doc("mondial.xml")//country[name = "United States"],
		$y in $x/province[population > 11000000]
		order by $y/population/text() descending
		return 
		<state>
			<name>
				{$y/name/text()}
			</name>
			<population_ratio>
				{$y/population/text() div $x/population/text()}
			</population_ratio>
		</state>
		}
	</country>
</result>

(:Result
<result>
  <country>
    <name>United States</name>
    <state>
      <name>California</name>
      <population_ratio>0.12109258370833294</population_ratio>
    </state>
    <state>
      <name>Texas</name>
      <population_ratio>0.07294959666165857</population_ratio>
    </state>
    <state>
      <name>New York</name>
      <population_ratio>0.06806319172620687</population_ratio>
    </state>
    <state>
    ...
  </country>
</result>
:)