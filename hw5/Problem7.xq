(: Yijia Liu
	CSE 414
	HW5
:)

(:Problem 7 :)

<result>
	<waterbody>
	<name>Pacific Ocean</name>
  	{ 
      for $x in doc("mondial.xml")//sea[name/text() = "Pacific Ocean"]/located   
      return
      	for $y in doc("mondial.xml")//country[@car_code = $x/@country]
      	return
      	<adjacent_countries>
      		<country>
      			<name>
      				{$y/name/text()}
      			</name>
      		</country>
      	</adjacent_countries>
      }
    </waterbody>
</result>

(: Result
<result>
  <waterbody>
    <name>Pacific Ocean</name>
    <adjacent_countries>
      <country>
        <name>Russia</name>
      </country>
    </adjacent_countries>
    <adjacent_countries>
      <country>
        <name>Japan</name>
      </country>
    </adjacent_countries>
    <adjacent_countries>
      <country>
        <name>Mexico</name>
      </country>
    </adjacent_countries>
    ...
  </waterbody>
</result>
:)