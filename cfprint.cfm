<cfscript>
	param name="url.printer" default="";
</cfscript>

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
	<cfset printers=getPrinterList()>
	<cfset found=false>
	<cfoutput>
		<form action=? method="get">
			<label>Printer
				<select name="printer">
					<cfloop list="#printers#" item="_printer">
						<option value="#_printer#"
							<cfif _printer eq url.printer>
								selected
								<cfset found=true>
							</cfif>
						>#_printer#</option>
					</cfloop>
					<cfif !found>
						<option value="" selected>-- please select a printer</option>
					</cfif>
				</select>
			</label>
			<input type="submit" name="go" value="select printer">
		</form>
	</cfoutput>
<cfscript>

	if (len(url.printer) eq 0) abort;

	echo("<h2>Using Printer [ #url.printer#] </h2>");
	
	printTag = new Print(false);

	//dump(var=printTag.metadata.attributes, expand=true);
	echo("&ltCFPRINT ")
	loop collection=#printTag.metadata.attributes# key="k" value="v" {
		echo( v.type & " " &  k );
		if (!v.required)
			echo('="' &  v.default &    '"');
		echo("<br> ");
	}
	echo("/&gt;")
/*
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

	*/

	samplefile = getTempFile("", "print","pdf");

	sampleMonofile = getTempFile("", "mono-test","pdf");
	sampleColorFile = getTempFile("", "color-test","pdf");
	
	cfdocument(format="PDF" filename="#sampleColorfile#" overwrite=true){
		echo("<h1 style='color:red'>Hi from lucee #server.lucee.version#</h1>");
	}

	cfdocument(format="PDF" filename="#sampleMonofile#" overwrite=true){
		echo("<h1>Hi from lucee #server.lucee.version#</h1>");
	}

	echo("<h2>Color test</h2>");

	try {
		printTag.onStartTag({
			printer:"Canon TS3100 series",
			source: sampleColorfile,
			color: true
		});
	} catch (e){
		echo(e);
	}

	echo("<h2>Mono test</h2>");
	try {
		printTag.onStartTag({
			printer:"Canon TS3100 series",
			source: sampleMonofile,
			color: false
		});
	} catch (e){
		echo(e);
	}
</cfscript>
