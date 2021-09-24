B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.1
@EndOfDesignText@
'#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
Sub Class_Globals
	Private B4XTable1 As B4XTable
	Private xChart1 As xChart
	Private CountryColumn, GraphColumn As B4XTableColumn
	Private parser As CSVParser
	Private xui As XUI
	Private CountriesData As B4XOrderedMap
	Type CountryDataPoint (Date As Long, TotalCases As Int, TotalDeaths As Int, Country As String)
	Private btnRefresh As B4XView
	Private lblDate As B4XView
	Private LastMaxDate As Long
	Private B4XSwitch1 As B4XSwitch
End Sub

Public Sub Initialize (Parent As B4XView)
	
	
	parser.Initialize
	Parent.LoadLayout("graph")
	DateTime.DateFormat = "yyyy-MM-dd"
	CountriesData.Initialize
	LoadData(File.ReadString(File.DirAssets, "full_data.csv"))
	DownloadAndLoad
End Sub

Sub B4XTable1_DataUpdated
	For i = 0 To B4XTable1.VisibleRowIds.Size - 1
		Dim RowId As Long = B4XTable1.VisibleRowIds.Get(i)
		Dim pnl As B4XView = GraphColumn.CellsLayouts.Get(i + 1) '+1 because of header layout
		Dim ChartParent As B4XView = pnl.GetView(1)
		If RowId > 0 Then
			ChartParent.SetLayoutAnimated(0, 0, 0, pnl.Width, pnl.Height) 
			ChartParent.Visible = True
			Dim Chart As xChart = ChartParent.Tag
			'this is only needed in B4A as the Base_Resize event will be raised automatically in B4J and B4i.
			If xui.IsB4A Then Chart.Base_Resize(ChartParent.Width, ChartParent.Height) 
			Chart.ClearData
			Chart.AddLine("Cases", xui.Color_Blue)
			Chart.AddLine("Deaths", xui.Color_Red)
			Dim Country As String = B4XTable1.GetRow(RowId).Get(CountryColumn.Id)
			AddPointsToChart(CountriesData.Get(Country), Chart)
			Chart.DrawChart
		Else
			ChartParent.Visible = False
		End If
	Next
End Sub


Sub PrepareTable
	B4XTable1.Clear
	CountryColumn = B4XTable1.AddColumn("Country", B4XTable1.COLUMN_TYPE_TEXT)
	CountryColumn.Width = 100dip
	GraphColumn = B4XTable1.AddColumn("Graph", B4XTable1.COLUMN_TYPE_VOID)
	B4XTable1.MaximumRowsPerPage = 10
	B4XTable1.BuildLayoutsCache(B4XTable1.MaximumRowsPerPage)
	B4XTable1.RowHeight = 150dip
	For i = 1 To B4XTable1.MaximumRowsPerPage
		Dim pnl As B4XView = GraphColumn.CellsLayouts.Get(i)
		Dim p As B4XView = xui.CreatePanel("")
		pnl.AddView(p, 0, 0, Max(10dip, pnl.Width), Max(10dip, pnl.Height))
		p.LoadLayout("Chart")
		p.Tag = xChart1
	Next
End Sub

Sub LoadData (csv As String)
	Dim TableData As List
	TableData.Initialize
	If ReadCountriesData(csv, TableData) = False Then
		Log("No new data")
		Return
	End If
	PrepareTable
	B4XTable1.SetData(TableData)
End Sub


Sub ReadCountriesData (csv As String, TableData As List) As Boolean
	Log("Read countries data")
	Dim Data As List = parser.Parse(csv, ",", True)
	Dim CurrentCountry As String
	Dim NewData As B4XOrderedMap
	NewData.Initialize
	Dim MaxDate As Long
	For Each row() As String In Data
		Dim Country As String = row(1)
		If row(4) = "" Then row(4) = "0"
		If row(5) = "" Then row(5) = "0"
		If Country <> CurrentCountry Then
			CurrentCountry = Country
			Dim CountryDataPoints As List
			CountryDataPoints.Initialize
			NewData.Put(CurrentCountry, CountryDataPoints)
		End If
		Dim Date As Long = DateTime.DateParse(row(0))
		MaxDate = Max(MaxDate, Date)
		CountryDataPoints.Add(CreateCountryDataPoint(Date, row(4), row(5), Country))
	Next
	NewData.Keys.Sort(True)
	For Each c As String In NewData.Keys
		TableData.Add(Array(c))
	Next
	lblDate.Text = $"Dataset date: $date{MaxDate}"$
	If LastMaxDate <> MaxDate Then
		LastMaxDate = MaxDate
		CountriesData = NewData
		Return True
	Else
		Return False
	End If
End Sub

Sub AddPointsToChart (Points As List, Chart As xChart)
	For Each cdp As CountryDataPoint In Points
		Chart.AddLineMultiplePoints(DateTime.Date(cdp.Date), Array As Double(cdp.TotalCases, cdp.TotalDeaths), False)
	Next
End Sub

Public Sub Resize
	B4XTable1_DataUpdated
End Sub

Public Sub CreateCountryDataPoint (Date As Long, TotalCases As Int, TotalDeaths As Int, Country As String) As CountryDataPoint
	Dim t1 As CountryDataPoint
	t1.Initialize
	t1.Date = Date
	t1.TotalCases = TotalCases
	t1.TotalDeaths = TotalDeaths
	t1.Country = Country
	Return t1
End Sub

Sub btnRefresh_Click
	DownloadAndLoad
End Sub

Sub DownloadAndLoad
	btnRefresh.Enabled = False
	lblDate.Text = "Loading..."
	Dim j As HttpJob
	j.Initialize("", Me)
	j.Download("https://covid.ourworldindata.org/data/ecdc/full_data.csv")
	Wait For (j) JobDone (j As HttpJob)
	lblDate.Text = ""
	If j.Success Then
		LoadData(j.GetString)
	Else
		xui.MsgboxAsync("Error downloading data", "")
	End If
	btnRefresh.Enabled = True
End Sub

