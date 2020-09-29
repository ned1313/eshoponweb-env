$csv = Import-Csv ./FakeNameGenerator.com_13f33441.csv
$uri = ""

ForEach ($r in $csv){
    $name = $r.GivenName + "+" + $r.Surname
    $address = $r.StreetAddress.Replace(" ","+")
    $title = $r.Occupation.Replace(" ","+")
    $salary = $r.Centimeters
    $body = "name=" + $name + "&address=" + $address + "&position=" + $title + "&salary=" + $salary
    Invoke-WebRequest -Uri $uri -Method Post -Body $body
}