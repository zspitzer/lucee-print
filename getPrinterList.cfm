<h1>getPrinterList()</h1>
<p>only supports local printers</p>
<div>
	Docs: <a href="https://docs.lucee.org/reference/functions/getprinterlist.html">Lucee</a> |
	<a href="https://helpx.adobe.com/coldfusion/cfml-reference/coldfusion-functions/functions-e-g/getprinterlist.html">ACF</a>
</div>
<hr>
<cfscript>
	dump(var = getPrinterList(), label="Lucee BIF getPrinterList()");
	print = new component {
		import javax.print.PrintServiceLookup;

		function list(){
			var services = PrintServiceLookup::lookupPrintServices(nullValue(), nullValue());
			return services;
		}
	}

	echo("<hr>");

	echo("<h2>PrintServiceLookup::lookupPrintServices</h2>")

	printers = print.list();

	arrayEach(printers, function(printer){
		dump(var=printer.getName());
	});


</cfscript>
