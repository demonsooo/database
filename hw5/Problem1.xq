(: Yijia Liu
	CSE 414
	HW5
:)

(:Problem 1 :)

<result>
	<country>
		<name>Peru</name>		
		{
		for $x in doc ("mondial.xml")//country[name = "Peru"]//city/name/text()
		order by $x
		return 
		<city>
			<name>
				{$x}
			</name>
		</city>
	}
	</country>
</result>



(: Results
<result>
  <country>
    <name>Peru</name>    
    <city>
      <name>Abancay</name>
    </city>
    <city>
      <name>Arequipa</name>
    </city>
    <city>
      <name>Ayacucho</name>
    </city>
    ...
  </country>
</result>
:)
	