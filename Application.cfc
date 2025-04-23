component {
	function onRequestStart(template){
		if (template != "index.cfm") 
			include template="menu.cfm";
	}
}