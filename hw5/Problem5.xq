(: Yijia Liu
	CSE 414
	HW5
:)

(:Problem 5 :)

<result>
	{
	for $x in  doc("mondial.xml")//country,
		$y in doc("mondial.xml")/mondial
	let $z := $y//mountain[@country = $x/@car_code][height > 2000]
	where count($z) >= 3
	return
	for $a in distinct-values($z/@country)
	return 
	<country>
		<name>
			{$x[@car_code = $a]/name/text()}
		</name>		
		{
		for $m in $z
		return 
		<mountains>
			<name>
				{$m/name/text()}
			</name>
			<height>
				{$m/height/text()}
			</height>
		</mountains>
		}		
	</country>
	}
</result>

(:Result
<result>
  <country>
    <name>Spain</name>
    <mountains>
      <name>Pico de Aneto</name>
      <height>3404</height>
    </mountains>
    <mountains>
      <name>Torre de Cerredo</name>
      <height>2648</height>
    </mountains>
    <mountains>
      <name>Pico de Almanzor</name>
      <height>2648</height>
    </mountains>
    <mountains>
      <name>Moncayo</name>
      <height>2313</height>
    </mountains>
    <mountains>
      <name>Mulhacen</name>
      <height>3482</height>
    </mountains>
    <mountains>
      <name>Pico de Teide</name>
      <height>3718</height>
    </mountains>
    <mountains>
      <name>Roque de los Muchachos</name>
      <height>2426</height>
    </mountains>
  </country>
  <country>
    <name>Italy</name>
    <mountains>
      <name>GranParadiso</name>
      <height>4061</height>
    </mountains>
    <mountains>
      <name>Marmolata</name>
      <height>3343</height>
    </mountains>
    <mountains>
      <name>Gran Sasso</name>
      <height>2912</height>
    </mountains>
    <mountains>
      <name>Etna</name>
      <height>3323</height>
    </mountains>
  </country>
  <country>
    <name>Switzerland</name>
    <mountains>
      <name>GrandCombin</name>
      <height>4314</height>
    </mountains>
    <mountains>
      <name>Finsteraarhorn</name>
      <height>4274</height>
    </mountains>
    <mountains>
      <name>Crap_Sogn_Gion</name>
      <height>2228</height>
    </mountains>
  </country>
  ...
</result>
:)
