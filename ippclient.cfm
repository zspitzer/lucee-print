<html>
	<head>
		<title>ipp client</title>
	</head>
	<body>
	<h1>ipp client</h1>
	
	<div>
		<a href="https://github.com/gmuth/ipp-client-kotlin">https://github.com/gmuth/ipp-client-kotlin</a> |
		<a href="https://javadoc.io/doc/de.gmuth/ipp-client/latest/index.html">javadocs</a>
	</div>
	<hr>
<cfscript>
	ippclient= new ippClient();
	samplefile = getTempFile("", "print","pdf");

	cfdocument(format="PDF" filename="#samplefile#" overwrite=true){
		echo("<h1>Hi from lucee</h1>");
	}
	
	info = ippclient.print("ipp://192.168.178.65", samplefile);

	abort;
	dump(info["printer-state"]);
	dump(info["printer-state"].getClass());
	

</cfscript>
