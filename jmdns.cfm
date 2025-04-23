<cfscript>
	param name="url.app" default="";
	param name="url.servicedomain" default="";
	param name="url.protocol" default="";
	param name="url.ip" default="192.168.178.20";
</cfscript>
<html>
<head>
	<title>jmdns client</title>
</head>
<body>
<h1>jmdns client</h1>

<div>
	<a href="https://github.com/jmdns/jmdns">https://github.com/jmdns/jmdns</a> |
	<a href="https://javadoc.io/doc/org.jmdns/jmdns/latest/index.html">javadocs</a>
</div>
<hr>
<cfoutput>
	<form action="#cgi.script_name#">
		<label>
			Ip: <input type=text name=ip value="#encodeForHtmlAttribute(url.ip)#">
		</label>
		<label>
			App: <input type=text name=app value="#encodeForHtmlAttribute(url.app)#">
		</label>
		<label>
			Protocol: <input type=text name=protocol value="#encodeForHtmlAttribute(url.protocol)#">
		</label>
		<label>
			ServiceDomain: <input type=text name=serviceDomain value="#encodeForHtmlAttribute(url.serviceDomain)#">
		</label>
		<input type="submit" name="go" value="list services">
		<input type="submit" name="go" value="discover types">
	</form>
</cfoutput>

<cfscript>
	param name="url.go" default="";

	systemOutput("start jmdns", true);

	jmdns = new jmDNSClient();

	switch( url.go ){
		case "list services":
			result = jmdns.listServices(url.ip, url.app, url.protocol, url.servicedomain);
			break;
		case "discover types":
			result = jmdns.discoverTypes();
			break;
		default:
			abort;
	}

	name = listLast( getMetaData( result ).name, "." );

	switch (name){
		case "jmDNSServiceTypeListener":
			displayTypes( result.getServiceTypes() );
			dump( result.getServiceTypes() );
			dump( result.getServiceSubTypes() );
			dump( result.getLog() );
			break;
		case "jmDNSServiceListener":
			dump( result.getServices() );
			dump( result.getServicesDetail() );
			dump( result.getLog() );
			break;
		default:
			throw "unknown result [#name#]";
	}

	function displayTypes( struct serviceTypes ){
		echo("<ul>");
		structEach( serviceTypes, function( key ){
			echo("<li><a href='?app=#key#&go=list%20Services'>#key#</a></li>");
		});
		echo("</ul>")
	}

	systemOutput("finished jmdns", true);

</cfscript>
</body>
</html>