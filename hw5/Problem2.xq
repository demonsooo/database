(: Yijia Liu
	CSE 414
	HW5
:)

(:Problem 2 :)

<result>
	{
	for $x in doc ("mondial.xml")//country[count(province/name/text())>20]
	order by count($x/province/name/text()) descending
	return 
	<country num_provinces = "{count($x/province/name/text())}">
		<name> {$x/name/text()} </name>
	</country>
	}
</result>

(: Results
<result>
  <country num_provinces="81">
    <name>United Kingdom</name>
  </country>
  <country num_provinces="80">
    <name>Russia</name>
  </country>
  <country num_provinces="73">
    <name>Turkey</name>
  </country>
  ...
</result>
:)