B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=9.5
@EndOfDesignText@


#Region  Activity Attributes 
	#FullScreen: true
	#IncludeTitle: false
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.

	Private advWV As AdvancedWebView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("viewmap")
	
	advWV.CookiesEnabled = True
	
	advWV.GeolocationEnabled = True
	'advWV.loadUrl("https://dohph.maps.arcgis.com/apps/opsdashboard/index.html#/3dda5e52a7244f12a4fb3d697e32fd39")
	
	Dim phoneInstance  As Phone
	phoneInstance.SetScreenOrientation(0)
	'ProgressDialogShow2("waiting...",False)
	advWV.loadUrl2("https://dohph.maps.arcgis.com/apps/opsdashboard/index.html#/3dda5e52a7244f12a4fb3d697e32fd39",False)
	'ProgressDialogShow2("waiting...",False)
End Sub

Sub Activity_Resume
	advWV.loadUrl("https://dohph.maps.arcgis.com/apps/opsdashboard/index.html#/3dda5e52a7244f12a4fb3d697e32fd39")
End Sub
Sub Activity_Pause (UserClosed As Boolean)
	If UserClosed = True Then
	advWV.loadUrl("https://dohph.maps.arcgis.com/apps/opsdashboard/index.html#/3dda5e52a7244f12a4fb3d697e32fd39")
	Else
		advWV.loadUrl("https://dohph.maps.arcgis.com/apps/opsdashboard/index.html#/3dda5e52a7244f12a4fb3d697e32fd39")
	End If
End Sub

Sub AdvWv_onExternalPageRequest(url As String)
	Log($"AdvWv_onExternalPageRequest(${url})"$)
End Sub
Sub AdvWv_onPageError(errorCode As Int, description As String, failingUrl As String)
	Log($"AdvWv_onPageError(${errorCode},${description},${failingUrl})"$)
	
End Sub
Sub AdvWv_onPageFinished(url As String)
	Log($"AdvWv_onPagefinished(${url})"$)
	
End Sub
Sub AdvWv_onPageStarted(url As String, favIcon As Object)
	Log($"AdvWv_onPageStarted(${url})"$)
	
End Sub