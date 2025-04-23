<html>
	<head>
		<title>&lt;CFPRINT&gt;</title>
	</head>
	<body>
	<h1>&lt;CFPRINT&gt;</h1>
	
	<div>
		<a href="https://helpx.adobe.com/coldfusion/cfml-reference/coldfusion-tags/tags-p-q/cfprint.html">ACF</a>
	</div>
	<hr>
	WIP.......
<cfscript>
	// wip
	printTag = new Print(false);

	dump(var=printTag.metadata.attributes, expand=true);
	echo("(")
	loop collection=#printTag.metadata.attributes# key="k" value="v" {
		if (v.required)
			echo(" required " );
		echo( v.type & " " &  k );
		if (!v.required)
			echo('="' &  v.default &    '"')
		echo(  ", " );
	}
	echo(")")

	try {
		printTag.onStartTag({
			hello:"lucee"
		});
	} catch (e){
		dump(e.message);
	}

	try {
		printTag.onStartTag({
			printer:"ipp://localhost"
		});
	} catch (e){
		dump(e.message);
	}

	try {
		printTag.onStartTag({
			printer:"ipp://localhost",
			source:getTempFile("","cfprint", "pdf")
		});
	} catch (e){
		echo(e);
	}
</cfscript>
