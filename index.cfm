<cfsetting enablecfoutputonly="true">
<!---
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--->
<cfparam name="form.expression" default="">
<cfloop from="1" to="#regexer.numTests#" index="i">
	<cfset varName="testdata#i#">
	<cfparam name="form[varName]" default="">
</cfloop>

<cfsavecontent variable="header"><cfoutput>
<style type="text/css">
	body {font: 71%/1.5em  Verdana, 'Trebuchet MS', Arial, Sans-serif;}
	form {background-color: ##fafafa; border:1px solid ##f2f2f2;}
	fieldset {padding:15px;}
	input {margin-bottom:5px; font-family: Verdana,sans-serif; font-size: 1em;}
	.regexerresult {list-style-type:none;}
	.regexerresults {padding:0; margin:0 0 7px 30px;}
	th {background-color:##ccc;}
	.regexernum, .regexerpos, .regexerlen, .regexertext {border:thin ##999 dotted; padding:3px;}
	.regexernum, .regexerpos, .regexerlen {text-align:right; float:left; width:20px;}
	.regexernum {font-weight:bold;}
	.regexertext {width:400px;}
	div##expressions {display:none;}
	div##expressions ul li {cursor:pointer; font-family:monospace; font-size:1.2em;}
	.hideshow {font-size:.8em; font-weight:normal;}
</style>
<script src="jquery.js" type="text/javascript"></script>
<script type="text/javascript">
jQuery(function($) {
	// on DOM ready
	$('##submitBtn').bind('click', SubmitExpression);
	// bind the click to the div b/c the list items are created dynamically and therefore cannot be directly bound here
	$('div##expressions').click(function(e) {
		if (jQuery(e.target).is('li')) {
			SetExpression(e.target);
		}
	});
});

function SetExpression(target) {
	jQuery("input##expression").val(jQuery(target).text());
}

function SubmitExpression() {
	var expression=jQuery("input##expression").val();
	jQuery("div##expressions ul").prepend("<li>"+expression+"</li>");
	// the div is hidden by default, so let's make sure it is visible
	jQuery("div##expressions").show();
	<cfloop from="1" to="#regexer.numTests#" index="i">var testdata#i#=jQuery("input##testdata#i#").val();</cfloop>
	jQuery.getJSON('regexer.cfm', {<cfloop from="1" to="#regexer.numTests#" index="i">testdata#i#:testdata#i#,</cfloop>expression:expression}, loadResults);
	// don't continue with form submit
	return false;
}

function loadResults(data) {
	jQuery.each(data, function(key, value) {
		if (jQuery('##'+key) != null) {
			jQuery('##'+key).html(value);
		}
	});
}

function togglehelpfulsites() {
	jQuery('div##helpfulsites ul').toggle();
	if (jQuery('div##helpfulsites ul').is(":visible")) {
		jQuery('div##helpfulsites a:first').text('hide');
	} else {
		jQuery('div##helpfulsites a:first').text('show');
	}
}
</script>
</cfoutput></cfsavecontent>
<cfhtmlhead text="#header#">

<cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-type" content="text/html; charset=iso-8859-1" />
<title>RegExer #regexer.version#</title>
</head>

<body>
	<h1>RegExer</h1>
	<h2>Regular Expression Tester for ColdFusion</h2>
	<div id="helpfulsites">
		<h3>Helpful Sites <span class="hideshow" id="helpfulsitestoggle">[<a href="##" onclick="javascript:togglehelpfulsites()">hide</a>]</span></h3>
		<ul>
			<li><a href="http://www.regular-expressions.info/reference.html" target="_blank">Regular Expressions Reference (regular-expressions.info)</a></li>
			<li><a href="http://www.petefreitag.com/item/517.cfm" target="_blank">Regular Expressions with ColdFusion - a Howto Guide</a></li>
			<li><a href="http://regexlib.com/CheatSheet.aspx" target="_blank">RegExLib.com Regular Expression Cheat Sheet</a></li>
			<li><a href="http://www.ilovejackdaniels.com/cheat-sheets/regular-expressions-cheat-sheet/" target="_blank">ILoveJackDaniels.com Regular Expressions Cheat Sheet</a></li>
			<li><a href="http://www.scribd.com/doc/453776/Regular-Expression-Pocket-Reference-2nd-Edition-Jul-2007?query2=javacc+cr+lf" target="_blank">Regular Expression Pocket Reference 2nd Edition Jul 2007</a></li>
		</ul>
	</div>
	<form id="mainform">
		<fieldset>
			<label for="expression" id="lblexpression">Expression:</label>
			<input type="edit" name="expression" id="expression" value="#form.expression#" size="75" /><br />
			<cfloop from="1" to="#regexer.numTests#" index="i">
				<label for="testdata#i#">#i#.</label>
				<input type="edit" name="testdata#i#" id="testdata#i#" value="#form["testdata#i#"]#" size="75" /><br />
				<div id="testresult#i#"></div>
			</cfloop>
			<input type="submit" value="Test Regex" id="submitBtn" />
		</fieldset>
	</form>
	<div id="expressions"><h3>Recently Tested Expressions</h3><ul></ul></div>
	<p id="regexercopyright">Copyright &copy; #year(now())# Licensed under the <a href="http://www.apache.org/licenses/LICENSE-2.0" target="_blank">Apache License, Version 2.0</a>.
	<br /><a href="http://www.mkville.com/projects/RegExer?version=#URLEncodedFormat("#regexer.version#")#">RegExer</a> version #regexer.version#</p>
</body>
</html></cfoutput>
<cfsetting enablecfoutputonly="false">