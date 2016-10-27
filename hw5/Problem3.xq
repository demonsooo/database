(: Yijia Liu
	CSE 414
	HW5
:)

(:Problem 3 :)

<result>
	<country>
		<name>United States</name>
		{
		for $x in doc ("mondial.xml")//country[name = "United States"]/province
		order by $x/population/text() div $x/area/text() descending
		return
		<state>
			<name>
				{$x/name/text()}
			</name>
			<population_density>
				{$x/population/text() div $x/area/text()}
			</population_density>
		</state>
	}
	</country>
</result>

(: Results
<result>
  <country>
    <name>United States</name>
    <state>
      <name>Distr. Columbia</name>
      <population_density>2955.106145251397</population_density>
    </state>
    <state>
      <name>New Jersey</name>
      <population_density>399.28842721142405</population_density>
    </state>
    <state>
      <name>Rhode Island</name>
      <population_density>314.56801529149413</population_density>
    </state>
    <state>
      <name>Massachusetts</name>
      <population_density>285.13260312281517</population_density>
    </state>
    ...
  </country>  
</result>
:)