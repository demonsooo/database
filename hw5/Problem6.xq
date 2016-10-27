(: Yijia Liu
	CSE 414
	HW5
:)

(:Problem 6 :)

<html>
	<head>
		<title> </title>
	</head>
	<body>
		<h1>
		</h1>
		{
		for $x in doc("mondial.xml")//river[count(located)>=2]
		order by count($x/located) descending
		return 
		<u1>
			<li>
				<div> {$x/name/text()}</div>
				<ol>
				{
				for $y in doc("mondial.xml")//country[@car_code = $x/located/@country]
				return 
					<li>
					{$y/name/text()}
					</li>
				}
				</ol>
			</li>
		</u1>
		}
	</body>
</html>

(:Result
<html>
  <head>
    <title/>
  </head>
  <body>
    <h1/>
    <u1>
      <li>
        <div>Donau</div>
        <ol>
          <li>Austria</li>
          <li>Germany</li>
          <li>Hungary</li>
          <li>Ukraine</li>
          <li>Romania</li>
        </ol>
      </li>
    </u1>
    <u1>
      <li>
        <div>Rhein</div>
        <ol>
          <li>France</li>
          <li>Austria</li>
          <li>Germany</li>
          <li>Switzerland</li>
          <li>Netherlands</li>
        </ol>
      </li>
    </u1>
    <u1>
      <li>
        <div>Paatsjoki</div>
        <ol>
          <li>Russia</li>
          <li>Finland</li>
          <li>Norway</li>
        </ol>
      </li>
    </u1>
    ...
  </body>
</html>
:)