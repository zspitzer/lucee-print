component {
	import java.io.FileInputStream;
	import javax.print.attribute.HashPrintRequestAttributeSet;
	import javax.print.attribute.HashDocAttributeSet;
	import javax.print.attribute.standard.Chromaticity;
	import javax.print.attribute.standard.Copies;
	import javax.print.attribute.standard.Fidelity;
	import javax.print.attribute.standard.JobName;
	import javax.print.attribute.standard.MediaSizeName;
	import javax.print.attribute.standard.PageRanges;
	import javax.print.DocFlavor;
	import javax.print.PrintServiceLookup;
	import javax.print.SimpleDoc;
	import java.util.Locale;

	public function print( string printer, string paper){
		var attr = new HashPrintRequestAttributeSet();
		attr.add(new JobName( listLast(arguments.source, "/\"), Locale::US ));
		var docAttr = new HashDocAttributeSet();
		if ( len( arguments.color ) )
			docAttr.add( arguments.color ? Chromaticity::COLOR : Chromaticity::MONOCHROME );
		if ( len( arguments.copies ) )
			attr.add(new Copies(arguments.copies ) );
	//	if ( len( arguments.fidelity ) )
	//		attr.add(arguments.fidelity ? Fidelity::Fidelity_TRUE : Fidelity::Fidelity_FALSE );
	//	if ( len( arguments.pages ) )
	//		attr.add( getPages( arguments.pages ) );
		if ( len( arguments.paper ) )
			attr.add( getMedia( arguments.paper ).get(nullValue()) );
		

		dumpAttr(var=attr, label="RequestAttr");
		dumpAttr(var=docAttr, label="DocAttr");
		var flavor = createObject("java", "javax.print.DocFlavor$INPUT_STREAM").AUTOSENSE; // DocFlavor::INPUT_STREAM; // i.e. pdf
		dump(flavor.toString());
		//var services = PrintServiceLookup::lookupPrintServices( flavor, attr );
		var PrintService = findPrinter( arguments.printer, attr );
		/*
		supportedFlavors = PrintService.getSupportedDocFlavors();
		echo("<p><b>Supported flavours</b></p>");
		for (flavor in supportedFlavors) {
			dump(flavor.getMimeType());
		}
		*/
	//	dump(PrintService);

		var printJob = PrintService.createPrintJob();
		var fis = new FileInputStream( arguments.source );
		//dump(fis);
		var flavor = createObject("java", "javax.print.DocFlavor$INPUT_STREAM").AUTOSENSE;
		
		var doc = new SimpleDoc( fis, flavor, docAttr );
		//dump(printJob);
		var printJobListener = new javaxPrintJobListener( logger, getPageContext() );
		printjob.addPrintJobListener( printJobListener );
		printJob.print(doc, attr );

	}

	private function findPrinter( printer, attr ){
		var flavor = createObject("java", "javax.print.DocFlavor$INPUT_STREAM").AUTOSENSE; // DocFlavor::INPUT_STREAM; // i.e. pdf
		dump(flavor.toString());
		// var services = PrintServiceLookup::lookupPrintServices( flavor, attr );
		var services = PrintServiceLookup::lookupPrintServices( nullvalue(), nullvalue() );
		var serviceNames = [];
		loop array="#services#" item="local.service" {
			if ( service.getName() eq arguments.printer )
				return service;
			arrayappend( serviceNames, service.getName() );
		}
		throw "Could not find a printer named [#arguments.printer#], available printers are [#serviceNames.toList(", ")#]";
	}

	private function getColor( string color ){
		return new Chromaticity(  );
	}

	private function getPages( string pages ){
		return new PageRanges( arguments.pages );
	}

	private function getMedia( string paper ){

		var mediaSizeNameClass = createObject("java", "javax.print.attribute.standard.MediaSizeName");
		var fields = mediaSizeNameClass.getClass().getFields();
		var st = [=];
		for ( var field in fields ){
			if ( arguments.paper eq field.getName() ) return field;
			st [field.getName() ] = field;
		}
		if ( listLen( arguments.paper,"_" eq 1 ) ){
			loop list="ISO,NA" item="local.prefix"{
				var key = prefix  & "_" & arguments.paper;
				if ( structKeyExists(st, key ) )
					return st[ key ];
			}
		}
		throw "Unsupported paper type [#arguments.paper#], available types are [#structKeyList(st, ", ")#]";
	}

	function dumpAttr(var, label){
		echo("<p><b>#label# Attributes </b></p>");
		var attr = var.toArray()
		for (var a in attr)
			dump(var=a.getName() & ": " & a.toString(), label=label);
	}

	private void function logger(pc, type, mess, event){
		// any errors here are currently hidden
		// also the pageContext is not available so we have to pass it in
		try {
			pc.write( "<b>#type#</b>: #mess# <br>");
			pc.flush();
		} catch (e){
			systemOutput(e);
		}
	}
}