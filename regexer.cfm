<cfsetting enablecfoutputonly="true">
<!---
Copyright 2008 Kavitha Nelson
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
<cftry>
	<cfset result=StructNew()>
	<cfset jsonRes="">
	<cfset scopeVar=result>
	<cfset regexResult="">

	<cfparam name="url.expression" type="string">
	<cfloop from="1" to="#regexer.numTests#" index="i">
		<cfset varName="testdata#i#">
		<cfparam name="url[varName]" default="">
	</cfloop>

	<cfloop from="1" to="#regexer.numTests#" index="i">
		<cfset testdata=url["testdata#i#"]>
		<cfset regexResult="">
		<cfset currResult=CreateObject("java", "java.lang.StringBuffer")>
		<cfif len(testdata)>
			<cfset regexResult=REFind(url.expression, testdata, 1, true)>
			<cfloop from="1" to="#arraylen(regexResult.len)#" index="res">
				<cfif (res GT 1) or (regexResult.pos[res] GT 0)>
					<cfset currResult.append("<tr>")>
					<cfset currResult.append("<td class=""regexernum"">").append(NumberFormat(res, "9.")).append("</td>")>
					<cfset currResult.append("<td class=""regexerpos"">").append(regexResult.pos[res]).append("</td>")>
					<cfset currResult.append("<td class=""regexerlen"">").append(regexResult.len[res]).append("</td>")>
					<cfset currResult.append("<td class=""regexertext"">")>
					<cfif regexResult.pos[res] GT 0>
						<cfset currResult.append(HTMLEditFormat(mid(testdata, regexResult.pos[res], regexResult.len[res])))>
					<cfelse>
						<cfset currResult.append("&nbsp;")>
					</cfif>
					<cfset currResult.append("</td>")>
					<cfset currResult.append("</tr>")>
				</cfif>
			</cfloop>
			<!--- if the above results in output data, add the header and footer of the table --->
			<cfif currResult.length()>
				<cfset header=CreateObject("java", "java.lang.StringBuffer")>
				<cfset header.append("<table id=""regexerresults#i#"" class=""regexerresults"" cellpadding=""0"" cellspacing=""0"">")>
				<cfset header.append("<thead><tr>")>
				<cfset header.append("<th class=""regexernum"">##</th>")>
				<cfset header.append("<th class=""regexerpos"">Pos</th>")>
				<cfset header.append("<th class=""regexerlen"">Len</th>")>
				<cfset header.append("<th class=""regexertext"">Matching Result</th>")>
				<cfset header.append("</tr></thead><tbody>")>
				<cfset currResult.insert(0, header.toString()).append("</tbody></table>")>
			<cfelse>
				<cfset currResult.append("<strong>No Match</strong>")>
			</cfif>
			<!--- <cfdump var="#regexResult#"><cfdump var="#currResult#"><cfabort> --->
		</cfif>
		<cfset scopeVar["testresult#i#"]=currResult.toString()>
	</cfloop>
	<!--- <cfdump var="#url#"><cfdump var="#scopeVar#"><cfabort> --->
	<!--- <cfinvoke component="json" method="encode" data="#scopeVar#" returnvariable="jsonRes" /> --->
	<cfset jsonRes=SerializeJSON(scopeVar)>
	<cfcontent reset="true"><cfoutput>#jsonRes#</cfoutput>
<cfcatch>
	<!--- <cfdump var="#cfcatch#"><cfdump var="#url#"><cfdump var="#scopeVar#"> --->
	<cfoutput>#cfcatch.message#<br />#cfcatch.detail#</cfoutput>
</cfcatch>
</cftry>
<cfsetting enablecfoutputonly="false">