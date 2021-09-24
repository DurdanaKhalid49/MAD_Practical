B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=4
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: True
	#IncludeTitle: False
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
Dim timer1 As Timer
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
Dim  introwel As MediaPlayer 
Dim TTS As ICOSTextToSpeech

	Dim ProgressBar1 As ProgressBar
	Dim num As Int
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	'Activity.LoadLayout("intro")
	introwel.Initialize2("introwel")
	introwel.Load(File.DirAssets, "intro.mp3")
		timer1.Initialize("timer1",50)
	timer1.Enabled = True
'	TTS.InitializeTTs("tts", "English")
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub
Sub timer1_tick


End Sub

