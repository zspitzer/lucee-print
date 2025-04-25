<h1>getPrinterInfo()</h1>
<p>only supports local printers</p>
<div>
	<a href="https://docs.lucee.org/reference/functions/getprinterlist.html">getPrinterList()</a>
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

	dump("PrintServiceLookup::lookupPrintServices")

	printers = print.list();

	arrayEach(printers, function(printer){
		echo('<a href="###urlEncode(printer.getName())#">#printer.getName()#</a>&nbsp;');
	});

	arrayEach(printers, function(printer){
		echo('<h2 id="#urlEncode(printer.getName())#">#printer.getName()#</h2>');

		//dump(var=printer, expand=true);

		var a = printer.getAttributes().toArray();
		echo("<b>getAttributes()</b><ul>")
		arrayEach(a, function(att){
			echo("<li>" & att.getName() & " :: " & att.getValue() & " " );

		})
		echo("</ul>");


		var ac = printer.getSupportedAttributeCategories();
		echo("<b>getSupportedAttributeCategories()</b><ul><li>")
		arrayEach(ac, function(att){
			//echo("<li>" & att.getCategory() & " " &  att.getName() & " " & att.getValue() & " " );
			echo(listlast(att.getName(),".") & " " );
		})
		echo("</ul>");

		/*
		var docs = printer.getSupportedDocFlavors();
		echo("<b>getSupportedDocFlavors()</b><ul>")
		arrayEach(docs, function(doc, idx){
			echo("<li>" & doc.getMimeType() & ", "
				//& doc.getMediaType() & ", "
				//& doc.getMediaSubType() & ", "
				& doc.getRepresentationClassName() & ", "
				& doc.toString() & " ");
		});
		echo("<li>Types<ul>")
		arrayEach(docs[1].getClass().getFields(), function(d, idx){
			echo("<li>" & d.getName());
		})
		echo("</ul></li>")
		echo("</ul>")
		*/

	});


</cfscript>
